// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

// Allow a contract to call another contract and stay in the context of the
// caller contract
// Use cases: update the logic of a contract doing delegated calls without
//            modifying its code. Contracts being delegated call can be viewed
//            as implementation details.

// Regular call:
// A calls B, sends 100 wei
//         B calls C, sends 50 wei
// A------>B------>C
//                 | msg.sender == B
//                 | msg.value == 50
//                 | executes codes on C's state variables
//                 | uses ETH in C's balance

// Delegated call:
// A calls B, sends 100 wei
//         B delegate calls C
// A------>B--------------->C
//                          | msg.sender == A
//                          | msg.value == 100
//                          | executes code on B's state variables
//                          | uses ETH in B

contract TestDelegateCall {
  uint256 public num;
  uint256 public value;
  address public sender;

  function setVars(uint num_) external payable {
    num = num_;
    sender = msg.sender;
    value = msg.value;
  }
}

// NOTE: layout of contracts should be the same, otherwise, undefined
// behavior
// Same layout means same state variables in the same order. But I think I can
// add some new state variable after common state variables. Need to verify.
contract DelegateCall {
  // in context of delegated calls, these are state variables that will be
  // modified, not the state variable of the called contract's functions.
  uint256 public num;
  uint256 public value;
  address public sender;

  error DelegateCallFailed();

  function setVars(address testDelegateCall, uint num_) external payable {
    // testDelegateCall.delegatecall(abi.encodeWithSignature("setVars(uint256)", num_));

    // a better way to specify the function to call, less error-prone
    (bool success, ) = testDelegateCall.delegatecall(
      abi.encodeWithSelector(TestDelegateCall.setVars.selector, num_)
    );

    require(success, DelegateCallFailed());
  }
}
