// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract S {
  string public name;

  constructor(string memory name_) {
    name = name_;
  }
}

contract T {
  string public text;

  constructor(string memory text_) {
    text = text_;
  }
}

contract U is S("s"), T("t") {}

contract V is S, T {
  constructor(string memory name, string memory text) S(name) T(text) {}
}

contract W is S("s"), T {
  constructor(string memory text) T(text) {}
}
