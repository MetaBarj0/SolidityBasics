// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

// prefer
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
contract Ownable {
  address public owner;

  constructor(address _owner) {
    owner = _owner;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
  }

  function transferOwnership(address newOwner) external onlyOwner {
    require(newOwner != address(0), "Address zero");
    owner = newOwner;
  }

  function renounceOwnership() public virtual onlyOwner {
    owner = address(0);
  }
}

// The current owner indicates the pending owner then, the pending owner
// accepts ownership
// Mitigate wrong transfer ownership address issues
// Prefer
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol
contract Ownable2Steps {
  address public owner;
  address public pendingOwner;

  constructor(address _owner) {
    owner = _owner;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
  }

  function transferOwnership(address newOwner) external onlyOwner {
    pendingOwner = newOwner;
  }

  function acceptOwnership() external {
    require(msg.sender == pendingOwner, "Not pending owner");
    owner = msg.sender;
    pendingOwner = address(0);
  }
}
