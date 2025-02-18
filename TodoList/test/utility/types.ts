import { ethers } from "hardhat";

type Signers = Awaited<ReturnType<typeof ethers.getSigners>>;
type Unpacked<T> = T extends (infer U)[] ? U : never;
export type Signer = Unpacked<Signers>;

const deployContractFactory = async () => await ethers.deployContract("Todo");
export type Contract = Awaited<ReturnType<typeof deployContractFactory>>;

export type ChainEvent = { args: unknown[] };
