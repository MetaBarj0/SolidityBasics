// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Ownable} from "./Ownable.sol";

// Kinda DNS for contract address (or EOAs).ufixed
// Might be used to update contract implementation but unadvised to do so
// Hey UniswapV2 Factory
contract Registry is Ownable {
  mapping(string => address) private registry;

  constructor(address owner) Ownable(owner) {}

  function register(string memory name, address contractAddress) public onlyOwner {
    registry[name] = contractAddress;
  }

  function getAddress(string memory name) public view returns (address) {
    return registry[name];
  }
}
