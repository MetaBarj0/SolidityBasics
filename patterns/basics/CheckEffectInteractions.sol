// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract CEI {
  mapping(address => uint) balances;

  function withdraw(uint amount) public {
    // Check
    require(balances[msg.sender] >= amount);

    // Effect
    balances[msg.sender] -= amount;

    // Interaction last, to ensure local state of the contract is modified
    // before any external and potentially dangerous interactions.
    payable(msg.sender).transfer(amount);
  }
}
