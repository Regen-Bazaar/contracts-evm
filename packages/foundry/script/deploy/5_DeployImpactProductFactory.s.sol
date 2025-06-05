// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "../../contracts/factory/ImpactProductFactory.sol";
import "../../contracts/tokens/ImpactProductNFT.sol";
import "./DeploymentConfig.s.sol";

/**
 * @title DeployImpactProductFactory
 * @dev Deploys the ImpactProductFactory contract (step 5)
 */
contract DeployImpactProductFactory is DeploymentConfig {
    // Define role constants directly
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");
    
    function run() public {
        initialize();
        
        console.log("Step 5: Deploying ImpactProductFactory...");
        
        // Safety check: prevent duplicate deployment
        if (factoryAddress != address(0)) {
            console.log("ImpactProductFactory already deployed at:", factoryAddress);
            verifyFactoryDeployment();
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
        
        ImpactProductFactory factory = new ImpactProductFactory(impactNFTAddress, platformWallet);
        factoryAddress = address(factory);
        
        // Verify deployment was successful
        require(factoryAddress != address(0), "Deployment failed");
        require(factoryAddress.code.length > 0, "Contract deployment failed");
        
        // Grant factory permission to mint NFTs
        ImpactProductNFT impactNFT = ImpactProductNFT(impactNFTAddress);
        impactNFT.grantRole(MINTER_ROLE, factoryAddress);
        impactNFT.grantRole(VERIFIER_ROLE, factoryAddress);
        
        // Verify roles were granted successfully
        require(impactNFT.hasRole(MINTER_ROLE, factoryAddress), "Failed to grant MINTER_ROLE to factory");
        require(impactNFT.hasRole(VERIFIER_ROLE, factoryAddress), "Failed to grant VERIFIER_ROLE to factory");
        
        // Add initial impact categories with configurable values
        addInitialImpactCategories(factory);
        
        vm.stopBroadcast();
        
        console.log("ImpactProductFactory successfully deployed at:", factoryAddress);
        console.log("MINTER_ROLE granted to factory:", impactNFT.hasRole(MINTER_ROLE, factoryAddress));
        console.log("VERIFIER_ROLE granted to factory:", impactNFT.hasRole(VERIFIER_ROLE, factoryAddress));
        
        // Verify factory contract configuration
        require(address(factory.impactProductNFT()) == impactNFTAddress, "NFT address mismatch in factory contract");
        require(factory.platformFeeReceiver() == platformWallet, "Platform fee receiver mismatch in factory contract");
        
        // Save updated addresses
        saveDeployedAddresses();
    }
    
    function addInitialImpactCategories(ImpactProductFactory factory) internal {
        // Get impact categories from environment or use defaults
        string[] memory categories = getImpactCategories();
        uint256[] memory multipliers = getImpactMultipliers();
        
        require(categories.length == multipliers.length, "Categories and multipliers length mismatch");
        
        for (uint256 i = 0; i < categories.length; i++) {
            try factory.addImpactCategory(categories[i], multipliers[i]) {
                console.log("Added impact category:", categories[i], "with multiplier:", multipliers[i]);
            } catch {
                console.log("Warning: Could not add category:", categories[i]);
            }
        }
    }
    
    function getImpactCategories() internal view returns (string[] memory) {
        string[] memory categories = new string[](4);
        
        // Use environment variables if available, otherwise defaults
        categories[0] = vm.envOr("IMPACT_CATEGORY_1", string("Reforestation"));
        categories[1] = vm.envOr("IMPACT_CATEGORY_2", string("Renewable Energy"));
        categories[2] = vm.envOr("IMPACT_CATEGORY_3", string("Clean Water"));
        categories[3] = vm.envOr("IMPACT_CATEGORY_4", string("Biodiversity"));
        
        return categories;
    }
    
    function getImpactMultipliers() internal view returns (uint256[] memory) {
        uint256[] memory multipliers = new uint256[](4);
        
        // Use environment variables if available, otherwise defaults
        multipliers[0] = vm.envOr("IMPACT_MULTIPLIER_1", uint256(2500));
        multipliers[1] = vm.envOr("IMPACT_MULTIPLIER_2", uint256(3500));
        multipliers[2] = vm.envOr("IMPACT_MULTIPLIER_3", uint256(3000));
        multipliers[3] = vm.envOr("IMPACT_MULTIPLIER_4", uint256(2800));
        
        return multipliers;
    }
} 