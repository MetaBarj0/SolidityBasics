import chai from "chai";
import chaiAsPromised from "chai-as-promised";
import { ethers } from "hardhat";
import { before, beforeEach, describe, it } from "mocha";
import { VerifySignature } from "../typechain-types";

chai.use(chaiAsPromised);

chai.should();

describe("verify signature", () => {
  let signers: Awaited<ReturnType<typeof ethers.getSigners>>;
  let contract: VerifySignature;

  before(async () => {
    signers = await ethers.getSigners();
  });

  beforeEach(async () => {
    const factory = await ethers.getContractFactory("VerifySignature");
    contract = await factory.deploy();

    await contract.waitForDeployment();
  });

  it("should successfully verify a signer message", async () => {
    const [signer, to] = signers;
    const amount = 42n;
    const message = "Hello there!";
    const nonce = 123n;
    const messageHash = await contract.getMessageHash(to, amount, message, nonce);
    const signature = await signer.signMessage(ethers.getBytes(messageHash));

    return Promise.all([
      contract.verify(signer, to, amount, message, nonce, signature)
        .should.eventually.be.true,
      contract.verify(signer, to, amount + 1n, message, nonce, signature)
        .should.eventually.be.false,
    ]);
  });
});
