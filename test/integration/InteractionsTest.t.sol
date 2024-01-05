// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;

    address immutable ALICE = makeAddr("alice");
    uint256 constant INITIAL_BALANCE = 5 ether;
    uint256 constant SEND_VALUE = 1e18;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(ALICE, INITIAL_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.prank(ALICE);
        fundFundMe.fundFundMe(address(fundMe));
        address funder = fundMe.getFunder(0);
        assertEq(funder, ALICE);
    }
}
