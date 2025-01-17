// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Arrays {
  uint256[] public dynamicArray = [1, 2, 3, 4];
  uint256[3] public fixedArray = [5, 6, 7];

  function operations() public {
    dynamicArray.push(8);
    uint256 oldValue = fixedArray[0];
    fixedArray[0] = oldValue ^ oldValue;
    delete dynamicArray[dynamicArray.length - 1];
    dynamicArray.pop();
  }

  // Not recommended to return an array, especially if big because of gas cost
  function returnsArray() external pure returns (uint256[] memory) {
    uint256[] memory fixedArray2 = new uint256[](42);

    for (uint8 i = 1; i <= fixedArray2.length; ++i) fixedArray2[i - 1] = i;

    return fixedArray2;
  }
}
