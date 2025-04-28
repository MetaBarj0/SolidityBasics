// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

// Prefer
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol
contract ReEntrancy {
  bool transient private entered;

  modifier reentrancyLock() {
    require(entered == false, "No re entrancy");
    entered = true;
    _;
    entered = false;
  }
}
