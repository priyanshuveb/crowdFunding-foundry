// SPDX-License-Identifier: MIT

pragma solidity >=0.8.18 <0.9.0;

// we can import console from Test.sol because it is already importing the console.sol in itself
import {Test, console} from "forge-std/Test.sol";
// import {console} from "forge-std/console.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address immutable ALICE = makeAddr("alice");
    uint256 constant INITIAL_BALANCE = 100e18;
    uint256 constant SEND_VALUE = 1e18;
    // setUp is an Forge Keyword: An optional function invoked before each test case is run.
    // deploying the contract
    function setUp() external {
        // us -> FundMeTest contract -> FundMe contract
        // owner of the FundMe contract is FundMeTest contract
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();

        vm.deal(ALICE, INITIAL_BALANCE);
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
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); // The following should revert
        fundMe.fund{value: 0}(); // send 0 ETH
    }

    function testFundUpdatesFundedDataStruct() public {
        console.log(ALICE);
        vm.deal(ALICE, INITIAL_BALANCE); // Funds the ALICE account with mentioned amount
        vm.prank(ALICE); // The next transaction will be sent using this account
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(ALICE);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, ALICE);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.prank(ALICE);
        fundMe.fund{value: SEND_VALUE}();

        vm.expectRevert();
        vm.prank(ALICE);
        fundMe.withdraw();
    }
}
