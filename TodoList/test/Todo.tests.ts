import * as chai from "chai";
import chaiAsPromised from "chai-as-promised";
import { ethers } from "hardhat";
import { Signer } from "./utility/types";
import { Todo, Todo__factory } from "../typechain-types";

chai.use(chaiAsPromised);
chai.should();

describe("Todo contract", () => {
  let signers: Signer[];
  let contract: Todo;

  before(async () => {
    signers = await ethers.getSigners();
  });

  beforeEach(async () => {
    const genericContract = await ethers.deployContract("Todo");
    contract = Todo__factory.connect(await genericContract.getAddress(), ethers.provider);
  });

  describe("Deployment", () => {
    it("should set the owner as the deployer of the contract", () => {
      const [owner] = signers;

      return contract.owner()
        .should.eventually.equal(owner);
    });
  });

  describe("Transactions", () => {
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

    it("should be possible for the owner to create several tasks if it has ethers", () => {
      const [owner] = signers;

      return Promise.all([
        createTask(contract, owner, "first task").should.emit(
          contract,
          "TaskCreated",
        ),
        createTask(contract, owner, "second task").should.emit(
          contract,
          "TaskCreated",
        ),
        createTask(contract, owner, "third task").should.emit(
          contract,
          "TaskCreated",
        ),
      ]);
    });

    it("should not be possible for the non owner to modify a task", () => {
      const [_owner, nonOwner] = signers;

      return contract.connect(nonOwner).modifyTask(0, "new definition", 0)
        .should.be.revertedWithCustomError(contract, "Unauthorized");
    });

    it("should not be possible to modify an unexisting task", () => {
      const [owner] = signers;

      return contract.connect(owner).modifyTask(0, "new definition", 2)
        .should.be.revertedWithCustomError(contract, "InvalidTaskId");
    });

    it("should emit the TaskModified event at task modification", async () => {
      const [owner] = signers;

      await createTask(contract, owner, "old definition");

      return contract.connect(owner).modifyTask(0, "new definition", 1)
        .should.emit(contract, "TaskModified")
        .withArgs(0, "new definition", 1);
    });

    it("should not be possible for a non owner to attempt to delete a task", () => {
      const [_owner, nonOwner] = signers;

      return contract.connect(nonOwner).deleteTask(0)
        .should.be.revertedWithCustomError(contract, "Unauthorized");
    });

    it("should not be possible to delete an unexisting task", () => {
      const [owner] = signers;

      return contract.connect(owner).deleteTask(0)
        .should.be.revertedWithCustomError(contract, "InvalidTaskId");
    });

    it("should emit a TaskDeleted event at task deletion", async () => {
      const [owner] = signers;

      await createTask(contract, owner, "definition");

      return contract.connect(owner).deleteTask(0)
        .should.emit(contract, "TaskDeleted")
        .withArgs(0);
    });

    it("should be possible for the owner to delete one task and get refunded", async () => {
      const [owner] = signers;

      const oldBalance = await ethers.provider.getBalance(owner);

      const createTaskReceipt = await createTask(
        contract,
        owner,
        "task definition",
      );

      const createTaskFee = BigInt(createTaskReceipt!.gasUsed) *
        createTaskReceipt!.gasPrice;

      const deleteTaskReceipt = await deleteTask(contract, owner, 0n);
      const deleteTaskFee = BigInt(deleteTaskReceipt!.gasUsed) *
        deleteTaskReceipt!.gasPrice;

      const newBalance = await ethers.provider.getBalance(owner);

      return newBalance.should.equal(
        oldBalance - createTaskFee - deleteTaskFee,
      );
    });
  });
});

async function createTask(contract: Todo, owner: Signer, definition: string) {
  const tx = await contract.connect(owner).createTask(
    definition,
    {
      value: ethers.parseEther("0.01"),
    },
  );

  return tx.wait();
}

async function deleteTask(contract: Todo, owner: Signer, taskId: bigint) {
  const tx = await contract.connect(owner).deleteTask(taskId);

  return tx.wait();
}
