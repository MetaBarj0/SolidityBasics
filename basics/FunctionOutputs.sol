// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract FunctionOutputs {
  function returnsMany() private pure returns (bool, int8) {
    return (true, 42);
  }

  function returnsManyNamed() external pure returns (bool b, int8 i) {
    return (true, 42);
  }

  function returnsManyAssigned() external pure returns (bool b, int8 i) {
    b = false;
    i = 99;
  }

  function destructuring() public pure {
    (bool b, int8 i) = returnsMany();
    (, int8 j) = returnsMany();
    (bool b2, ) = returnsMany();
  }
}
