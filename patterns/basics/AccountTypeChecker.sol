// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

// WARN: OpenZeppelin has deprecated this approach.
//       - At deployment time, computed contract of the not yet deployed
//         contract has a length of 0
//       - A self destruct contract address may return a code length of 0
//         (though selfdestruct behavior has been deprecated)
//       - A being selfdestruct contract has a code length > 0 in the
//         transaction
contract AccountTypeChecker {
  function isContract(address account) external view returns (bool) {
    return account.code.length > 0;
  }
}
