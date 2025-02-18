import { ethers } from "hardhat";

type Signers = Awaited<ReturnType<typeof ethers.getSigners>>;
type Unpacked<T> = T extends (infer U)[] ? U : never;
export type Signer = Unpacked<Signers>;

export type ChainEvent = { args: unknown[] };
