// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// This is one of the foundation of HTLC and atomic swaps
contract CommitReveal {
  bytes32 public commitment;

  function commit(bytes32 _commitment) external {
    commitment = _commitment;
  }

  // not restricted to string, anything that could be encoded would do
  function reveal(string memory value) external view {
    require(commitment != bytes32(0), "No commitment");

    // everyone can see value here
    if (keccak256(abi.encodePacked(value)) == commitment) {
      // do stuff:
      // - emit events
      // - transfer
      // - call
      // ...
    }
  }
}
