// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "../../contracts/tokens/REBAZToken.sol";
import "./DeploymentConfig.s.sol";

/**
 * @title DeployREBAZToken
 * @dev Deploys the REBAZ token contract (step 1)
 */
contract DeployREBAZToken is DeploymentConfig {
    function run() public {
        initialize();
        console.log("Step 1: Deploying REBAZToken...");
        
        // Safety check: prevent duplicate deployment
        if (rebazTokenAddress != address(0)) {
            console.log("REBAZToken already deployed at:", rebazTokenAddress);
            verifyTokenDeployment();
            return;
        }
        
        // Validate deployment parameters
        require(admin != address(0), "Admin address cannot be zero");
        require(initialTokenSupply > 0, "Initial token supply must be greater than 0");
        
        console.log("Deploying with parameters:");
        console.log("  Initial Supply:", initialTokenSupply);
        console.log("  Admin:", admin);
        
        vm.startBroadcast();
        
        REBAZToken rebazToken = new REBAZToken(initialTokenSupply, admin);
        rebazTokenAddress = address(rebazToken);
        
        // Verify deployment was successful
        require(rebazTokenAddress != address(0), "Deployment failed");
        require(rebazTokenAddress.code.length > 0, "Contract deployment failed");
        
        // Verify initial state
        require(rebazToken.totalSupply() == initialTokenSupply, "Initial supply mismatch");
        require(rebazToken.balanceOf(admin) == initialTokenSupply, "Admin balance mismatch");
        require(rebazToken.hasRole(rebazToken.DEFAULT_ADMIN_ROLE(), admin), "Admin role not granted");
        
        vm.stopBroadcast();
        
        console.log("REBAZToken successfully deployed at:", rebazTokenAddress);
        console.log("Total Supply:", rebazToken.totalSupply());
        console.log("Admin Balance:", rebazToken.balanceOf(admin));
        
        saveDeployedAddresses();
    }
}
