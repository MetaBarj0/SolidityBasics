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

  error OnlyOwnerCanInteract();
  error WrongValueForTaskCreation();
  error CannotModifyUnexistingTask();
  error CannotModifyDeletedTask();
  error CannotDeleteUnexistingTask();
  error AlreadyDeletedTask();

  modifier ensureOwner() {
    if (msg.sender != owner) revert OnlyOwnerCanInteract();

    _;
  }

  function createTask(string calldata definition) external payable ensureOwner {
    if (msg.value != 0.01 ether) revert WrongValueForTaskCreation();

    tasks.push(Task({timestamp: block.timestamp, definition: definition, status: Status.todo}));
  }

  function modifyTask(
    uint256 index,
    string calldata newDefinition,
    Status newStatus
  ) external ensureOwner {
    if (index >= tasks.length) revert CannotModifyUnexistingTask();
    if (deletedTasks[index] == true) revert CannotModifyDeletedTask();

    tasks[index].definition = newDefinition;
    tasks[index].status = newStatus;
  }

  function deleteTask(uint256 index) external ensureOwner {
    if (index >= tasks.length) revert CannotDeleteUnexistingTask();
    if (deletedTasks[index] == true) revert AlreadyDeletedTask();

    payable(owner).transfer(0.01 ether);

    deletedTasks[index] = true;
  }
}
