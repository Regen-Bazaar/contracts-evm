#!/bin/bash

# Deploy contracts to Celo Alfajores Testnet individually
# This script deploys each contract separately and verifies it before moving to the next

set -e

echo "=== Celo Alfajores Individual Deployment Script ==="

# Load environment variables
source .env

# Check if required environment variables are set
if [ -z "$PRIVATE_KEY" ]; then
    echo "Error: PRIVATE_KEY environment variable is required"
    exit 1
fi

if [ -z "$CELOSCAN_API_KEY" ]; then
    echo "Warning: CELOSCAN_API_KEY not set. Verification will need to be done manually."
fi

# Set default values if not provided
export ADMIN_ADDRESS=${ADMIN_ADDRESS:-$(cast wallet address --private-key $PRIVATE_KEY)}
export PLATFORM_WALLET=${PLATFORM_WALLET:-$ADMIN_ADDRESS}
export INITIAL_TOKEN_SUPPLY=${INITIAL_TOKEN_SUPPLY:-1000000000000000000000000}
export BASE_TOKEN_URI=${BASE_TOKEN_URI:-"https://api.regenbazaar.com/metadata/"}

echo "Deployment Configuration:"
echo "  Network: Celo Alfajores Testnet"
echo "  Deployer: $ADMIN_ADDRESS"
echo "  Platform Wallet: $PLATFORM_WALLET"
echo "  Initial Token Supply: $INITIAL_TOKEN_SUPPLY"
echo "  Base Token URI: $BASE_TOKEN_URI"
echo ""

# Build contracts
echo "Building contracts..."
forge build --force

# Function to deploy and verify a contract
deploy_and_verify() {
    local contract_name=$1
    local script_name=$2
    local constructor_args=$3
    
    echo "=== Deploying $contract_name ==="
    
    # Deploy the contract
    forge script script/deploy/$script_name \
        --rpc-url https://alfajores-forno.celo-testnet.org \
        --private-key $PRIVATE_KEY \
        --broadcast \
        --verify \
        --etherscan-api-key $CELOSCAN_API_KEY \
        --chain-id 44787
    
    # Get the deployed address from the broadcast log
    local deployed_address=$(forge script script/deploy/$script_name \
        --rpc-url https://alfajores-forno.celo-testnet.org \
        --private-key $PRIVATE_KEY \
        --silent | grep "Deployed to:" | tail -1 | awk '{print $3}')
    
    if [ -n "$deployed_address" ]; then
        echo "✓ $contract_name deployed at: $deployed_address"
        
        # Verify the contract has code
        local contract_code=$(cast code $deployed_address --rpc-url https://alfajores-forno.celo-testnet.org)
        if [ "$contract_code" != "0x" ]; then
            echo "✓ Contract verification: Code deployed successfully"
        else
            echo "✗ Contract verification: No code found at address"
            exit 1
        fi
        
        # Save the address
        echo "$contract_name: $deployed_address" >> deployed_addresses.txt
    else
        echo "✗ Failed to get deployed address for $contract_name"
        exit 1
    fi
    
    echo ""
}

# Clear previous deployment records
rm -f deployed_addresses.txt

# Deploy contracts one by one
echo "Starting individual deployment..."

# 1. Deploy REBAZ Token
deploy_and_verify "REBAZ Token" "1_DeployREBAZToken.s.sol" "$INITIAL_TOKEN_SUPPLY,$ADMIN_ADDRESS"

# 2. Deploy Impact Product NFT
deploy_and_verify "Impact Product NFT" "2_DeployImpactProductNFT.s.sol" "$PLATFORM_WALLET,$BASE_TOKEN_URI"

# 3. Deploy Impact Product Staking
# Get the addresses from the previous deployments
REBAZ_TOKEN_ADDRESS=$(grep "REBAZ Token:" deployed_addresses.txt | awk '{print $3}')
IMPACT_NFT_ADDRESS=$(grep "Impact Product NFT:" deployed_addresses.txt | awk '{print $4}')
deploy_and_verify "Impact Product Staking" "3_DeployImpactProductStaking.s.sol" "$IMPACT_NFT_ADDRESS,$REBAZ_TOKEN_ADDRESS"

# 4. Deploy Marketplace
deploy_and_verify "Regen Marketplace" "4_DeployMarketplace.s.sol" "$IMPACT_NFT_ADDRESS,$PLATFORM_WALLET"

# 5. Deploy Impact Product Factory
deploy_and_verify "Impact Product Factory" "5_DeployImpactProductFactory.s.sol" "$IMPACT_NFT_ADDRESS,$PLATFORM_WALLET"

echo "=== All Contracts Deployed Successfully ==="
echo ""
echo "Deployed Contract Addresses:"
cat deployed_addresses.txt
echo ""

# Create deployment summary
echo "=== Creating Deployment Summary ==="
./script/deploy/verify_celo.sh

echo "=== Deployment Complete ==="
echo "All contracts have been deployed and verified on Celo Alfajores testnet!" 