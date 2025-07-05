# Celo Alfajores Testnet Deployment

## Overview
This document contains the deployment information for the RegenBazaar smart contracts on the Celo Alfajores testnet.

## Network Information
- **Network**: Celo Alfajores Testnet
- **Chain ID**: 44787
- **RPC URL**: `wss://celo-alfajores.drpc.org`
- **Explorer**: https://alfajores.celoscan.io
- **Deployment Date**: December 2024

## Deployed Contracts
    
### 1. REBAZ Token (ERC20)
- **Contract**: `REBAZToken.sol`
- **Address**: `0x1b641Ed830394C78505B85fB3487f1Ed0d97aEaA`
- **Transaction Hash**: `0x2af70e38a2d29da442f44242abe7708580fc02022d0d72f810c964ef2fb7f629`
- **Total Supply**: 1,000,000 REBAZ tokens
- **Admin**: `0x0f3616BD93ee1523a4Dd1a9F99126BFc4bEb5551`
- **Verification**: ✅ Verified on CeloScan
- **CeloScan URL**: https://alfajores.celoscan.io/address/0x1b641ed830394c78505b85fb3487f1ed0d97aeaa

### 2. Impact Product NFT (ERC721)
- **Contract**: `ImpactProductNFT.sol`
- **Address**: `0x0c1835eb279373b82d0F31E58c605A5D690EaC6b`
- **Transaction Hash**: `0x7c7222a7b90924c9dbabdc868a34159d5ad3cb7f48d065120cc1617224981c4c`
- **Platform Wallet**: `0x0f3616BD93ee1523a4Dd1a9F99126BFc4bEb5551`
- **Base Token URI**: `https://api.regenbazaar.com/metadata/`
- **Verification**: ✅ Verified on CeloScan
- **CeloScan URL**: https://alfajores.celoscan.io/address/0x0c1835eb279373b82d0f31e58c605a5d690eac6b

### 3. Impact Product Staking
- **Contract**: `ImpactProductStaking.sol`
- **Address**: `0xB4ba7Db25D6E8e19eAc402CE23FCA29ac8f7E9Cd`
- **Transaction Hash**: `0x8a5aeeabf96c784739147aa8776b7b5ea48806572afe266723bae0b9a9a3040f`
- **NFT Address**: `0x0c1835eb279373b82d0F31E58c605A5D690EaC6b`
- **Token Address**: `0x1b641Ed830394C78505B85fB3487f1Ed0d97aEaA`
- **MINTER_ROLE**: ✅ Granted
- **Verification**: ✅ Verified on CeloScan
- **CeloScan URL**: https://alfajores.celoscan.io/address/0xb4ba7db25d6e8e19eac402ce23fca29ac8f7e9cd

### 4. Regen Marketplace
- **Contract**: `MarketPlace.sol`
- **Address**: `0xe899891b5b74CEac22Ed0D8b1288D0e288F88d82`
- **Transaction Hash**: `0x6e9ed846b79521d7707fb6ef1adbaf9a4a6d46f88c66337f387b37b366c52726`
- **NFT Address**: `0x0c1835eb279373b82d0F31E58c605A5D690EaC6b`
- **Platform Wallet**: `0x0f3616BD93ee1523a4Dd1a9F99126BFc4bEb5551`
- **Verification**: ✅ Verified on CeloScan
- **CeloScan URL**: https://alfajores.celoscan.io/address/0xe899891b5b74ceac22ed0d8b1288d0e288f88d82

### 5. Impact Product Factory
- **Contract**: `ImpactProductFactory.sol`
- **Address**: `0xa663d8687270664D232A456F54AC4C011D096a03`
- **Transaction Hash**: `0x9dc3bc2bf9070e122be5a2a86f2e98e9254fcb6a41a68846947c50aafdcb277e`
- **NFT Address**: `0x0c1835eb279373b82d0F31E58c605A5D690EaC6b`
- **Platform Wallet**: `0x0f3616BD93ee1523a4Dd1a9F99126BFc4bEb5551`
- **MINTER_ROLE**: ✅ Granted
- **VERIFIER_ROLE**: ✅ Granted
- **Verification**: ✅ Verified on CeloScan
- **CeloScan URL**: https://alfajores.celoscan.io/address/0xa663d8687270664d232a456f54ac4c011d096a03

## Key Addresses
- **Admin**: `0x0f3616BD93ee1523a4Dd1a9F99126BFc4bEb5551`
- **Platform Wallet**: `0x0f3616BD93ee1523a4Dd1a9F99126BFc4bEb5551`

## Contract Interactions

### Staking Contract Setup
The staking contract has been granted MINTER_ROLE on the NFT contract, allowing it to mint NFTs for staking rewards.

### Factory Contract Setup
The factory contract has been granted:
- MINTER_ROLE on the NFT contract for creating impact products
- VERIFIER_ROLE for product verification

### Marketplace Setup
The marketplace is configured to work with the deployed NFT contract and platform wallet.

## Gas Costs
- **REBAZ Token**: 0.049398000841 ETH (1,975,841 gas)
- **Impact NFT**: 0.093526040892 ETH (3,740,892 gas)
- **Staking Contract**: 0.040433242265 ETH (1,617,265 gas)
- **Marketplace**: 0.038189252509 ETH (1,527,509 gas)
- **Factory**: 0.067248789844 ETH (2,689,844 gas)

**Total Gas Used**: 9,551,351 gas
**Total Cost**: ~0.288795 ETH

## Verification Status
All contracts have been successfully verified on CeloScan and are ready for use.

## Next Steps
1. Test contract interactions using the deployed addresses
2. Set up frontend integration with the deployed contracts
3. Configure any additional parameters or roles as needed
4. Monitor contract usage and performance

## Notes
- All contracts are deployed on the Celo Alfajores testnet
- The admin address controls all administrative functions
- The platform wallet receives fees and royalties
- All contracts are verified and publicly accessible on CeloScan 