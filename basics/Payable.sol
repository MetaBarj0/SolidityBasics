// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Payable {
  address payable public owner;

  constructor() payable {
    owner = payable(msg.sender);
  }

  // any payable function can deposit on the contract balance address
  // In remix, you have to set the `value` field either at contract deployment
  // or when calling the `deposit` function
  function deposit() external payable {}

  function getBalance() external view returns (uint256 contractBalance, uint256 ownerBalance) {
    return (address(this).balance, owner.balance);
  }
}
