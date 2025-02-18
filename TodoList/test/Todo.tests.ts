import * as chai from "chai";
import chaiAsPromised from "chai-as-promised";
import { ethers } from "hardhat";
import { Signer } from "./utility/types.ts";
import { Todo } from "../typechain-types/index.ts";

chai.use(chaiAsPromised);
chai.should();

describe("Todo contract", () => {
  let signers: Signer[];
  let contract: Todo;

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

  describe("Transcations", () => {
    it("should not be possible to create a task if the sender is not the owner", () => {
      const [_, notOwner] = signers;

      return contract.connect(notOwner).createTask("a task")
        .should.be.revertedWithCustomError(contract, "Unauthorized");
    });
  });
});
