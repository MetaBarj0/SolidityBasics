// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Enums {
  enum ShippingStatus {
    None,
    Pending,
    Shipped,
    Completed,
    Rejected,
    Canceled
  }

  ShippingStatus private status;

  function get() public view returns (ShippingStatus) {
    return status;
  }

  function set(ShippingStatus _status) public {
    status = _status;
  }
}
