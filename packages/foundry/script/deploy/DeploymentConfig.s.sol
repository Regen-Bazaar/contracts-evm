// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console.sol";

/**
 * @title DeploymentConfig
 * @dev Simple configuration manager for deployment sequence
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
    
    function initialize() public virtual {
        // Default configuration
        admin = msg.sender;
        platformWallet = msg.sender;
        initialTokenSupply = 1_000_000 * 10**18;
        baseTokenURI = "https://api.regenbazaar.com/metadata/";
        
        // Override with env variables if available
        if (vm.envOr("ADMIN_ADDRESS", bytes("")).length > 0) {
            admin = vm.envAddress("ADMIN_ADDRESS");
        }
        
        if (vm.envOr("PLATFORM_WALLET", bytes("")).length > 0) {
            platformWallet = vm.envAddress("PLATFORM_WALLET");
        }
        
        if (vm.envOr("INITIAL_TOKEN_SUPPLY", bytes("")).length > 0) {
            initialTokenSupply = vm.envUint("INITIAL_TOKEN_SUPPLY");
        }
        
        if (vm.envOr("BASE_TOKEN_URI", bytes("")).length > 0) {
            baseTokenURI = vm.envString("BASE_TOKEN_URI");
        }
        
        // Load previously deployed addresses if available
        loadDeployedAddresses();
        
        console.log("Deployment configuration:");
        console.log("  Admin:           ", admin);
        console.log("  Platform Wallet: ", platformWallet);
        console.log("  Token Supply:    ", initialTokenSupply);
    }
    
    function loadDeployedAddresses() internal {
        string memory deploymentFile = "addresses.json";
        
        if (vm.exists(deploymentFile)) {
            try vm.readFile(deploymentFile) returns (string memory json) {
                try vm.parseJsonAddress(json, ".rebazToken") returns (address addr) {
                    rebazTokenAddress = addr;
                } catch {}
                
                try vm.parseJsonAddress(json, ".impactNFT") returns (address addr) {
                    impactNFTAddress = addr;
                } catch {}
                
                try vm.parseJsonAddress(json, ".staking") returns (address addr) {
                    stakingAddress = addr;
                } catch {}
                
                try vm.parseJsonAddress(json, ".marketplace") returns (address addr) {
                    marketplaceAddress = addr;
                } catch {}
                
                try vm.parseJsonAddress(json, ".factory") returns (address addr) {
                    factoryAddress = addr;
                } catch {}
                
                console.log("Loaded existing addresses from addresses.json");
            } catch {
                console.log("No existing addresses.json found, starting fresh");
            }
        }
    }
    
    function saveDeployedAddresses() internal {
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
        
        vm.writeFile("addresses.json", json);
        console.log("Saved addresses to addresses.json");
    }
}