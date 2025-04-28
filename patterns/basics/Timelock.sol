// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {Ownable} from "./Ownable.sol";

// Forces a delay before authorize an action
// Protect the community giving them some time to disengage if needed
// Can be a security measure if a hack occured, to let protocol maintainers and
// users reacting before impact.
// https://github.com/aharvet/totem-token/blob/master/contracts/TotemToken.sol
// for an example
contract TimeLock is Ownable {
  uint256 public constant GRACE_PERIOD = 1 weeks;

  address account;
  address newAccount;
  uint256 endGracePeriod;

  constructor(address owner) Ownable(owner) {}

  function launchAccountUpdate(address newAccount_) external onlyOwner {
    // Check if there already is an update waiting to be executed
    require(newAccount == address(0), "Current update has to be executed");
    newAccount = newAccount_;
    endGracePeriod = block.timestamp + GRACE_PERIOD;
  }

  function executeAccountUpdate() external onlyOwner {
    // Check that grace period has passed
    require(block.timestamp >= endGracePeriod, "Grace period has not yet finished");
    // Check that update have not already been executed
    require(newAccount != address(0), "Update already executed");

    account = newAccount;
    newAccount = address(0);
  }
}
