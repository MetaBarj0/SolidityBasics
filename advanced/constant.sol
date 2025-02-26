// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Constant {
  // less expensive than exposing as state variables
  // main benefit is gas saving and of course semantic correctness regarding
  // immutability
  address public constant THIS = address(0);
  uint8 public constant ANSWER = 42;
}
