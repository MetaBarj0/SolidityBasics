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

    it("should not be possible for the owner to create a task for free", () => {
      const [owner] = signers;

      return contract.connect(owner).createTask("Free task?")
        .should.be.revertedWithCustomError(contract, "NotEnoughEth")
        .withArgs(ethers.parseEther("0.01"));
    });

    it("should emit a TaskCreated event when the owner successfully create the first task", async () => {
      const [owner] = signers;
      const [id, definition] = [0, "paid task"];

      const createTx = await contract.connect(owner).createTask(definition, {
        value: ethers.parseEther("0.01"),
      });

      await createTx.wait();

      return createTx.should.emit(contract, "TaskCreated")
        .withArgs(id, definition);
    });
  });
});
