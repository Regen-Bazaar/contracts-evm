#!/bin/bash

# Simple deployment script for Regen Bazaar contracts
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Default RPC URL
RPC_URL="http://localhost:8545"

# Parse arguments
for arg in "$@"; do
    case $arg in
        --rpc=*)
            RPC_URL="${arg#*=}"
            shift
            ;;
        --help)
            echo "Usage: ./deploy.sh [options] [contract-number]"
            echo ""
            echo "Options:"
            echo "  --rpc=URL        Use a specific RPC URL (default: http://localhost:8545)"
            echo ""
            echo "Contract numbers:"
            echo "  1    Deploy REBAZ Token"
            echo "  2    Deploy Impact Product NFT"
            echo "  3    Deploy Impact Product Staking"
            echo "  4    Deploy Regen Marketplace"
            echo "  5    Deploy Impact Product Factory"
            echo "  all  Deploy all contracts in sequence"
            echo ""
            echo "Examples:"
            echo "  ./deploy.sh 1                          Deploy only REBAZ Token"
            echo "  ./deploy.sh all                        Deploy all contracts"
            echo "  ./deploy.sh --rpc=http://localhost:8545 2  Deploy NFT to specific RPC"
            exit 0
            ;;
    esac
done

CONTRACT=$1

if [ -z "$CONTRACT" ]; then
    echo -e "${RED}Error: No contract specified${NC}"
    echo "Use --help for usage information"
    exit 1
fi

cd ../..

echo -e "${BLUE}Deploying to: $RPC_URL${NC}"

case $CONTRACT in
    1)
        echo -e "${GREEN}Deploying REBAZ Token...${NC}"
        forge script script/deploy/1_DeployREBAZToken.s.sol:DeployREBAZToken --rpc-url $RPC_URL --broadcast --via-ir
        ;;
    2)
        echo -e "${GREEN}Deploying Impact Product NFT...${NC}"
        forge script script/deploy/2_DeployImpactProductNFT.s.sol:DeployImpactProductNFT --rpc-url $RPC_URL --broadcast --via-ir
        ;;
    3)
        echo -e "${GREEN}Deploying Impact Product Staking...${NC}"
        forge script script/deploy/3_DeployImpactProductStaking.s.sol:DeployImpactProductStaking --rpc-url $RPC_URL --broadcast --via-ir
        ;;
    4)
        echo -e "${GREEN}Deploying Regen Marketplace...${NC}"
        forge script script/deploy/4_DeployMarketplace.s.sol:DeployMarketplace --rpc-url $RPC_URL --broadcast --via-ir
        ;;
    5)
        echo -e "${GREEN}Deploying Impact Product Factory...${NC}"
        forge script script/deploy/5_DeployImpactProductFactory.s.sol:DeployImpactProductFactory --rpc-url $RPC_URL --broadcast --via-ir
        ;;
    all)
        echo -e "${GREEN}Deploying all contracts in sequence...${NC}"
        forge script script/deploy/DeployAll.s.sol:DeployAll --rpc-url $RPC_URL --broadcast --via-ir
        ;;
    *)
        echo -e "${RED}Error: Invalid contract number or option${NC}"
        echo "Valid options: 1, 2, 3, 4, 5, all"
        echo "Use --help for more information"
        exit 1
        ;;
esac

# Show addresses if file exists
if [ -f "addresses.json" ]; then
    echo -e "${GREEN}Current deployment addresses:${NC}"
    cat addresses.json
else
    echo -e "${YELLOW}No addresses.json file found${NC}"
fi

echo -e "${GREEN}Deployment complete!${NC}" 