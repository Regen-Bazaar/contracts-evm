// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "contracts/factory/ImpactProductFactory.sol";
import "contracts/tokens/ImpactProductNFT.sol";
import "./DeploymentConfig.s.sol";

/**
 * @title DeployImpactProductFactory
 * @dev Simple deployment script for Impact Product Factory
 */
contract DeployImpactProductFactory is DeploymentConfig {
    function run() public {
        initialize();
        console.log("=== Deploying Impact Product Factory ===");
        
        // Check if already deployed
        if (factoryAddress != address(0)) {
            console.log("Impact Product Factory already deployed at:", factoryAddress);
            return;
        }
        
        // Check dependencies
        require(impactNFTAddress != address(0), "Impact NFT must be deployed first");
        
        console.log("NFT Address:", impactNFTAddress);
        console.log("Platform Wallet:", platformWallet);
        
        vm.startBroadcast();
        
        ImpactProductFactory factory = new ImpactProductFactory(impactNFTAddress, platformWallet);
        factoryAddress = address(factory);
        
        // Grant roles to factory
        ImpactProductNFT impactNFT = ImpactProductNFT(impactNFTAddress);
        impactNFT.grantRole(impactNFT.MINTER_ROLE(), factoryAddress);
        impactNFT.grantRole(impactNFT.VERIFIER_ROLE(), factoryAddress);
        
        vm.stopBroadcast();
        
        console.log("Impact Product Factory deployed at:", factoryAddress);
        console.log("MINTER_ROLE granted:", impactNFT.hasRole(impactNFT.MINTER_ROLE(), factoryAddress));
        console.log("VERIFIER_ROLE granted:", impactNFT.hasRole(impactNFT.VERIFIER_ROLE(), factoryAddress));
        
        saveDeployedAddresses();
    }
} 