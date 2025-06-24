# 🏗 Regen Bazaar Monorepo

<p align="center">
  <a href="https://docs.scaffoldeth.io">Scaffold-ETH 2 Docs</a> |
  <a href="https://scaffoldeth.io">Scaffold-ETH 2 Website</a>
</p>

> An open-source toolkit for building dapps on Ethereum.  
> Powers the Regen Bazaar platform frontend (Next.js, TypeScript, Wagmi/Viem) and smart contracts (Foundry).

---

## Requirements

- Node.js ≥ 18.18  
- Yarn (v1 or v2+)  
- Git  
- Foundry (Forge, Cast, Anvil)

---

## Quickstart

### 1. Clone & install

```bash
# Clone using SSH (recommended)
git clone https://github.com/trudransh/regenbazaar-monorepo.git
# Or with HTTPS
# git clone https://github.com/Regen-Bazaar/regenbazaar-monorepo.git

cd regenbazaar-monorepo
npm install
```

### 2. Start a local environment like Ganache using anvil

```bash
# Launch Anvil via Foundry
anvil
```

### 3. Compile smart contracts

```bash
cd regenbazaar/packages/foundry

# Clean and install dependencies (if you encounter issues)
rm -rf lib/forge-std/ lib/openzeppelin-contracts/
forge install foundry-rs/forge-std --no-commit
forge install OpenZeppelin/openzeppelin-contracts --no-commit

# Build contracts
forge compile
```

## 4. Contract Deployment

There are several ways to deploy the contracts:

### Option 1: Deploy All Contracts at Once (Recommended)

This is the easiest way to deploy all contracts with proper nonce sequencing:

```bash
cd packages/foundry

# Clean up any previous deployments (optional)
rm -f addresses.json
rm -rf broadcast/

# Deploy all contracts with a local anvil instance
./script/deploy_with_anvil.sh
```

This script will:
1. Start a local Anvil blockchain
2. Deploy all contracts in sequence with proper nonce management
3. Display the deployed addresses
4. Save addresses to `addresses.json`
5. Shut down Anvil when done

### Option 2: Deploy Individual Contracts

If you need more control, you can deploy contracts individually:

```bash
cd packages/foundry

# Deploy specific contracts (1-5)
./script/deploy/deploy.sh 1    # Deploy REBAZ Token
./script/deploy/deploy.sh 2    # Deploy Impact NFT
./script/deploy/deploy.sh 3    # Deploy Staking
./script/deploy/deploy.sh 4    # Deploy Marketplace
./script/deploy/deploy.sh 5    # Deploy Factory

# Or deploy all contracts in sequence
./script/deploy/deploy.sh all
```

### Option 3: Deploy to a Testnet or Mainnet

```bash
cd packages/foundry

# Deploy all contracts to a testnet (e.g., Sepolia)
./script/deploy/deploy.sh --rpc=https://sepolia.infura.io/v3/YOUR_API_KEY all

# Or deploy individual contracts
./script/deploy/deploy.sh --rpc=https://sepolia.infura.io/v3/YOUR_API_KEY 1
```

### Verifying Successful Deployment

After deployment, you can verify success by:

1. Check the `addresses.json` file for unique contract addresses
2. Ensure each contract has a different address
3. Verify the addresses match the logs shown during deployment

The deployment is successful if all contracts have unique addresses and no errors occurred.

## Contract Structure

Inside `packages/foundry/contracts` you'll find:

- **tokens/REBAZToken.sol**  
  ERC20 governance & utility token  
- **tokens/ImpactProductNFT.sol**  
  ERC721 NFT for real-world impact projects  
- **factory/ImpactProductFactory.sol**  
  Factory to mint new ImpactProductNFTs  
- **marketplace/RegenBazaarMarketplace.sol**  
  Listing and trading of impact NFTs  
- **staking/ImpactProductStaking.sol**  
  Staking logic for REBAZ tokens & NFTs  
- **interfaces/**  
  All contract interfaces (IREBAZ, IImpactProductNFT, IImpactProductFactory, IImpactProductNFT, IImpactProductStaking)

---

## Troubleshooting

### Authentication Issues
If you encounter authentication errors with GitHub:
```bash
# Configure Git to use SSH instead of HTTPS for GitHub (if you have SSH set up)
git config --global url."git@github.com:".insteadOf "https://github.com/"
```

### Missing Dependencies
- If you see errors about missing files, ensure all dependencies are properly installed:
```bash
# Reinstall forge standard libraries
rm -rf lib/forge-std
forge install foundry-rs/forge-std --no-commit

# Reinstall OpenZeppelin
rm -rf lib/openzeppelin-contracts
forge install OpenZeppelin/openzeppelin-contracts --no-commit
```

### Import Errors
- Ensure remappings in `packages/foundry/remappings.txt` or `foundry.toml` include:  
  ```
  @openzeppelin/=lib/openzeppelin-contracts/
  forge-std/=lib/forge-std/src/
  ```

### Deployment Issues
- **Same contract addresses**: This happens when nonces aren't properly sequenced. Use the `deploy_with_anvil.sh` script or `deploy.sh all` to ensure proper sequencing.
- **Anvil connection errors**: Check if Anvil is running on port 8545 and not being used by another process.
- **Missing addresses.json**: Make sure you have write permissions in the directory.

### Linearization errors
When using multiple ERC721 extensions, put the more-specific contract first in the `is` list:
```solidity
contract MyNFT is ERC721URIStorage, ERC721Enumerable { … }
```

---

© 2024 Regen Bazaar · Built on Scaffold-ETH 2 · MIT License  