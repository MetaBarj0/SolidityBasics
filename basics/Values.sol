// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract ValueTypes {
  bool public b = true;
  uint256 public u = 123;
  int16 public i = -123;
  int256 public minInt = type(int256).min;
  uint256 public maxUint = type(uint256).max;
  address public addr = 0x309cB75edF869F2505383DccCCc91070322A3b25;
  bytes32 public v = 0x7ef85f45b453e13ad73259694849a5919a85548618e30d0577184d85db1da6d2;
}
