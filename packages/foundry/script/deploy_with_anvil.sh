#!/bin/bash

# Simple script to start anvil and deploy all contracts
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Starting Anvil...${NC}"
anvil --block-time 5 &
ANVIL_PID=$!

# Wait for Anvil to start
sleep 3

# Use default anvil account
PRIVATE_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"

echo -e "${BLUE}Deploying all contracts...${NC}"
forge script script/deploy/DeployAll.s.sol:DeployAll --rpc-url http://localhost:8545 --private-key $PRIVATE_KEY --broadcast

# Show final addresses
if [ -f "addresses.json" ]; then
    echo -e "${GREEN}Deployed contract addresses:${NC}"
    cat addresses.json
else
    echo -e "${RED}Warning: addresses.json not found${NC}"
fi

# Cleanup
kill $ANVIL_PID
echo -e "${GREEN}Deployment complete!${NC}" 