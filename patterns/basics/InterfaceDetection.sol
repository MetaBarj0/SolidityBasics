// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {IPausable} from "./IPausable.sol";

interface IERC165 {
  function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

contract ERC165 is IERC165 {
  function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
    return interfaceId == type(IERC165).interfaceId;
  }
}

// Prefer
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
contract InterfaceDetection is ERC165 {
  function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
    return interfaceId == type(IPausable).interfaceId || super.supportsInterface(interfaceId);
  }
}
