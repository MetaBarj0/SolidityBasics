// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

// how to create a contract instance from another contract
// Briefly talking about create and create2 (?)
// This video explains create:
// https://www.youtube.com/watch?v=J2Wp2SHq1Qo
// Another one talks about create2 (create contracts?, some sort of code
// generating tool?)

contract Account {
  address public immutable bank;
  address public immutable owner;

  constructor(address owner_) payable {
    bank = owner_;
    owner = msg.sender;
  }
}

contract AccountFactory {
  Account[] public accounts;

  function create(address owner) external payable {
    // deploy the contract
    Account account = new Account{value: 42}(owner);

    // deployed contract accessible through the accounts state variable
    accounts.push(account);
  }
}
