// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract CallTestContract {
  function setX1(address testContractAddress, uint256 v) external {
    // I think we can verify contract is well initialized comparing the
    // constructed contract address with address(0)
    TestContract(testContractAddress).setX(v);
  }

  function setX2(TestContract testContract, uint256 v) external {
    // delegate TestContract construction
    testContract.setX(v);
  }

  function getX1(TestContract testContract) external view returns (uint256 x) {
    // delegate TestContract construction
    // assigning to named return variable removes a warning, probably regarding
    // TestContract instance that may be not verified?
    x = testContract.getX();
  }

  function setXAndSendEthers1(address testContractAddress, uint256 v) external payable {
    // forward msg.value
    TestContract(testContractAddress).setXAndReceiveEthers{value: msg.value}(v);
  }

  function setXAndSendEthers2(TestContract testContract, uint256 v) external payable {
    // forward msg.value with delegated constructed contract
    testContract.setXAndReceiveEthers{value: msg.value}(v);
  }

  function getXAndValue(
    TestContract testContract
  ) external view returns (uint256 x, uint256 value) {
    // destructure and assign to named return values
    (x, value) = testContract.getXAndValue();
  }
}

contract TestContract {
  uint256 public x;
  uint256 public value = 123;

  function setX(uint256 v) external {
    x = v;
  }

  function getX() external view returns (uint256) {
    return x;
  }

  function setXAndReceiveEthers(uint256 v) external payable {
    x = v;
    value = msg.value;
  }

  function getXAndValue() external view returns (uint, uint) {
    return (x, value);
  }
}
