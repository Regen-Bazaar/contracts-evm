// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "../../contracts/tokens/ImpactProductNFT.sol";
import "./DeploymentConfig.s.sol";

/**
 * @title DeployImpactProductNFT
 * @dev Deploys the Impact Product NFT contract (step 2)
 */
contract DeployImpactProductNFT is DeploymentConfig {
    function run() public {
        initialize();
        console.log("Step 2: Deploying ImpactProductNFT...");
        
        // Safety check: prevent duplicate deployment
        if (impactNFTAddress != address(0)) {
            console.log("ImpactProductNFT already deployed at:", impactNFTAddress);
            verifyNFTDeployment();
            return;
        }
        
        // Validate deployment parameters
        require(platformWallet != address(0), "Platform wallet not set");
        require(bytes(baseTokenURI).length > 0, "Base token URI cannot be empty");
        
        console.log("Deploying with parameters:");
        console.log("  Platform Wallet:", platformWallet);
        console.log("  Base Token URI:", baseTokenURI);
        
        vm.startBroadcast();
        
        ImpactProductNFT impactNFT = new ImpactProductNFT(platformWallet, baseTokenURI);
        impactNFTAddress = address(impactNFT);
        
        // Verify deployment was successful
        require(impactNFTAddress != address(0), "Deployment failed");
        require(impactNFTAddress.code.length > 0, "Contract deployment failed");
        
        // Verify initial state
        // require(impactNFT.hasRole(impactNFT.DEFAULT_ADMIN_ROLE(), platformWallet), "Platform wallet admin role not granted");
        
        vm.stopBroadcast();
        
        console.log("ImpactProductNFT successfully deployed at:", impactNFTAddress);
        console.log("Platform Wallet has admin role:", impactNFT.hasRole(impactNFT.DEFAULT_ADMIN_ROLE(), platformWallet));
        
        saveDeployedAddresses();
    }
} 