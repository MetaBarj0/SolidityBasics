// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Todo {
  enum Status {
    todo,
    doing,
    done
  }

  struct Task {
    uint256 timestamp;
    string definition;
    Status status;
  }

  address public owner;
  Task[] public tasks;

  mapping(uint256 => bool) public deletedTasks;

  constructor() {
    owner = msg.sender;
  }

  error Unauthorized();
  error NotEnoughEth(uint256 price);
  error AlreadyDeletedTask();
  error InvalidTaskId();

  modifier ensureOwner() {
    require(msg.sender == owner, Unauthorized());

    _;
  }

  function createTask(string calldata definition) external payable ensureOwner {
    require(msg.value == 0.01 ether, NotEnoughEth(0.01 ether));

    tasks.push(Task({timestamp: block.timestamp, definition: definition, status: Status.todo}));
  }

  function modifyTask(
    uint256 index,
    string calldata newDefinition,
    Status newStatus
  ) external ensureOwner {
    tasks[index].definition = newDefinition;
    tasks[index].status = newStatus;
  }

  function deleteTask(uint256 taskId) external ensureOwner {
    require(taskId < tasks.length, InvalidTaskId());
    require(!deletedTasks[taskId], AlreadyDeletedTask());

    payable(owner).transfer(0.01 ether);

    deletedTasks[taskId] = true;
  }
}
