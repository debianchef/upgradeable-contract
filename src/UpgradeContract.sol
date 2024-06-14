// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

contract MockImplementation {
    function setValue(uint256 _value) external {
        assembly {
            sstore(4, _value) // Store the value at storage slot 4
        }
    }

    function value() external view returns (uint256) {
        uint256 result;
        assembly {
            result := sload(4) // Load the value from storage slot 4
        }
        return result;
    }
}