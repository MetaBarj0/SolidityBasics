// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Functions {
  function add(uint256 x, uint256 y) external pure returns (uint256) {
    return x + y;
  }

  function sub(uint256 x, uint256 y) external pure returns (uint256) {
    if (x < y) revert("Nope!");

    return x - y;
  }
}
