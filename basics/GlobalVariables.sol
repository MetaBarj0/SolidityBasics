// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract GlobalVariable {
  function globalVars()
    public
    view
    returns (
      address,
      uint256,
      uint256
    )
  {
    address sender = msg.sender;
    uint256 timestamp = block.timestamp;
    uint256 blockNumber = block.number;

    return (sender, timestamp, blockNumber);
  }
}
