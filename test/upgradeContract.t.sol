// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import "forge-std/Test.sol";
import "src/Proxy/Proxy.sol";
import "src/Proxy/Proxy2Step.sol";
import "src/Proxy/Upgradeable2Step.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";
import "src/UpgradeContract.sol";


contract ProxyTest is Test {
    Proxy proxy;
    MockImplementation impl1;
    MockImplementation impl2;
    address owner;
    address unauthorizedAddress = address(0x1234);

    function setUp() public {
        impl1 = new MockImplementation();
        impl2 = new MockImplementation();
        owner = address(this); // Set the owner to this contract
        proxy = new Proxy(address(impl1));
        proxy.transferOwnership(owner); // Transfer ownership to this contract
    }

    function testInitialImplementation() public {
        // Simulate the owner calling value through the proxy
        vm.startPrank(owner);
        (bool success, bytes memory data) = address(proxy).call(abi.encodeWithSignature("value()"));
        console.log("Call success:", success);
        console.log("Initial value:", abi.decode(data, (uint256)));
        assertEq(abi.decode(data, (uint256)), 0);
        vm.stopPrank();
    }
    

function testSetValue() public {
    // Simulate the owner calling setValue through the proxy
    vm.prank(owner);
    (bool success, ) = address(proxy).call(abi.encodeWithSignature("setValue(uint256)", 42));
    console.log("Set value call success:", success);

    // Verify the new value through the proxy
    vm.prank(owner);
    bytes memory data;
    (success, data) = address(proxy).call(abi.encodeWithSignature("value()"));
    console.log("Get value call success:", success);
    uint256 value = abi.decode(data, (uint256));
    console.log("New value:", value);
    assertEq(value, 42);
}

}

