// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Base {
  function foo() internal pure virtual returns (string memory) {
    return "Base::foo";
  }

  function bar() internal pure virtual returns (string memory) {
    return "Base::bar";
  }

  function baz() external pure returns (string memory) {
    return "Base::baz";
  }
}

contract Derived is Base {
  function foo() internal pure override returns (string memory) {
    super.foo();
    return "Derived::foo";
  }

  function bar() internal pure override returns (string memory) {
    super.bar();
    return "Derived::bar";
  }
}
