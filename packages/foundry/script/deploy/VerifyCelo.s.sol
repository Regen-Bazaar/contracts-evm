// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "./DeploymentConfig.s.sol";

/**
 * @title VerifyCelo
 * @dev Verification script for Celo Alfajores testnet contracts
 */
contract VerifyCelo is DeploymentConfig {
    function run() public {
        initialize();
        
        console.log("=== Verifying Contracts on Celo Alfajores ===");
        
        // Load deployed addresses
        loadDeployedAddresses();
        
        // Verify each contract
        verifyREBAZToken();
        verifyImpactProductNFT();
        verifyImpactProductStaking();
        verifyMarketplace();
        verifyFactory();
        
        console.log("=== Verification Complete ===");
        console.log("Check CeloScan for verification status:");
        console.log("https://alfajores.celoscan.io/");
    }
    
    function verifyREBAZToken() internal {
        if (rebazTokenAddress != address(0)) {
            console.log("Verifying REBAZ Token at:", rebazTokenAddress);
            console.log("REBAZ Token ready for verification");
            console.log("  Address:", rebazTokenAddress);
            console.log("  Constructor args:", initialTokenSupply, admin);
        } else {
            console.log("Skipping REBAZ Token verification - not deployed");
        }
    }
    
    function verifyImpactProductNFT() internal {
        if (impactNFTAddress != address(0)) {
            console.log("Verifying Impact Product NFT at:", impactNFTAddress);
            console.log("Impact Product NFT ready for verification");
            console.log("  Address:", impactNFTAddress);
            console.log("  Constructor args:", platformWallet, baseTokenURI);
        } else {
            console.log("Skipping Impact Product NFT verification - not deployed");
        }
    }
    
    function verifyImpactProductStaking() internal {
        if (stakingAddress != address(0)) {
            console.log("Verifying Impact Product Staking at:", stakingAddress);
            console.log("Impact Product Staking ready for verification");
            console.log("  Address:", stakingAddress);
            console.log("  Constructor args:", impactNFTAddress, rebazTokenAddress);
        } else {
            console.log("Skipping Impact Product Staking verification - not deployed");
        }
    }
    
    function verifyMarketplace() internal {
        if (marketplaceAddress != address(0)) {
            console.log("Verifying Marketplace at:", marketplaceAddress);
            console.log("Marketplace ready for verification");
            console.log("  Address:", marketplaceAddress);
            console.log("  Constructor args:", impactNFTAddress, platformWallet);
        } else {
            console.log("Skipping Marketplace verification - not deployed");
        }
    }
    
    function verifyFactory() internal {
        if (factoryAddress != address(0)) {
            console.log("Verifying Impact Product Factory at:", factoryAddress);
            console.log("Impact Product Factory ready for verification");
            console.log("  Address:", factoryAddress);
            console.log("  Constructor args:", impactNFTAddress, platformWallet);
        } else {
            console.log("Skipping Impact Product Factory verification - not deployed");
        }
    }
} 