// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Mapping {
  mapping(address => uint256) public balances;
  mapping(address => mapping(address => bool)) public isFriend;

  function setupFriendship() private {
    isFriend[msg.sender][address(this)] = true;
    isFriend[address(this)][msg.sender] = true;
  }

  function examples() external {
    balances[msg.sender] = 42;
    uint256 _balance = balances[msg.sender];
    uint256 zeroBalance = balances[address(1)];
    balances[msg.sender] += 57;
    delete balances[msg.sender];

    setupFriendship();
  }
}
