// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract StorageSpecifiers {
  struct UserData {
    uint8 integer;
    string text;
  }

  mapping(address => UserData) public allUserData;

  constructor() {
    allUserData[address(this)] = UserData({text: "answer", integer: 42});
  }

  // update in transient memeory (for this transaction) see the view specifier
  function memoryUpdate() external view returns (UserData memory) {
    UserData memory data = allUserData[address(this)];
    data.text = "Foo";
    data.integer = 99;

    return data;
  }

  // update in contract stored variables (no view modifier)
  function storageUpdate() external {
    UserData storage data = allUserData[address(this)];
    data.text = "Foo";
    data.integer = 99;
  }

  // calldata specifier is designed to save gas especially when passing this data to other function calls
  // calldata are read-only data
  function internalUpdate(UserData storage ref, UserData calldata data) private {
    ref.text = data.text;
    ref.integer = data.integer;
  }

  function storageUpdateWithCalldata(UserData calldata data) external {
    UserData storage ref = allUserData[address(this)];

    internalUpdate(ref, data);
  }
}
