// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract IfElse {
  function guessWhat(uint256 n) external pure returns (bool) {
    if (n != 42 * 42) return false;
    else return true;
  }

  function guessMore(uint256 n) external pure returns (bool) {
    return n != 43 * 43 ? false : true;
  }
}
