// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

// https://www.youtube.com/watch?v=wCD3fOlsGc4
contract HashFunc {
  function hash(string calldata text, uint256 num, address addr) external pure returns (bytes32) {
    // encodePacked do not respect abi spec, produces a compressed output:
    // - no zero padding to respect bytes32 layout
    // - no size information preceding string type
    // those information are lost but it does not matter as output is for
    // hashing purposes
    // WARNING: using encodePacked can lead to hash collisions due to the fact
    // some information of marshalled data are lost. For string type for
    // instance, as string length info is missing, produced has are the same
    // for "AAA" "ABBB" and "AAAA" "BBB"
    // NOTE: insert an arbitrary value between to dynamic data type
    // instances such as string
    // encodePacked is still interesting for hasing purpose and maybe
    // optimizations as the output may be significantly smaller.
    return keccak256(abi.encodePacked(text, num, addr));
  }
}
