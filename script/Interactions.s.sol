// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
    uint256 SEND_VALUE = 70000000000 ether;

    function fundFundMe(address mostRecentlyDeployed) public {

        // will deploy the contract with the default sender i.e. 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
        vm.startBroadcast();
        console.log('msg.sender inside broadcasting %s', msg.sender);
        console.log('tx.origin', tx.origin);
        console.log('balance before', tx.origin.balance);
        FundMe(mostRecentlyDeployed).fund{value: SEND_VALUE}();
        console.log('balance after', tx.origin.balance);
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRecentlyDeployed);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Withdraw FundMe balance!");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentlyDeployed);
    }
}
