// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// Prefer
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
contract CallingContract {
  function transfer(address to, uint amount) external {
    // transfer logic before...

    IOnReceived(to).onReceived(msg.sender, amount);
  }
}

interface IOnReceived {
  function onReceived(address from, uint amount) external;
}

contract CalledContract is IOnReceived {
  function onReceived(address from, uint amount) external {
    // Do stuff:
    // - event emit
    // - business logic
    // - ...
  }
}
