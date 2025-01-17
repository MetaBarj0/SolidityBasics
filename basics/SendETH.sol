// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract SendETH {
  constructor() payable {}

  function payMeFool() external payable {}

  function sendViaTransfer(address payable to) external payable {
    to.transfer(123);
  }

  // this one looks deprecated and not to be used anymore
  function sendViaSend(address payable to) external payable {
    bool successfullySent = to.send(123);

    require(successfullySent, "send failed");
  }

  function sendViaCall(address payable to) external payable {
    (bool success, bytes memory data) = to.call{value: 123}("dummy");

    require(success, "sendViaCall failed");
  }
}

contract ReceiveETH {
  event Log(uint256 amount, uint256 gas);

  receive() external payable {
    emit Log(msg.value, gasleft());
  }
}
