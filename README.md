# 🖼️ NFT Project

This repository demonstrates a complete pipeline for generating and deploying an NFT collection, including asset generation, metadata creation, IPFS uploading, and smart contract deployment using Solidity + Foundry.

## 🔧 Tech Stack

- **Python** – for generating image assets and metadata
- **Solidity** – custom ERC721 contract
- **Foundry** – for compiling, testing, and deploying the smart contract
- **Pinata / IPFS** – to store NFT assets and metadata
- *(Coming soon)* Basic front end to interact with the smart contract

---

## 📁 Folder Structure

```
nft-project/
├── assets/             # Sample generated images (PNG)
├── metadata/           # Sample JSON metadata files
├── generate_assets/    # Python script to generate images and metadata
│   └── generate.py
├── solidity/           # Foundry project with smart contract code
│   ├── src/
│   │   └── SynthCats.sol
│   └── foundry.toml
├── frontend/           # (To be implemented)
└── README.md
```

---

## 🧩 How It Works


### 1. Generate Assets and Metadata

- The Python script in `generate_assets/` generates **layers** for the NFT images.
- The actual image and metadata generation is handled by the **Hashlips Engine** using those layers.

---

### 2. Upload to IPFS

You can use [Pinata](https://www.pinata.cloud/) or any IPFS gateway.

1. Upload the `assets/` folder to get the base CID for images.
2. Upload the `metadata/` folder to get the base CID for metadata.
3. Update your smart contract or metadata URIs accordingly.

---

### 3. Smart Contract Deployment

Located in `solidity/src/SynthCats.sol`.

- Implements ERC721 standard
- Supports base URI for IPFS metadata

To compile, test, and deploy:

```bash
cd solidity
forge build
forge test
forge script script/Deploy.s.sol --broadcast --rpc-url YOUR_RPC_URL --private-key YOUR_PRIVATE_KEY
```

---

### 4. Frontend (Work in Progress)

A simple web UI for minting and viewing NFTs will be added under the `frontend/` folder.

---


