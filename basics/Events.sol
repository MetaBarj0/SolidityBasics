// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Events {
  event Log(string message, uint256 value);

  //max 3 indexed arguments, optimization regarding storage in ethereum database
  event IndexedLog(address indexed sender, uint256 value);

  function examples() external {
    emit Log("foo", 1234);
    emit IndexedLog(msg.sender, 5678);
  }

  event Message(address indexed from, address indexed to, string message);

  function sendMessage(address to, string calldata message) external {
    emit Message(msg.sender, to, message);
  }
}
