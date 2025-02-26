// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

library Maths {
  // a library cannot contain state variables nor immutable variables
  // constants are ok though
  // no sense to expose functions as private
  // public or external would force to deploy the library alongside the
  // contract that uses this library
  function max(uint256 x, uint256 y) internal pure returns (uint256) {
    return x >= y ? x : y;
  }
}

contract UsingMaths {
  // using the library function as a free function
  function useMax(uint256 x, uint256 y) external pure returns (uint256) {
    return Maths.max(x, y);
  }
}

library Array {
  error NotFound();

  // storage specifier in arguments to use state variables in calling contract
  function find(uint256[] storage array, uint256 x) internal view returns (uint256) {
    for (uint256 i = 0; i < array.length; i++) {
      if (array[i] == x) return i;
    }

    revert NotFound();
  }
}

contract UsingArray {
  uint256[] public array = [1, 2, 3];

  // Extends the uint256[] type adding the find method
  // It has the effect of passing the first array argument automatically, just
  // like the thiscall calling convention in c++
  using Array for uint256[];

  function useFind() external view returns (uint256) {
    return array.find(2);
  }
}
