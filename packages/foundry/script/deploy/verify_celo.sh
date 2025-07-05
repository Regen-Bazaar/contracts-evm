#!/bin/bash

# Verify contracts on Celo Alfajores Testnet
# This script provides verification information for deployed contracts

set -e

echo "=== Celo Alfajores Verification Script ==="

# Check if addresses.json exists
if [ ! -f "addresses.json" ]; then
    echo "Error: addresses.json not found. Please deploy contracts first."
    exit 1
fi

# Load addresses from JSON
REBAZ_TOKEN=$(jq -r '.rebazToken' addresses.json)
IMPACT_NFT=$(jq -r '.impactNFT' addresses.json)
STAKING=$(jq -r '.staking' addresses.json)
MARKETPLACE=$(jq -r '.marketplace' addresses.json)
FACTORY=$(jq -r '.factory' addresses.json)
ADMIN=$(jq -r '.admin' addresses.json)
PLATFORM_WALLET=$(jq -r '.platformWallet' addresses.json)
CHAIN_ID=$(jq -r '.chainId' addresses.json)

echo "Deployed Contract Addresses:"
echo "  REBAZ Token:          $REBAZ_TOKEN"
echo "  Impact Product NFT:   $IMPACT_NFT"
echo "  Impact Product Staking: $STAKING"
echo "  Regen Marketplace:    $MARKETPLACE"
echo "  Impact Product Factory: $FACTORY"
echo "  Admin:                $ADMIN"
echo "  Platform Wallet:      $PLATFORM_WALLET"
echo "  Chain ID:             $CHAIN_ID"
echo ""

echo "=== Verification Information ==="
echo "Visit CeloScan to verify contracts: https://alfajores.celoscan.io/"
echo ""

echo "Constructor Arguments for Manual Verification:"
echo ""
echo "REBAZ Token:"
echo "  Address: $REBAZ_TOKEN"
echo "  Constructor Args: $INITIAL_TOKEN_SUPPLY,$ADMIN"
echo ""
echo "Impact Product NFT:"
echo "  Address: $IMPACT_NFT"
echo "  Constructor Args: $PLATFORM_WALLET,$BASE_TOKEN_URI"
echo ""
echo "Impact Product Staking:"
echo "  Address: $STAKING"
echo "  Constructor Args: $IMPACT_NFT,$REBAZ_TOKEN"
echo ""
echo "Regen Marketplace:"
echo "  Address: $MARKETPLACE"
echo "  Constructor Args: $IMPACT_NFT,$PLATFORM_WALLET"
echo ""
echo "Impact Product Factory:"
echo "  Address: $FACTORY"
echo "  Constructor Args: $IMPACT_NFT,$PLATFORM_WALLET"
echo ""

echo "=== Verification Steps ==="
echo "1. Go to https://alfajores.celoscan.io/"
echo "2. Search for each contract address"
echo "3. Click 'Contract' tab"
echo "4. Click 'Verify and Publish'"
echo "5. Use these settings:"
echo "   - Compiler Type: Solidity (Single file)"
echo "   - Compiler Version: 0.8.20"
echo "   - Optimization: Yes"
echo "   - Runs: 1000"
echo "   - Constructor Arguments: (see above)"
echo ""

echo "=== Contract Links ==="
echo "REBAZ Token: https://alfajores.celoscan.io/address/$REBAZ_TOKEN"
echo "Impact Product NFT: https://alfajores.celoscan.io/address/$IMPACT_NFT"
echo "Impact Product Staking: https://alfajores.celoscan.io/address/$STAKING"
echo "Regen Marketplace: https://alfajores.celoscan.io/address/$MARKETPLACE"
echo "Impact Product Factory: https://alfajores.celoscan.io/address/$FACTORY"
echo ""

# Check if contracts are deployed
echo "=== Contract Status Check ==="
if [ -n "$PRIVATE_KEY" ]; then
    echo "Checking contract deployment status..."
    forge script script/deploy/VerifyCelo.s.sol:VerifyCelo \
        --rpc-url https://alfajores-forno.celo-testnet.org \
        --private-key $PRIVATE_KEY
else
    echo "PRIVATE_KEY not set. Skipping contract status check."
    echo "Set PRIVATE_KEY to check contract status."
fi 