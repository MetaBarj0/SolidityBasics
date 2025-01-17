// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

// public: accessible by anyone
// private: accessible only within the contract
// internal: accessible by the contract and its descendant
// external: accessible only from external contracts (not EOAs)
//           one could eventually access to external defined function using this.externalFunction() call
//           but it's ot advisable as particularly gas inefficient.

// don't do that
contract B {
  function foo() external pure virtual {}
}

contract D is B {
  function foo() external pure override {}

  function bar() external view {
    this.foo();
  }
}
