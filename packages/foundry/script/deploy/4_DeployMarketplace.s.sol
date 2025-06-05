// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "../../contracts/marketplace/MarketPlace.sol";
import "./DeploymentConfig.s.sol";

/**
 * @title DeployMarketplace
 * @dev Deploys the RegenMarketplace contract (step 4)
 */
contract DeployMarketplace is DeploymentConfig {
    function run() public {
        initialize();
        
        console.log("Step 4: Deploying RegenMarketplace...");
        
        // Safety check: prevent duplicate deployment
        if (marketplaceAddress != address(0)) {
            console.log("RegenMarketplace already deployed at:", marketplaceAddress);
            verifyMarketplaceDeployment();
            return;
        }
        
        // Verify dependencies are deployed
        require(impactNFTAddress != address(0), "ImpactProductNFT not deployed");
        require(platformWallet != address(0), "Platform wallet not set");
        
        // Verify dependencies have valid code
        verifyNFTDeployment();
        
        console.log("Deploying with parameters:");
        console.log("  Impact NFT Address:", impactNFTAddress);
        console.log("  Platform Wallet:", platformWallet);
        
        vm.startBroadcast();
        
        RegenMarketplace marketplace = new RegenMarketplace(impactNFTAddress, platformWallet);
        marketplaceAddress = address(marketplace);
        
        // Verify deployment was successful
        require(marketplaceAddress != address(0), "Deployment failed");
        require(marketplaceAddress.code.length > 0, "Contract deployment failed");
        
        vm.stopBroadcast();
        
        console.log("RegenMarketplace successfully deployed at:", marketplaceAddress);
        
        // Verify marketplace contract configuration
        require(address(marketplace.impactProductNFT()) == impactNFTAddress, "NFT address mismatch in marketplace contract");
        require(marketplace.platformFeeReceiver() == platformWallet, "Platform fee receiver mismatch in marketplace contract");
        
        // Save updated addresses
        saveDeployedAddresses();
    }
} 