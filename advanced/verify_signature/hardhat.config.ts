import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-watcher";

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  watcher: {
    compile: {
      tasks: ["compile"],
      files: ["./contracts"],
      verbose: true,
      clearOnStart: true,
    },
    test: {
      tasks: [
        {
          command: "test",
        },
      ],
      files: ["./test/**/*.tests.ts", "./contracts/**/*.sol"],
      verbose: true,
      clearOnStart: true,
    },
  },
};

export default config;
