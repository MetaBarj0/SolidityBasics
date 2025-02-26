// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

// Let's imagine we don't have access to this implementation
// Therefore, we cannot explicitly make this contract implements the ICounter
// interface defined below
contract Counter {
  uint public count;

  function inc() external {
    count++;
  }

  function dec() external {
    count--;
  }
}

// We own this interface
interface ICounter {
  function count() external view returns (uint256);

  function inc() external;

  function dec() external;
}

contract CallInterface {
  uint256 public count;

  function examples(address counterAddress) external {
    // some sort of dynamic_cast-like in c++
    ICounter counter = ICounter(counterAddress);
    require(address(counter) != address(0));

    ICounter(counterAddress).inc();
  }
}
