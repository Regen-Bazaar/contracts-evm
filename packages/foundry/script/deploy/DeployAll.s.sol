// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "./DeploymentConfig.s.sol";
import "./1_DeployREBAZToken.s.sol";
import "./2_DeployImpactProductNFT.s.sol";
import "./3_DeployImpactProductStaking.s.sol";
import "./4_DeployMarketplace.s.sol";
import "./5_DeployImpactProductFactory.s.sol";

/**
 * @title DeployAll
 * @dev Runs the complete deployment sequence for all contracts
 */
contract DeployAll is DeploymentConfig {
    function run() public {
        initialize();
        
        console.log("Starting complete deployment sequence...");
        console.log("=========================================");
        
        // Deploy each contract in sequence with error handling
        deployTokenIfNeeded();
        deployNFTIfNeeded();
        deployStakingIfNeeded();
        deployMarketplaceIfNeeded();
        deployFactoryIfNeeded();
        
        // Output final deployment status
        outputDeploymentSummary();
        
        console.log("=========================================");
        console.log("Complete deployment sequence finished!");
    }
    
    function deployTokenIfNeeded() internal {
        if (rebazTokenAddress == address(0)) {
            console.log("Deploying REBAZ Token...");
            try new DeployREBAZToken().run() {
                console.log("[OK] REBAZ Token deployment completed");
                loadDeployedAddresses(); // Reload to get updated addresses
            } catch Error(string memory reason) {
                console.log("[FAIL] REBAZ Token deployment failed:", reason);
                revert("Token deployment failed");
            } catch {
                console.log("[FAIL] REBAZ Token deployment failed with unknown error");
                revert("Token deployment failed");
            }
        } else {
            console.log("[OK] REBAZ Token already deployed at:", rebazTokenAddress);
            verifyTokenDeployment();
        }
    }
    
    function deployNFTIfNeeded() internal {
        if (impactNFTAddress == address(0)) {
            console.log("Deploying Impact Product NFT...");
            try new DeployImpactProductNFT().run() {
                console.log("[OK] Impact Product NFT deployment completed");
                loadDeployedAddresses(); // Reload to get updated addresses
            } catch Error(string memory reason) {
                console.log("[FAIL] Impact Product NFT deployment failed:", reason);
                revert("NFT deployment failed");
            } catch {
                console.log("[FAIL] Impact Product NFT deployment failed with unknown error");
                revert("NFT deployment failed");
            }
        } else {
            console.log("[OK] Impact Product NFT already deployed at:", impactNFTAddress);
            verifyNFTDeployment();
        }
    }
    
    function deployStakingIfNeeded() internal {
        if (stakingAddress == address(0)) {
            console.log("Deploying Impact Product Staking...");
            try new DeployImpactProductStaking().run() {
                console.log("[OK] Impact Product Staking deployment completed");
                loadDeployedAddresses(); // Reload to get updated addresses
            } catch Error(string memory reason) {
                console.log("[FAIL] Impact Product Staking deployment failed:", reason);
                revert("Staking deployment failed");
            } catch {
                console.log("[FAIL] Impact Product Staking deployment failed with unknown error");
                revert("Staking deployment failed");
            }
        } else {
            console.log("[OK] Impact Product Staking already deployed at:", stakingAddress);
            verifyStakingDeployment();
        }
    }
    
    function deployMarketplaceIfNeeded() internal {
        if (marketplaceAddress == address(0)) {
            console.log("Deploying Regen Marketplace...");
            try new DeployMarketplace().run() {
                console.log("[OK] Regen Marketplace deployment completed");
                loadDeployedAddresses(); // Reload to get updated addresses
            } catch Error(string memory reason) {
                console.log("[FAIL] Regen Marketplace deployment failed:", reason);
                revert("Marketplace deployment failed");
            } catch {
                console.log("[FAIL] Regen Marketplace deployment failed with unknown error");
                revert("Marketplace deployment failed");
            }
        } else {
            console.log("[OK] Regen Marketplace already deployed at:", marketplaceAddress);
            verifyMarketplaceDeployment();
        }
    }
    
    function deployFactoryIfNeeded() internal {
        if (factoryAddress == address(0)) {
            console.log("Deploying Impact Product Factory...");
            try new DeployImpactProductFactory().run() {
                console.log("[OK] Impact Product Factory deployment completed");
                loadDeployedAddresses(); // Reload to get updated addresses
            } catch Error(string memory reason) {
                console.log("[FAIL] Impact Product Factory deployment failed:", reason);
                revert("Factory deployment failed");
            } catch {
                console.log("[FAIL] Impact Product Factory deployment failed with unknown error");
                revert("Factory deployment failed");
            }
        } else {
            console.log("[OK] Impact Product Factory already deployed at:", factoryAddress);
            verifyFactoryDeployment();
        }
    }
    
    function outputDeploymentSummary() internal view {
        console.log("--------------------------------------------------");
        console.log("REGEN BAZAAR DEPLOYMENT SUMMARY");
        console.log("--------------------------------------------------");
        console.log("Network Chain ID:     ", block.chainid);
        console.log("Deployment Timestamp: ", block.timestamp);
        console.log("--------------------------------------------------");
        console.log("CONTRACT ADDRESSES:");
        console.log("REBAZToken:           ", rebazTokenAddress);
        console.log("ImpactProductNFT:     ", impactNFTAddress);
        console.log("ImpactProductStaking: ", stakingAddress);
        console.log("RegenMarketplace:     ", marketplaceAddress);
        console.log("ImpactProductFactory: ", factoryAddress);
        console.log("--------------------------------------------------");
        console.log("CONFIGURATION:");
        console.log("Admin:                ", admin);
        console.log("Platform Wallet:      ", platformWallet);
        console.log("Initial Token Supply: ", initialTokenSupply);
        console.log("--------------------------------------------------");
        
        // Verify all deployments
        require(rebazTokenAddress != address(0), "Token deployment missing");
        require(impactNFTAddress != address(0), "NFT deployment missing");
        require(stakingAddress != address(0), "Staking deployment missing");
        require(marketplaceAddress != address(0), "Marketplace deployment missing");
        require(factoryAddress != address(0), "Factory deployment missing");
        
        console.log("[SUCCESS] All contracts successfully deployed and verified!");
    }
} 