// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract ForWhileLoops {
  function forFoo() external pure returns (int8) {
    int8 j;

    for (int8 i = -10; i <= 10; ++i) j += i;

    return j;
  }

  function whileBar() external pure returns (int8) {
    int8 i = -11;
    int8 j;

    while (++i <= 10) j += i;

    return j;
  }
}
