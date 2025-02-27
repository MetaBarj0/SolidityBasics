// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract TestCall {
  string public message;
  uint256 public x;

  event Log(string message);

  fallback() external payable {
    emit Log("fallback was called.");
  }

  function foo(string calldata message_, uint256 x_) external payable returns (bool, uint) {
    message = message_;
    x = x_;

    return (true, 999);
  }

  // Avoid a warning. Pattern fallback/receive?
  receive() external payable {}
}

error CallFailed();

contract Call {
  bytes public data;

  function callFoo(address testCallAddress) external payable {
    (bool success, bytes memory data_) = testCallAddress.call{value: 111, gas: 5000}(
      abi.encodeWithSignature("foo(string,uint256)", "calling foo", 123)
    );

    require(success, CallFailed());

    data = data_;
  }

  function callDoesNotExist(address testCallAddress) external {
    (bool success, ) = testCallAddress.call(abi.encodeWithSignature("doesNotExist()"));

    require(success, CallFailed());
  }
}
