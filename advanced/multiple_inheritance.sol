// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

// order of inheritance is important ans should be from most base to most
// derived types.
// Personnal notes, I discourage the use of this technique

/*
 *   X
 *  /|
 * / |
 * Y |
 * \ |
 *  `Z
 */

contract X {
  function foo() public pure virtual returns (string memory) {
    return "X";
  }

  function bar() public pure virtual returns (string memory) {
    return "X";
  }

  function x() public pure returns (string memory) {
    return "X";
  }
}

contract Y is X {
  function foo() public pure virtual override returns (string memory) {
    return "Y";
  }

  function bar() public pure virtual override returns (string memory) {
    return "Y";
  }

  function y() public pure returns (string memory) {
    return "Y";
  }
}

contract Z is X, Y {
  function foo() public pure override(X, Y) returns (string memory) {
    return "Z";
  }

  function bar() public pure override(X, Y) returns (string memory) {
    return "Z";
  }

  function z() public pure returns (string memory) {
    return "Z";
  }
}
