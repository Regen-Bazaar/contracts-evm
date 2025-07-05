#!/bin/bash

# Deploy to Celo Alfajores Testnet
# This script deploys all contracts to Celo Alfajores and provides verification information

set -e

echo "=== Celo Alfajores Deployment Script ==="

# Check if required environment variables are set
if [ -z "$PRIVATE_KEY" ]; then
    echo "Error: PRIVATE_KEY environment variable is required"
    echo "Please set your private key: export PRIVATE_KEY=your_private_key_here"
    exit 1
fi

if [ -z "$CELOSCAN_API_KEY" ]; then
    echo "Warning: CELOSCAN_API_KEY not set. Verification will need to be done manually."
    echo "Get your API key from: https://celoscan.io/apis"
fi

# Set default values if not provided
export ADMIN_ADDRESS=${ADMIN_ADDRESS:-$(cast wallet address --private-key $PRIVATE_KEY)}
export PLATFORM_WALLET=${PLATFORM_WALLET:-$ADMIN_ADDRESS}
export INITIAL_TOKEN_SUPPLY=${INITIAL_TOKEN_SUPPLY:-1000000000000000000000000}  # 1M tokens
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

# Deploy contracts
echo "Deploying contracts to Celo Alfajores..."
forge script script/deploy/DeployCelo.s.sol:DeployCelo \
    --rpc-url https://alfajores-forno.celo-testnet.org \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    --etherscan-api-key $CELOSCAN_API_KEY \
    --chain-id 44787

echo ""
echo "=== Deployment Complete ==="
echo ""

# Display deployment summary
if [ -f "addresses.json" ]; then
    echo "Deployed Contract Addresses:"
    cat addresses.json | jq -r '
        "REBAZ Token: " + .rebazToken,
        "Impact Product NFT: " + .impactNFT,
        "Impact Product Staking: " + .staking,
        "Regen Marketplace: " + .marketplace,
        "Impact Product Factory: " + .factory
    '
    echo ""
fi

echo "=== Verification Information ==="
echo "If automatic verification failed, you can verify manually on CeloScan:"
echo "https://alfajores.celoscan.io/"
echo ""
echo "For each contract, you'll need:"
echo "1. Contract address (from addresses.json)"
echo "2. Contract source code"
echo "3. Constructor arguments"
echo ""
echo "Constructor arguments format:"
echo "REBAZ Token: $INITIAL_TOKEN_SUPPLY,$ADMIN_ADDRESS"
echo "Impact Product NFT: $PLATFORM_WALLET,$BASE_TOKEN_URI"
echo "Impact Product Staking: [NFT_ADDRESS],[TOKEN_ADDRESS]"
echo "Marketplace: [NFT_ADDRESS],$PLATFORM_WALLET"
echo "Factory: [NFT_ADDRESS],$PLATFORM_WALLET"
echo ""

echo "=== Next Steps ==="
echo "1. Test contract interactions on Alfajores"
echo "2. Update your frontend configuration"
echo "3. Consider deploying to Celo mainnet when ready"
echo ""

# Optional: Run verification script
if [ -n "$CELOSCAN_API_KEY" ]; then
    echo "Running verification script..."
    forge script script/deploy/VerifyCelo.s.sol:VerifyCelo \
        --rpc-url https://alfajores-forno.celo-testnet.org \
        --private-key $PRIVATE_KEY
fi 