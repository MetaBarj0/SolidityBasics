// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Immutable {
  // when value cannot be deduced at deploy time
  // set only once at deploy time
  // gas saving, semantic correctness
  // Can also be set in an explicit constructor
  address public immutable owner = msg.sender;

  uint public x = 1;

  // less expnesive to call with immutable owner than with mutable owner
  function foo() external {
    require(msg.sender == owner);
    ++x;
  }
}
