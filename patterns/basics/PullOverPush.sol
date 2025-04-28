// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {Ownable} from "./Ownable.sol";

contract PullOverPush is Ownable {
  mapping(address => uint256) public balances;

  constructor(address owner) Ownable(owner) {}

  function addBalance(address user, uint256 amount) external onlyOwner {
    balances[user] += amount;
  }

  // User can withdraw his funds at his discretion.
  // They're available at some point in time and an explicit withdraw must be
  // done for funds to be transferred.ufixed
  // The user Pull funds from contract instead of the contract Push them to the
  // user.
  function withdraw() external {
    uint256 amount = balances[msg.sender];
    require(amount > 0, "No funds to withdraw");

    balances[msg.sender] = 0;

    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
  }
}
