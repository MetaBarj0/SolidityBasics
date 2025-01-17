// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract StateAndLocalVariables {
  uint256 public stateVariable = 42;
  address public someAddress;

  function f() external returns (address) {
    int256 a = 41;
    int256 b = 1;

    a + b;

    someAddress = address(42);

    return someAddress;
  }
}
