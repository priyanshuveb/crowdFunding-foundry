// SPDX-License-Identifier: MIT

// Fund
// Withdraw
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script{
  uint256 constant SEND_VALUE = 0.01 ether;

  function fundFundMe(address mostRecentlyDeployed) public {
    vm.startBroadcast();
    FundMe(mostRecentlyDeployed).fund{value: SEND_VALUE}();
    vm.stopBroadcast();
    console.log("Funded with %s", SEND_VALUE);
  }

  function run() external {
    /** 
     * what this will do fetch the latest deployment of the "FundMe" contract
     * from the broadcast folder using your chainId  & contractName parameters.
     * This file is usually run-latest.json
    **/
    address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
        "FundMe",
        block.chainid
    );
    console.log('-----Contract Address------', mostRecentlyDeployed);
    fundFundMe(mostRecentlyDeployed);
  } 
}

contract WithdrawFundMe is Script {

}