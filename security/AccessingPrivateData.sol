// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// Testing this require access to some CLI of a local blockchain (cast for
// instance)
contract Vault {
  // slot 0
  uint public count = 0;

  // slot 1
  address public immutable owner = msg.sender;
  bool public isTrue = true;
  uint16 public u16 = 31000;

  // slot 2
  // Disclaimer: can be read even if private, never store sensitive data
  // on-chain
  bytes32 private password;

  // constants do not use storage
  uint public constant CONST = 2 ** 255 + 19;

  // slots 3, 4 and 5
  uint[3] public data;

  struct User {
    uint id;
    bytes32 password;
  }

  // - slot 6: length of the array
  // - array's elements storage starts at keccak256(p) where p is the slot
  //   number, here 6. The array's length is stored at that location
  // - each element of the array are store at keccak256(keccak256(p) + i) where
  //   p is the slot number and i the ith element. Here it is simple as
  //   underlying array type is uint256.
  // See
  // https://docs.soliditylang.org/en/v0.8.29/internals/layout_in_storage.html#mappings-and-dynamic-arrays
  User[] private users;

  // would be slot 7 which is left empty here because:
  // - each mapping element is stored at keccak256(h(k) . p) where:
  //   - h is a function to pad k if necessary
  //   - k is the mapping key, here, id
  //   - . is the concat function
  //   - p is the mapping storage slot, here 7
  // - contiguous mapping must have different storage locations
  // See
  // https://docs.soliditylang.org/en/v0.8.29/internals/layout_in_storage.html#mappings-and-dynamic-arrays
  mapping(uint id => User) private idToUser;

  // Anyway, once deployed, the value is visible in the deploy transaction
  constructor(bytes32 password_) {
    password = password_;
  }

  // Each call to addUser show password_ to everybody on Earth
  function addUser(bytes32 password_) public {
    User memory user = User({id: users.length, password: password_});

    users.push(user);
    idToUser[user.id] = user;
  }

  function getArrayLocation(uint slot, uint index, uint elementSize) public pure returns (uint) {
    return uint(keccak256(abi.encodePacked(slot))) + index * elementSize;
  }

  function getValueTypeMappingLocation(uint slot, uint key) public pure returns (uint) {
    return uint(keccak256(abi.encodePacked(key, slot)));
  }
}
