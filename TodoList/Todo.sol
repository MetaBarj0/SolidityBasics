// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Todo {
  enum Status {
    todo,
    doing,
    done
  }

  struct Task {
    uint256 id;
    uint256 timestamp;
    string definition;
    Status status;
  }

  mapping(address => uint256) latestTaskIdByOwner;

  function getNextTaskId() private returns (uint256) {
    return latestTaskIdByOwner[msg.sender]++;
  }

  mapping(address => Task[]) tasksByOwner;

  function getAllTasks() external view returns (Task[] memory) {
    return tasksByOwner[msg.sender];
  }

  error NotEnoughETH(string message);

  modifier ensurePayment() {
    if (msg.value < 0.01 ether) {
      revert NotEnoughETH("You need 0.01 ETH to create a task");
    }

    uint256 remaining = msg.value - 0.01 ether;

    if (remaining > 0) {
      payable(msg.sender).transfer(remaining);
    }

    _;
  }

  function createTask(string calldata definition) external payable ensurePayment {
    Task memory newTask = Task({
      id: getNextTaskId(),
      timestamp: block.timestamp,
      definition: definition,
      status: Status.todo
    });

    tasksByOwner[msg.sender].push(newTask);
  }

  function doesTaskExist(uint256 taskId) private view returns (bool) {
    Task[] storage tasks = tasksByOwner[msg.sender];

    for (uint256 i = 0; i < tasks.length; ++i) {
      if (tasks[i].id == taskId) return true;
    }
    return false;
  }

  error UnexistingTask(address owner, uint256 taskId);
  error InvalidDefinition(string msg);

  modifier ensureTaskExists(uint256 taskId) {
    if (!doesTaskExist(taskId)) {
      revert UnexistingTask(msg.sender, taskId);
    }

    _;
  }

  function updateTaskDefinition(uint256 taskId, string calldata definition) external ensureTaskExists(taskId) {
    if (bytes(definition).length == 0) {
      revert InvalidDefinition("the task definition must not be empty");
    }

    Task[] storage tasks = tasksByOwner[msg.sender];

    for (uint256 i = 0; i < tasks.length; ++i) {
      Task storage task = tasks[i];

      if (task.id == taskId) {
        task.definition = definition;
        return;
      }
    }
  }

  function updateTaskStatus(uint256 taskId, Status status) external ensureTaskExists(taskId) {
    Task[] storage tasks = tasksByOwner[msg.sender];

    for (uint256 i = 0; i < tasks.length; ++i) {
      Task storage task = tasks[i];

      if (task.id == taskId) {
        task.status = status;
        return;
      }
    }
  }

  function deleteTask(uint256 taskId) external payable {
    if (!doesTaskExist(taskId)) {
      revert UnexistingTask(msg.sender, taskId);
    }

    Task[] storage tasks = tasksByOwner[msg.sender];

    for (uint256 i = 0; i < tasks.length - 1; ++i) {
      if (tasks[i].id != taskId) continue;

      tasks[i] = tasks[i + 1];
    }

    tasks.pop();

    payable(msg.sender).transfer(0.01 ether);
  }
}
