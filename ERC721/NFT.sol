// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "./SimplifiedERC721.sol";

abstract contract NFT is SimplifiedERC721 {
  string public name;
  string public symbol;
  uint8 public totalSupply;

  constructor(address owner) {
    _owner = owner;
    name = "Useless NFT";
    symbol = "UNFT";
    totalSupply = 10;
  }

  error InvalidZeroAddress();
  error InvalidTokenId();
  error NotOwnerNorOperatorNorApproved();
  error NotOwner();

  function balanceOf(address owner) external view override returns (uint256) {
    require(owner != address(0), InvalidZeroAddress());

    return _balances[owner];
  }

  function ownerOf(uint256 tokenId) external view override returns (address) {
    address owner = _ownedTokens[tokenId];

    if (owner == address(0)) revert InvalidZeroAddress();

    return owner;
  }

  function transferFrom(address from, address to, uint256 tokenId) external payable override {
    require(to != address(0) && from != address(0), InvalidZeroAddress());
    require(_ownedTokens[tokenId] != address(0), InvalidTokenId());
    require(_ownedTokens[tokenId] == from, NotOwner());
    require(_senderIsOwnerOrOperatorOrApproved(from, tokenId), NotOwnerNorOperatorNorApproved());

    delete _tokenApprovals[from];
    delete _approvalTokens[tokenId];

    _ownedTokens[tokenId] = to;
    emit Transfer(from, to, tokenId);
  }

  function approve(address approved, uint256 tokenId) external payable override {
    require(
      _senderIsOwnerOrOperatorOrApproved(approved, tokenId),
      NotOwnerNorOperatorNorApproved()
    );
    require(_ownedTokens[tokenId] != address(0), InvalidTokenId());

    _tokenApprovals[approved] = tokenId;
    _approvalTokens[tokenId] = approved;

    emit Approval(_ownedTokens[tokenId], approved, tokenId);
  }

  function setApprovalForAll(address operator, bool approved) external override {
    require(operator != address(0), InvalidZeroAddress());

    _approvedOperators[msg.sender][operator] = approved;

    emit ApprovalForAll(msg.sender, operator, approved);
  }

  function getApproved(uint256 tokenId) external view returns (address) {
    require(_ownedTokens[tokenId] != address(0), InvalidTokenId());

    return _approvalTokens[tokenId];
  }

  function isApprovedForAll(address owner, address operator) external view override returns (bool) {
    return _approvedOperators[owner][operator];
  }

  mapping(address owner => uint256 amount) internal _balances;
  mapping(uint256 tokenId => address owner) internal _ownedTokens;
  mapping(uint256 tokenId => address approved) internal _approvalTokens;
  mapping(address approved => uint256 tokenId) private _tokenApprovals;
  mapping(address owner => mapping(address operator => bool approved)) private _approvedOperators;

  address private _owner;

  function _senderIsOwnerOrOperatorOrApproved(
    address from,
    uint256 tokenId
  ) private view returns (bool) {
    return
      msg.sender == _owner ||
      _approvedOperators[from][msg.sender] ||
      _approvalTokens[tokenId] == msg.sender;
  }
}
