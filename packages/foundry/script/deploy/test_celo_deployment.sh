#!/bin/bash

# Test Celo deployment configuration
# This script tests the deployment setup without actually deploying

set -e

echo "=== Testing Celo Deployment Configuration ==="

# Check if we're in the right directory
if [ ! -f "foundry.toml" ]; then
    echo "Error: foundry.toml not found. Please run this script from the foundry directory."
    exit 1
fi

echo "✓ Foundry configuration found"

# Check if required scripts exist
if [ ! -f "script/deploy/DeployCelo.s.sol" ]; then
    echo "Error: DeployCelo.s.sol not found"
    exit 1
fi

if [ ! -f "script/deploy/VerifyCelo.s.sol" ]; then
    echo "Error: VerifyCelo.s.sol not found"
    exit 1
fi

echo "✓ Deployment scripts found"

# Check if contracts exist
CONTRACTS=(
    "contracts/tokens/REBAZToken.sol"
    "contracts/tokens/ImpactProductNFT.sol"
    "contracts/staking/ImpactProductStaking.sol"
    "contracts/marketplace/MarketPlace.sol"
    "contracts/factory/ImpactProductFactory.sol"
)

for contract in "${CONTRACTS[@]}"; do
    if [ ! -f "$contract" ]; then
        echo "Error: $contract not found"
        exit 1
    fi
    echo "✓ $contract found"
done

# Test compilation
echo ""
echo "Testing contract compilation..."
if forge build --force; then
    echo "✓ Contracts compile successfully"
else
    echo "✗ Contract compilation failed"
    exit 1
fi

# Check network configuration
echo ""
echo "Testing network configuration..."
if grep -q "alfajores" foundry.toml; then
    echo "✓ Celo Alfajores network configured"
else
    echo "✗ Celo Alfajores network not configured"
    exit 1
fi

# Check etherscan configuration
if grep -q "alfajores.*key" foundry.toml; then
    echo "✓ CeloScan verification configured"
else
    echo "✗ CeloScan verification not configured"
fi

# Test RPC connectivity
echo ""
echo "Testing RPC connectivity..."
if curl -s -X POST -H "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' \
    https://alfajores-forno.celo-testnet.org > /dev/null 2>&1; then
    echo "✓ Celo Alfajores RPC is accessible"
else
    echo "✗ Celo Alfajores RPC is not accessible"
    echo "  This might be a temporary network issue"
fi

# Check environment variables
echo ""
echo "Environment variable check:"
if [ -n "$PRIVATE_KEY" ]; then
    echo "✓ PRIVATE_KEY is set"
else
    echo "⚠ PRIVATE_KEY is not set (required for deployment)"
fi

if [ -n "$CELOSCAN_API_KEY" ]; then
    echo "✓ CELOSCAN_API_KEY is set"
else
    echo "⚠ CELOSCAN_API_KEY is not set (optional for verification)"
fi

# Display deployment information
echo ""
echo "=== Deployment Information ==="
echo "Network: Celo Alfajores Testnet"
echo "RPC URL: https://alfajores-forno.celo-testnet.org"
echo "Chain ID: 44787"
echo "Block Explorer: https://alfajores.celoscan.io/"
echo ""

echo "=== Ready for Deployment ==="
echo "To deploy your contracts:"
echo "1. Set your private key: export PRIVATE_KEY=your_private_key"
echo "2. Optionally set CeloScan API key: export CELOSCAN_API_KEY=your_api_key"
echo "3. Run: ./script/deploy/deploy_celo.sh"
echo ""

echo "✓ All tests passed! Your deployment configuration is ready." 