// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Fallback {
  // executed when a call to a non existing function is done
  // Usually used to send ethers
  fallback() external payable {}

  // Difference with fallback:
  // called when sent data is empty
  receive() external payable {}

  /*
   *   ethers are sent to the contract
   *                 |
   *         is msg.data empty?
   *           /           \
   *         yes            no
   *         /               \
   * receive() exists ?  fallback()
   *     /      \
   *   yes       no
   *   /          \
   * receive()  fallback()
   */

  // those function can be called when transacting directly with the contract
  // (no function call)
}
