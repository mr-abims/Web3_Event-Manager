// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "../src/Web3RSVP.sol";
import "forge-std/Test.sol";

contract Web3RSVPTest is Test {
    function setUp() public {}

    address deployer;
    address Address1;
    address Address2;

    function testCreateNewEvent() public {
        deployer = mkaddr("deployer");
        Address1 = mkaddr("Address1");
        Address2 = mkaddr("Address2");

        uint maxCapacity = 3;
        uint timesamp = 1718926200;

        string
            memory eventDataCID = "bafybeibhwfzx6oo5rymsxmkdxpmkfwyvbjrrwcl7cekmbzlupmp5ypkyfi";
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
