// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

// called once when the contract is being deployed
contract Constructor {
  address public owner;
  uint256 public value;

  constructor(uint256 _value) {
    owner = msg.sender;
    value = _value;
  }
}
