// SPDX-License-Identifier: MIT

pragma solidity >=0.8.18 <0.9.0;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {

    // By default, scripts are executed by calling the function named run, our entrypoint.
    function run() external returns (FundMe, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        address priceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeed);
        vm.stopBroadcast();
        return (fundMe, helperConfig);
    }
}