// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract Roulette {
  constructor() payable {}

  function spin() external payable {
    require(msg.value > 0);

    // Bad practive to rely on timestamp especially with small time step values
    // (here 7 seconds)
    // Never ever use a time slice whose length is less than a block lifetime
    // in second (as of today, arounds 12 seconds) because validators can
    // re-order blocks to their advantage (MEV)
    // More than 15 seconds (15 seconds rule) should be good here. May evolve
    // in the future.
    if (block.timestamp % 7 == 0) {
      payable(msg.sender).transfer(address(this).balance);
    }
  }
}
