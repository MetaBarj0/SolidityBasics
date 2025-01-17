// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract ErrorManagement {
  function testRequire(int8 i) external pure {
    require(i >= -10 && i <= 10, "`i` is required to be in [-10, 10]");
  }

  function testRevert(int8 i) external pure {
    if (i < -10 || i > 10) revert("`i` is required to be in [-10, 10]");
  }

  uint8 public num = 123;

  function testAssert(uint8 newNum) external {
    num = newNum;
    assert(num <= 123);
  }

  error customError(address caller, string msg, uint8 v);

  function testCustomError(uint8 i) external {
    if (i > 10) revert customError(msg.sender, "Bad value for `i`.", i);

    num = i;
  }
}