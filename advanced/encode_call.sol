// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

interface IERC20 {
  function transfer(address, uint256) external;
}

contract Token is IERC20 {
  function transfer(address, uint256) external {}
}

// abi.encodeCall, used with interfaces is pretty great to make decorators
// without having to instantiate contract with new.
contract AbiEncode {
  error CallFailed();

  function test(address contract_, bytes calldata data) external {
    (bool success, ) = contract_.call(data);

    require(success, CallFailed());
  }

  function encodeWithSignature(address to, uint256 amount) external pure returns (bytes memory) {
    // worst IMO
    return abi.encodeWithSignature("transfer(address,uint256)", to, amount);
  }

  function encodeWithSelector(address to, uint256 amount) external pure returns (bytes memory) {
    // better but does not safeguars against argument passing errors
    return abi.encodeWithSelector(IERC20.transfer.selector, to, amount);
  }

  function encodeCall(address to, uint256 amount) external pure returns (bytes memory) {
    // best: compile time errors if mistakes are made.
    return abi.encodeCall(IERC20.transfer, (to, amount));
  }
}
