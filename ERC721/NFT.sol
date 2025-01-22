// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "./SimplifiedERC721.sol";
import "./NFTOptional.sol";

contract NFT is SimplifiedERC721, NFTOptional {
  address public owner;

  constructor() {
    owner = msg.sender;
    totalSupply = 10;
  }

  error InvalidZeroAddress();
  error InvalidTokenId();
  error InvalidTokenOwner();
  error NotOwnerOrOperator();

  function balanceOf(address _owner) external view override returns (uint256) {
    return _balances[_owner];
  }

  function ownerOf(uint256 _tokenId) external view override returns (address) {
    return _ownedTokens[_tokenId];
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable override {
    require(_to != address(0), InvalidZeroAddress());
    require(_ownedTokens[_tokenId] != address(0), InvalidTokenId());
    require(_isTokenOwner(_tokenId), InvalidTokenOwner());

    _ownedTokens[_tokenId] = _to;

    emit Transfer(_from, _to, _tokenId);
  }

  function approve(address _approved, uint256 _tokenId) external payable override {
    _tokenApprovals[_approved] = _tokenId;
    _approvalTokens[_tokenId] = _approved;

    emit Approval(_ownedTokens[_tokenId], _approved, _tokenId);
  }

  function setApprovalForAll(address _operator, bool _approved) external override {
    require(_operator != address(0), InvalidZeroAddress());
    require(_isTokenOwnerOrOperator(), NotOwnerOrOperator());

    _approvedOperators[_operator] = _approved;

    emit ApprovalForAll(msg.sender, _operator, _approved);
  }

  function getApproved(uint256 _tokenId) external view returns (address) {
    return _approvalTokens[_tokenId];
  }

  function isApprovedForAll(
    address _owner,
    address _operator
  ) external view override returns (bool) {}

  mapping(address owner => uint256 amount) private _balances;
  mapping(uint256 tokenId => address owner) private _ownedTokens;
  mapping(address approved => uint256 tokenId) private _tokenApprovals;
  mapping(uint256 tokenId => address approved) private _approvalTokens;
  mapping(address operator => bool) _approvedOperators;

  function _isTokenOwner(uint256 _tokenId) private view returns (bool) {
    return
      msg.sender == owner ||
      msg.sender == _approvalTokens[_tokenId] ||
      msg.sender == _ownedTokens[_tokenId] ||
      _approvedOperators[msg.sender];
  }

  function _isTokenOwnerOrOperator() private view returns (bool) {
    return msg.sender == owner || _approvedOperators[msg.sender];
  }
}
