// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract ViewsAndPureFunctions {
  uint8 blockChainValue = 42;

  function pureFunction() external pure returns (string memory) {
    return "I'm a pure function, reading nothing from the blockchain!";
  }

  function viewFunction() external view returns (uint8) {
    return blockChainValue;
  }
}
