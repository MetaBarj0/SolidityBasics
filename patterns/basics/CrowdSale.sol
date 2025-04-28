// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {Ownable} from "./Ownable.sol";

interface IERC20 {
  function safeTransfer(address to, uint amount) external;
}

// To sell token against ETH or other tokens
contract CrowdSale is Ownable {
  IERC20 public token;
  uint256 public rate;
  uint256 public weiRaised;

  constructor(uint256 _rate, address _token) Ownable(msg.sender) {
    require(_rate > 0, "Invalid rate");
    require(_token != address(0), "Address zero provided");

    rate = _rate;
    token = IERC20(_token);
  }

  function buyTokens(address beneficiary) public payable {
    require(beneficiary != address(0), "Address zero provided");
    require(msg.value > 0, "No ETH received");

    weiRaised += msg.value;
    uint256 tokenAmount = weiRaised * rate;

    token.safeTransfer(beneficiary, tokenAmount);
  }

  function withdraw(uint256 amount) external onlyOwner {
    payable(owner).transfer(amount);
  }
}
