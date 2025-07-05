// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "./DeploymentConfig.s.sol";
import "contracts/tokens/REBAZToken.sol";
import "contracts/tokens/ImpactProductNFT.sol";
import "contracts/staking/ImpactProductStaking.sol";
import "contracts/marketplace/MarketPlace.sol";
import "contracts/factory/ImpactProductFactory.sol";

/**
 * @title DeployCelo
 * @dev Deployment script for Celo Alfajores testnet
 */
contract DeployCelo is DeploymentConfig {
    function run() public {
        initialize();
        
        console.log("=== Deploying to Celo Alfajores Testnet ===");
        console.log("Chain ID:", block.chainid);
        console.log("Deployer:", msg.sender);
        
        vm.startBroadcast();
        
        deployTokenIfNeeded();
        deployNFTIfNeeded();
        deployStakingIfNeeded();
        deployMarketplaceIfNeeded();
        deployFactoryIfNeeded();
        
        vm.stopBroadcast();
        
        saveDeployedAddresses();
        outputDeploymentSummary();
        
        console.log("=== Celo Deployment Complete ===");
        console.log("Next steps:");
        console.log("1. Verify contracts on CeloScan");
        console.log("2. Update frontend configuration");
        console.log("3. Test contract interactions");
    }
    
    function deployTokenIfNeeded() internal {
        if (rebazTokenAddress == address(0)) {
            console.log("Deploying REBAZ Token...");
            
            REBAZToken rebazToken = new REBAZToken(initialTokenSupply, admin);
            rebazTokenAddress = address(rebazToken);
            
            console.log("REBAZ Token deployed at:", rebazTokenAddress);
            console.log("Total Supply:", rebazToken.totalSupply());
        } else {
            console.log("REBAZ Token already deployed at:", rebazTokenAddress);
        }
    }
    
    function deployNFTIfNeeded() internal {
        if (impactNFTAddress == address(0)) {
            console.log("Deploying Impact Product NFT...");
            
            ImpactProductNFT impactNFT = new ImpactProductNFT(platformWallet, baseTokenURI);
            impactNFTAddress = address(impactNFT);
            
            console.log("Impact Product NFT deployed at:", impactNFTAddress);
        } else {
            console.log("Impact Product NFT already deployed at:", impactNFTAddress);
        }
    }
    
    function deployStakingIfNeeded() internal {
        if (stakingAddress == address(0)) {
            console.log("Deploying Impact Product Staking...");
            
            require(rebazTokenAddress != address(0), "REBAZ Token must be deployed first");
            require(impactNFTAddress != address(0), "Impact NFT must be deployed first");
            
            ImpactProductStaking staking = new ImpactProductStaking(impactNFTAddress, rebazTokenAddress);
            stakingAddress = address(staking);
            
            // Grant MINTER_ROLE to staking contract
            REBAZToken token = REBAZToken(rebazTokenAddress);
            token.grantRole(token.MINTER_ROLE(), stakingAddress);
            
            console.log("Impact Product Staking deployed at:", stakingAddress);
            console.log("MINTER_ROLE granted to staking contract");
        } else {
            console.log("Impact Product Staking already deployed at:", stakingAddress);
        }
    }
    
    function deployMarketplaceIfNeeded() internal {
        if (marketplaceAddress == address(0)) {
            console.log("Deploying Regen Marketplace...");
            
            require(impactNFTAddress != address(0), "Impact NFT must be deployed first");
            
            RegenMarketplace marketplace = new RegenMarketplace(impactNFTAddress, platformWallet);
            marketplaceAddress = address(marketplace);
            
            console.log("Regen Marketplace deployed at:", marketplaceAddress);
        } else {
            console.log("Regen Marketplace already deployed at:", marketplaceAddress);
        }
    }
    
    function deployFactoryIfNeeded() internal {
        if (factoryAddress == address(0)) {
            console.log("Deploying Impact Product Factory...");
            
            require(impactNFTAddress != address(0), "Impact NFT must be deployed first");
            
            ImpactProductFactory factory = new ImpactProductFactory(impactNFTAddress, platformWallet);
            factoryAddress = address(factory);
            
            // Grant roles to factory
            ImpactProductNFT nft = ImpactProductNFT(impactNFTAddress);
            nft.grantRole(nft.MINTER_ROLE(), factoryAddress);
            nft.grantRole(nft.VERIFIER_ROLE(), factoryAddress);
            
            console.log("Impact Product Factory deployed at:", factoryAddress);
            console.log("MINTER_ROLE and VERIFIER_ROLE granted to factory");
        } else {
            console.log("Impact Product Factory already deployed at:", factoryAddress);
        }
    }
    
    function outputDeploymentSummary() internal view {
        console.log("==================================");
        console.log("CELO ALFAJORES DEPLOYMENT SUMMARY");
        console.log("==================================");
        console.log("Chain ID:", block.chainid);
        console.log("Deployer:", msg.sender);
        console.log("Network: Celo Alfajores Testnet");
        console.log("==================================");
        console.log("REBAZ Token:          ", rebazTokenAddress);
        console.log("Impact Product NFT:   ", impactNFTAddress);
        console.log("Impact Product Staking:", stakingAddress);
        console.log("Regen Marketplace:    ", marketplaceAddress);
        console.log("Impact Product Factory:", factoryAddress);
        console.log("==================================");
        
        // Verify all addresses are different
        require(rebazTokenAddress != impactNFTAddress, "Token and NFT have same address");
        require(rebazTokenAddress != stakingAddress, "Token and Staking have same address");
        require(rebazTokenAddress != marketplaceAddress, "Token and Marketplace have same address");
        require(rebazTokenAddress != factoryAddress, "Token and Factory have same address");
        require(impactNFTAddress != stakingAddress, "NFT and Staking have same address");
        require(impactNFTAddress != marketplaceAddress, "NFT and Marketplace have same address");
        require(impactNFTAddress != factoryAddress, "NFT and Factory have same address");
        require(stakingAddress != marketplaceAddress, "Staking and Marketplace have same address");
        require(stakingAddress != factoryAddress, "Staking and Factory have same address");
        require(marketplaceAddress != factoryAddress, "Marketplace and Factory have same address");
        
        console.log("All contracts deployed with unique addresses!");
    }
} 