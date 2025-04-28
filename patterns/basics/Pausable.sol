// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {Ownable} from "./Ownable.sol";
import {IPausable} from "./IPausable.sol";

// Prefer
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Pausable.sol
contract Pausable is Ownable, IPausable {
  bool public paused;

  constructor(address owner) Ownable(owner) {}

  modifier pausable() {
    require(paused == false, "Paused");
    _;
  }

  function pause() external onlyOwner {
    paused = true;
  }

  function unpause() external onlyOwner {
    paused = false;
  }
}
