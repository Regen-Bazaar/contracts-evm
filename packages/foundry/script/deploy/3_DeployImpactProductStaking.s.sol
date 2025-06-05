// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "../../contracts/staking/ImpactProductStaking.sol";
import "./DeploymentConfig.s.sol";
import "../../contracts/tokens/REBAZToken.sol";

/**
 * @title DeployImpactProductStaking
 * @dev Deploys the Impact Product Staking contract (step 3)
 */
contract DeployImpactProductStaking is DeploymentConfig {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    function run() public {
        initialize();
        
        console.log("Step 3: Deploying ImpactProductStaking...");
        
        // Safety check: prevent duplicate deployment
        if (stakingAddress != address(0)) {
            console.log("ImpactProductStaking already deployed at:", stakingAddress);
            verifyStakingDeployment();
            return;
        }
        
        // Verify dependencies are deployed
        require(rebazTokenAddress != address(0), "REBAZToken not deployed");
        require(impactNFTAddress != address(0), "ImpactProductNFT not deployed");
        
        // Verify dependencies have valid code
        verifyTokenDeployment();
        verifyNFTDeployment();
        
        console.log("Deploying with parameters:");
        console.log("  Impact NFT Address:", impactNFTAddress);
        console.log("  REBAZ Token Address:", rebazTokenAddress);
        
        vm.startBroadcast();
        
        ImpactProductStaking staking = new ImpactProductStaking(impactNFTAddress, rebazTokenAddress);
        stakingAddress = address(staking);
        
        // Verify deployment was successful
        require(stakingAddress != address(0), "Deployment failed");
        require(stakingAddress.code.length > 0, "Contract deployment failed");
        
        // Grant staking contract permission to mint reward tokens
        REBAZToken rebazToken = REBAZToken(rebazTokenAddress);
        rebazToken.grantRole(MINTER_ROLE, stakingAddress);
        
        // Verify role was granted successfully
        require(rebazToken.hasRole(MINTER_ROLE, stakingAddress), "Failed to grant MINTER_ROLE to staking contract");
        
        vm.stopBroadcast();
        
        console.log("ImpactProductStaking successfully deployed at:", stakingAddress);
        console.log("MINTER_ROLE granted to staking contract:", rebazToken.hasRole(MINTER_ROLE, stakingAddress));
        
        // Verify staking contract can access dependencies
        require(address(staking.impactProductNFT()) == impactNFTAddress, "NFT address mismatch in staking contract");
        require(address(staking.rebazToken()) == rebazTokenAddress, "Token address mismatch in staking contract");
        
        // Save updated addresses
        saveDeployedAddresses();
    }
} 