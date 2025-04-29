// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

// preventive pattern: Pull vs Push
contract A {
  function foo() public payable {
    payable(msg.sender).transfer(msg.value);

    // do something else
  }
}

contract B {
  // as B does not have receive nor fallback, it refuses to be paid and block
  // any code subsequent to the transfer in A.foo
  function callFoo(A a) public {
    a.foo();
  }
}

contract KingOfEther {
  address public king;
  uint public balance;

  function claimThrone() external payable {
    require(msg.value > balance);

    // issue here where contact tries to `push` funds into the previous king
    // if the previous king has no receive nor fallback function, it blocks the
    // feature preventing anyone to become the king, no matter msg.value
    // The previous king will stay here forever, logic is broken.
    // Pull vs Push solve the problem here, by changing the king then, allowing
    // the previous king to withdraw funds he staked in the contract when it
    // became king.
    payable(king).transfer(balance);

    balance = msg.value;
    king = msg.sender;
  }
}

contract KingOfEtherFixed {
  address public king;
  uint public balance;
  mapping(address ancientKing => uint stake) ancientKingStakes;

  function claimThrone() external payable {
    require(msg.value > balance);

    ancientKingStakes[king] += balance;

    balance = msg.value;
    king = msg.sender;
  }

  function withdraw() public payable {
    uint stake = ancientKingStakes[msg.sender];
    ancientKingStakes[msg.sender] = 0;

    // Check effect interat to protect from re-entrancy attacks

    // potential denial of service here but it does affect only msg.sender, not
    // the contract logic
    payable(msg.sender).transfer(stake);
  }
}
