// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "../../contracts/marketplace/MarketPlace.sol";
import "./DeploymentConfig.s.sol";

/**
 * @title DeployMarketplace
 * @dev Simple deployment script for RegenMarketplace
 */
contract DeployMarketplace is DeploymentConfig {
    function run() public {
        initialize();
        console.log("=== Deploying Regen Marketplace ===");
        
        // Check if already deployed
        if (marketplaceAddress != address(0)) {
            console.log("Regen Marketplace already deployed at:", marketplaceAddress);
            return;
        }
        
        // Check dependencies
        require(impactNFTAddress != address(0), "Impact NFT must be deployed first");
        
        console.log("NFT Address:", impactNFTAddress);
        console.log("Platform Wallet:", platformWallet);
        
        vm.startBroadcast();
        
        RegenMarketplace marketplace = new RegenMarketplace(impactNFTAddress, platformWallet);
        marketplaceAddress = address(marketplace);
        
        vm.stopBroadcast();
        
        console.log("Regen Marketplace deployed at:", marketplaceAddress);
        console.log("Platform Fee Receiver:", marketplace.platformFeeReceiver());
        
        saveDeployedAddresses();
    }
} 