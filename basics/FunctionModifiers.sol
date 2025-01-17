// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract FunctionModifiers {
  bool private paused;
  int256 public count;

  function pause() external {
    paused = true;
  }

  function resume() external {
    paused = false;
  }

  error RunningStateError(string msg);

  modifier preWhenRunning() {
    if (paused == true) revert RunningStateError("Contract must be running");
    _;
  }

  error CountLimitError(string msg);

  modifier postEnsureCountLimit() {
    _;

    if (count < -200 || count > 200) revert CountLimitError("Count is out of bound and must be within [-200, 200]");
  }

  function inc() external preWhenRunning postEnsureCountLimit {
    count++;
  }

  function dec() external preWhenRunning postEnsureCountLimit {
    count--;
  }

  error CapError(string msg);

  modifier preCap(int256 val) {
    if (val > 10) revert CapError("Too big value, maximum of 10 is allowed.");

    _;
  }

  function incBy(int256 val) external preCap(val) postEnsureCountLimit {
    count += val;
  }

  function decBy(int256 val) external preCap(val) postEnsureCountLimit {
    count -= val;
  }
}
