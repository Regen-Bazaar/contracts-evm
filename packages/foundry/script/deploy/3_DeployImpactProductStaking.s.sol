// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "../../contracts/staking/ImpactProductStaking.sol";
import "./DeploymentConfig.s.sol";
import "../../contracts/tokens/REBAZToken.sol";

/**
 * @title DeployImpactProductStaking
 * @dev Simple deployment script for Impact Product Staking
 */
contract DeployImpactProductStaking is DeploymentConfig {
    function run() public {
        initialize();
        console.log("=== Deploying Impact Product Staking ===");
        
        // Check if already deployed
        if (stakingAddress != address(0)) {
            console.log("Impact Product Staking already deployed at:", stakingAddress);
            return;
        }
        
        // Check dependencies
        require(rebazTokenAddress != address(0), "REBAZ Token must be deployed first");
        require(impactNFTAddress != address(0), "Impact NFT must be deployed first");
        
        console.log("Token Address:", rebazTokenAddress);
        console.log("NFT Address:", impactNFTAddress);
        
        vm.startBroadcast();
        
        ImpactProductStaking staking = new ImpactProductStaking(impactNFTAddress, rebazTokenAddress);
        stakingAddress = address(staking);
        
        // Grant MINTER_ROLE to staking contract
        REBAZToken rebazToken = REBAZToken(rebazTokenAddress);
        rebazToken.grantRole(rebazToken.MINTER_ROLE(), stakingAddress);
        
        vm.stopBroadcast();
        
        console.log("Impact Product Staking deployed at:", stakingAddress);
        console.log("MINTER_ROLE granted:", rebazToken.hasRole(rebazToken.MINTER_ROLE(), stakingAddress));
        
        saveDeployedAddresses();
    }
} 