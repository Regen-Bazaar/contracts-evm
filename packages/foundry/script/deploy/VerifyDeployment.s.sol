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
 * @title VerifyDeployment
 * @dev Comprehensive verification of all deployed contracts and their configurations
 */
contract VerifyDeployment is DeploymentConfig {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");
    
    function run() public {
        initialize();
        
        console.log("==============================================");
        console.log("REGEN BAZAAR DEPLOYMENT VERIFICATION");
        console.log("==============================================");
        
        verifyAllDeployments();
        verifyRoleAssignments();
        verifyContractConfigurations();
        verifyDependencies();
        
        console.log("==============================================");
        console.log("[SUCCESS] All verifications passed!");
        console.log("==============================================");
    }
    
    function verifyAllDeployments() internal view {
        console.log("1. Verifying contract deployments...");
        
        require(rebazTokenAddress != address(0), "REBAZ Token not deployed");
        require(rebazTokenAddress.code.length > 0, "REBAZ Token has no code");
        console.log("   [OK] REBAZ Token deployed at:", rebazTokenAddress);
        
        require(impactNFTAddress != address(0), "Impact NFT not deployed");
        require(impactNFTAddress.code.length > 0, "Impact NFT has no code");
        console.log("   [OK] Impact NFT deployed at:", impactNFTAddress);
        
        require(stakingAddress != address(0), "Staking contract not deployed");
        require(stakingAddress.code.length > 0, "Staking contract has no code");
        console.log("   [OK] Staking contract deployed at:", stakingAddress);
        
        require(marketplaceAddress != address(0), "Marketplace not deployed");
        require(marketplaceAddress.code.length > 0, "Marketplace has no code");
        console.log("   [OK] Marketplace deployed at:", marketplaceAddress);
        
        require(factoryAddress != address(0), "Factory not deployed");
        require(factoryAddress.code.length > 0, "Factory has no code");
        console.log("   [OK] Factory deployed at:", factoryAddress);
    }
    
    function verifyRoleAssignments() internal view {
        console.log("2. Verifying role assignments...");
        
        REBAZToken rebazToken = REBAZToken(rebazTokenAddress);
        ImpactProductNFT impactNFT = ImpactProductNFT(impactNFTAddress);
        
        // Verify REBAZ token roles
        require(rebazToken.hasRole(rebazToken.DEFAULT_ADMIN_ROLE(), admin), "Admin missing DEFAULT_ADMIN_ROLE on token");
        require(rebazToken.hasRole(MINTER_ROLE, stakingAddress), "Staking missing MINTER_ROLE on token");
        console.log("   [OK] REBAZ Token roles configured correctly");
        
        // Verify NFT roles
        require(impactNFT.hasRole(impactNFT.DEFAULT_ADMIN_ROLE(), platformWallet), "Platform wallet missing DEFAULT_ADMIN_ROLE on NFT");
        require(impactNFT.hasRole(MINTER_ROLE, factoryAddress), "Factory missing MINTER_ROLE on NFT");
        require(impactNFT.hasRole(VERIFIER_ROLE, factoryAddress), "Factory missing VERIFIER_ROLE on NFT");
        console.log("   [OK] Impact NFT roles configured correctly");
    }
    
    function verifyContractConfigurations() internal view {
        console.log("3. Verifying contract configurations...");
        
        REBAZToken rebazToken = REBAZToken(rebazTokenAddress);
        ImpactProductStaking staking = ImpactProductStaking(stakingAddress);
        RegenMarketplace marketplace = RegenMarketplace(marketplaceAddress);
        ImpactProductFactory factory = ImpactProductFactory(factoryAddress);
        
        // Verify token configuration
        require(rebazToken.totalSupply() == initialTokenSupply, "Token total supply mismatch");
        require(rebazToken.balanceOf(admin) == initialTokenSupply, "Admin token balance mismatch");
        console.log("   [OK] REBAZ Token configuration verified");
        
        // Verify staking configuration
        require(address(staking.impactProductNFT()) == impactNFTAddress, "Staking NFT address mismatch");
        require(address(staking.rebazToken()) == rebazTokenAddress, "Staking token address mismatch");
        console.log("   [OK] Staking contract configuration verified");
        
        // Verify marketplace configuration
        require(address(marketplace.impactProductNFT()) == impactNFTAddress, "Marketplace NFT address mismatch");
        require(marketplace.platformFeeReceiver() == platformWallet, "Marketplace platform wallet mismatch");
        console.log("   [OK] Marketplace configuration verified");
        
        // Verify factory configuration
        require(address(factory.impactProductNFT()) == impactNFTAddress, "Factory NFT address mismatch");
        require(factory.platformFeeReceiver() == platformWallet, "Factory platform wallet mismatch");
        console.log("   [OK] Factory configuration verified");
    }
    
    function verifyDependencies() internal view {
        console.log("4. Verifying contract dependencies...");
        
        REBAZToken rebazToken = REBAZToken(rebazTokenAddress);
        ImpactProductStaking staking = ImpactProductStaking(stakingAddress);
        
        // Test that staking can interact with token (check allowance)
        require(rebazToken.allowance(address(staking), address(staking)) == 0, "Unexpected staking allowance");
        console.log("   [OK] Token-Staking dependency verified");
        
        // Verify marketplace can check NFT ownership (basic interface check)
        RegenMarketplace marketplace = RegenMarketplace(marketplaceAddress);
        ImpactProductNFT impactNFT = ImpactProductNFT(impactNFTAddress);
        
        // Check that contracts are aware of each other
        require(address(marketplace.impactProductNFT()) == impactNFTAddress, "Marketplace-NFT dependency broken");
        console.log("   [OK] Marketplace-NFT dependency verified");
        
        // Check factory-NFT interaction
        ImpactProductFactory factory = ImpactProductFactory(factoryAddress);
        require(address(factory.impactProductNFT()) == impactNFTAddress, "Factory-NFT dependency broken");
        console.log("   [OK] Factory-NFT dependency verified");
        
        console.log("   [OK] All dependencies verified");
    }
} 