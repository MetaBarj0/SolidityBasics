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
  });

  describe("Initial state", () => {
  });
});
