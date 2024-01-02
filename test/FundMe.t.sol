// SPDX-License-Identifier: MIT

pragma solidity >=0.8.18 <0.9.0;

// we can import console from Test.sol because it is already importing the console.sol in itself
import {Test, console} from "forge-std/Test.sol";
// import {console} from "forge-std/console.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {

    FundMe fundMe;
    DeployFundMe deployFundMe;

    // deploying the contract
    function setUp() external {
        // us -> FundMeTest contract -> FundMe contract
        // owner of the FundMe contract is FundMeTest contract
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsSender() public {
        // assertEq(fundMe.getOwner(), address(this));

        // The vm.startBroadcast makes the msg.sender the deployer of the contract
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version,4);
    }

}
