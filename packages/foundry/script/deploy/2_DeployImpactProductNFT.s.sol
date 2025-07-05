// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "contracts/tokens/ImpactProductNFT.sol";
import "./DeploymentConfig.s.sol";

/**
 * @title DeployImpactProductNFT
 * @dev Simple deployment script for Impact Product NFT
 */
contract DeployImpactProductNFT is DeploymentConfig {
    function run() public {
        initialize();
        console.log("=== Deploying Impact Product NFT ===");
        
        // Check if already deployed
        if (impactNFTAddress != address(0)) {
            console.log("Impact Product NFT already deployed at:", impactNFTAddress);
            return;
        }
        
        console.log("Platform Wallet:", platformWallet);
        console.log("Base Token URI:", baseTokenURI);
        
        vm.startBroadcast();
        
        ImpactProductNFT impactNFT = new ImpactProductNFT(platformWallet, baseTokenURI);
        impactNFTAddress = address(impactNFT);
        
        vm.stopBroadcast();
        
        console.log("Impact Product NFT deployed at:", impactNFTAddress);
        console.log("Platform Wallet has admin role:", impactNFT.hasRole(impactNFT.DEFAULT_ADMIN_ROLE(), platformWallet));
        
        saveDeployedAddresses();
    }
} 