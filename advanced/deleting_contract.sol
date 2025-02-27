// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Kill {
  constructor() payable {}

  // selfdestruct is deprecated now because considered dangerous if misused. An
  // alternative more secure and responsible approach consist in manage
  // contract deactivation using internal state. We can then delete all
  // internal state to get gas refund once the contract is deactivated.
  function kill() external {
    selfdestruct(payable(msg.sender));
  }
}
