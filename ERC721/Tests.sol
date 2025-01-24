// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "./NFT.sol";

contract Tests is NFT {
  constructor(address owner) NFT(owner) {
    require(owner != address(0), InvalidZeroAddress());

    _mintedTokenCount = 0;
  }

  error AmountRequiredIs(uint256 requiredAmount);
  error SupplyDepleted();

  function mint() external payable {
    require(_mintedTokenCount <= totalSupply, SupplyDepleted());

    uint256 price = _getTokenPrice();

    if (msg.value != price) revert AmountRequiredIs(price);

    _ownedTokens[uint256(++_mintedTokenCount)] = msg.sender;
    _balances[msg.sender]++;
  }

  function getRemainingSupply() external view returns (uint8) {
    return totalSupply - _mintedTokenCount;
  }

  function burn(uint256 tokenId) external {
    require(_ownedTokens[tokenId] == msg.sender, NotOwner());

    delete _ownedTokens[tokenId];
    delete _approvalTokens[tokenId];
    _balances[msg.sender]--;
    totalSupply--;
  }

  function _getTokenPrice() private view returns (uint256) {
    return 0.001 ether * 2 ** _mintedTokenCount;
  }

  uint8 _mintedTokenCount;
}
