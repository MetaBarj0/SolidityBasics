import * as chai from "chai";
import chaiAsPromised from "chai-as-promised";
import { ethers } from "hardhat";
import { Contract, Signer } from "./utility/types.ts";

chai.use(chaiAsPromised);
chai.should();

describe("Todo contract", () => {
  let signers: Signer[];
  let contract: Contract;

  before(async () => {
    signers = await ethers.getSigners();
  });

  beforeEach(async () => {
    contract = await ethers.deployContract("Todo");
  });

  describe("Deployment", () => {
    it("should set the owner as the deployer of the contract", () => {
      const [owner] = signers;

      return contract.owner()
        .should.eventually.equal(owner);
    });
  });

  describe("Initial state", () => {
  });
});
