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
  error InvalidTaskId();

  event TaskCreated(uint256 indexed taskId, string definition);
  event TaskModified(uint256 indexed taskId, string newDefinition, Status newStatus);
  event TaskDeleted(uint256 indexed taskId);

  modifier ensureOwner() {
    require(msg.sender == owner, Unauthorized());

    _;
  }

  function createTask(string calldata definition) external payable ensureOwner {
    require(msg.value == 0.01 ether, NotEnoughEth(0.01 ether));

    tasks.push(Task({timestamp: block.timestamp, definition: definition, status: Status.todo}));

    emit TaskCreated(tasks.length - 1, definition);
  }

  function modifyTask(
    uint256 taskId,
    string calldata newDefinition,
    Status newStatus
  ) external ensureOwner {
    require(taskId < tasks.length, InvalidTaskId());

    tasks[taskId].definition = newDefinition;
    tasks[taskId].status = newStatus;

    emit TaskModified(taskId, newDefinition, newStatus);
  }

  function deleteTask(uint256 taskId) external ensureOwner {
    require(taskId < tasks.length, InvalidTaskId());

    payable(owner).transfer(0.01 ether);

    deletedTasks[taskId] = true;

    emit TaskDeleted(taskId);
  }
}
