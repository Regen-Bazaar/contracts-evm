// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console.sol";

/**
 * @title DeploymentConfig
 * @dev Manages configuration and addresses for the deployment sequence
 */
contract DeploymentConfig is Script {
    // Configuration
    address public admin;
    address public platformWallet;
    uint256 public initialTokenSupply;
    string public baseTokenURI;
    
    // Deployed addresses
    address public rebazTokenAddress;
    address public impactNFTAddress;
    address public stakingAddress;
    address public marketplaceAddress; 
    address public factoryAddress;
    
    // Status tracking
    bool public initialized;
    
    function initialize() public virtual {
        require(!initialized, "Already initialized");
        
        // Default configuration with validation
        admin = msg.sender;
        platformWallet = msg.sender;
        initialTokenSupply = 1_000_000 * 10**18;
        baseTokenURI = "https://api.regenbazaar.com/metadata/";
        
        // Override with env variables if available with proper validation
        if (vm.envOr("ADMIN_ADDRESS", bytes("")).length > 0) {
            address envAdmin = vm.envAddress("ADMIN_ADDRESS");
            require(envAdmin != address(0), "Invalid admin address from env");
            admin = envAdmin;
        }
        
        if (vm.envOr("PLATFORM_WALLET", bytes("")).length > 0) {
            address envPlatformWallet = vm.envAddress("PLATFORM_WALLET");
            require(envPlatformWallet != address(0), "Invalid platform wallet from env");
            platformWallet = envPlatformWallet;
        }
        
        if (vm.envOr("INITIAL_TOKEN_SUPPLY", bytes("")).length > 0) {
            uint256 envSupply = vm.envUint("INITIAL_TOKEN_SUPPLY");
            require(envSupply > 0, "Initial token supply must be greater than 0");
            require(envSupply <= 1_000_000_000 * 10**18, "Initial token supply too large");
            initialTokenSupply = envSupply;
        }
        
        if (vm.envOr("BASE_TOKEN_URI", bytes("")).length > 0) {
            string memory envURI = vm.envString("BASE_TOKEN_URI");
            require(bytes(envURI).length > 0, "Base token URI cannot be empty");
            baseTokenURI = envURI;
        }
        
        // Validate final configuration
        require(admin != address(0), "Admin address cannot be zero");
        require(platformWallet != address(0), "Platform wallet cannot be zero");
        require(initialTokenSupply > 0, "Initial token supply must be greater than 0");
        require(bytes(baseTokenURI).length > 0, "Base token URI cannot be empty");
        
        // Load previously deployed addresses if available
        loadDeployedAddresses();
        
        initialized = true;
        
        console.log("Deployment configuration initialized:");
        console.log("  Admin:           ", admin);
        console.log("  Platform Wallet: ", platformWallet);
        console.log("  Token Supply:    ", initialTokenSupply);
    }
    
    function loadDeployedAddresses() internal {
        string memory deploymentFile = "deployments/addresses.json";
        
        if (vm.exists(deploymentFile)) {
            try vm.readFile(deploymentFile) returns (string memory json) {
                // Parse JSON with proper error handling
                try vm.parseJson(json, ".rebazToken") returns (bytes memory tokenData) {
                    if (tokenData.length > 0) {
                        rebazTokenAddress = vm.parseJsonAddress(json, ".rebazToken");
                        require(rebazTokenAddress.code.length > 0, "Invalid rebaz token address");
                    }
                } catch {
                    console.log("Warning: Could not parse rebazToken address");
                }
                
                try vm.parseJson(json, ".impactNFT") returns (bytes memory nftData) {
                    if (nftData.length > 0) {
                        impactNFTAddress = vm.parseJsonAddress(json, ".impactNFT");
                        require(impactNFTAddress.code.length > 0, "Invalid impact NFT address");
                    }
                } catch {
                    console.log("Warning: Could not parse impactNFT address");
                }
                
                try vm.parseJson(json, ".staking") returns (bytes memory stakingData) {
                    if (stakingData.length > 0) {
                        stakingAddress = vm.parseJsonAddress(json, ".staking");
                        require(stakingAddress.code.length > 0, "Invalid staking address");
                    }
                } catch {
                    console.log("Warning: Could not parse staking address");
                }
                
                try vm.parseJson(json, ".marketplace") returns (bytes memory marketplaceData) {
                    if (marketplaceData.length > 0) {
                        marketplaceAddress = vm.parseJsonAddress(json, ".marketplace");
                        require(marketplaceAddress.code.length > 0, "Invalid marketplace address");
                    }
                } catch {
                    console.log("Warning: Could not parse marketplace address");
                }
                
                try vm.parseJson(json, ".factory") returns (bytes memory factoryData) {
                    if (factoryData.length > 0) {
                        factoryAddress = vm.parseJsonAddress(json, ".factory");
                        require(factoryAddress.code.length > 0, "Invalid factory address");
                    }
                } catch {
                    console.log("Warning: Could not parse factory address");
                }
                
                console.log("Loaded deployed addresses from file");
            } catch {
                console.log("Warning: Could not read deployment file, starting fresh");
            }
        }
    }
    
    function saveDeployedAddresses() internal {
        // Create deployments directory if it doesn't exist
        try vm.readDir("deployments") {
            // Directory exists
        } catch {
            vm.createDir("deployments", true);
        }
        
        // Construct JSON with proper formatting
        string memory json = '{\n';
        json = string.concat(json, '  "rebazToken": "', vm.toString(rebazTokenAddress), '",\n');
        json = string.concat(json, '  "impactNFT": "', vm.toString(impactNFTAddress), '",\n');
        json = string.concat(json, '  "staking": "', vm.toString(stakingAddress), '",\n');
        json = string.concat(json, '  "marketplace": "', vm.toString(marketplaceAddress), '",\n');
        json = string.concat(json, '  "factory": "', vm.toString(factoryAddress), '",\n');
        json = string.concat(json, '  "admin": "', vm.toString(admin), '",\n');
        json = string.concat(json, '  "platformWallet": "', vm.toString(platformWallet), '",\n');
        json = string.concat(json, '  "deploymentTimestamp": ', vm.toString(block.timestamp), ',\n');
        json = string.concat(json, '  "chainId": ', vm.toString(block.chainid), '\n');
        json = string.concat(json, '}');
        
        // Write to file with error handling
        try vm.writeFile("deployments/addresses.json", json) {
            console.log("Saved deployed addresses to file");
        } catch {
            console.log("Error: Could not save deployment addresses");
        }
    }
    
    // Utility functions for deployment verification
    function verifyTokenDeployment() internal view {
        require(rebazTokenAddress != address(0), "Token not deployed");
        require(rebazTokenAddress.code.length > 0, "Invalid token deployment");
    }
    
    function verifyNFTDeployment() internal view {
        require(impactNFTAddress != address(0), "NFT not deployed");
        require(impactNFTAddress.code.length > 0, "Invalid NFT deployment");
    }
    
    function verifyStakingDeployment() internal view {
        require(stakingAddress != address(0), "Staking not deployed");
        require(stakingAddress.code.length > 0, "Invalid staking deployment");
    }
    
    function verifyMarketplaceDeployment() internal view {
        require(marketplaceAddress != address(0), "Marketplace not deployed");
        require(marketplaceAddress.code.length > 0, "Invalid marketplace deployment");
    }
    
    function verifyFactoryDeployment() internal view {
        require(factoryAddress != address(0), "Factory not deployed");
        require(factoryAddress.code.length > 0, "Invalid factory deployment");
    }
}