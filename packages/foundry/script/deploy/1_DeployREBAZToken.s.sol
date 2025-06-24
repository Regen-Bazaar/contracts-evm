// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "../../contracts/tokens/REBAZToken.sol";
import "./DeploymentConfig.s.sol";

/**
 * @title DeployREBAZToken
 * @dev Simple deployment script for REBAZ token
 */
contract DeployREBAZToken is DeploymentConfig {
    function run() public {
        initialize();
        console.log("=== Deploying REBAZ Token ===");
        
        // Check if already deployed
        if (rebazTokenAddress != address(0)) {
            console.log("REBAZ Token already deployed at:", rebazTokenAddress);
            return;
        }
        
        console.log("Admin:", admin);
        console.log("Initial Supply:", initialTokenSupply);
        
        vm.startBroadcast();
        
        REBAZToken rebazToken = new REBAZToken(initialTokenSupply, admin);
        rebazTokenAddress = address(rebazToken);
        
        vm.stopBroadcast();
        
        console.log("REBAZ Token deployed at:", rebazTokenAddress);
        console.log("Total Supply:", rebazToken.totalSupply());
        console.log("Admin Balance:", rebazToken.balanceOf(admin));
        
        saveDeployedAddresses();
    }
}
