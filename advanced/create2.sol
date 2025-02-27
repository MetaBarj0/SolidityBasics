// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract DeployWithCreate2 {
  address public immutable owner;

  constructor(address owner_) {
    owner = owner_;
  }
}

contract Create2Factory {
  event Deployed(address target);

  // deploying using a salt to secure address of deployed contract. I think it
  // prevents attacks consisting in guessing a contract deploy address. The
  // salt is a random value of our choosing.
  // Pretty similar to salting with symmetrical cryptographic functions.
  // Below show how address are computed using create2
  function deploy(uint256 salt_) external {
    DeployWithCreate2 contract_ = new DeployWithCreate2{salt: bytes32(salt_)}(msg.sender);

    emit Deployed(address(contract_));
  }

  // In some use cases, we need to know the target address where the contract
  // will be deployed before the contract gets deployed. This is where
  // getAddress function comes to play.
  function getAddress(bytes calldata contractByteCode, uint256 salt) public view returns (address) {
    bytes32 hash = keccak256(
      abi.encodePacked(bytes1(0xff), address(this), salt, keccak256(contractByteCode))
    );

    // an address is the 20 first bytes (same size as uint160) of a 256 bits
    // hash
    return address(uint160(uint256(hash)));
  }

  // Obtains the byte code of the contract to deploy.
  // Therefore, deployment address partly depends on contract implementation
  // too.
  function getByteCode(address owner) public pure returns (bytes memory) {
    bytes memory byteCode = type(DeployWithCreate2).creationCode;

    return abi.encodePacked(byteCode, abi.encode(owner));
  }
}
