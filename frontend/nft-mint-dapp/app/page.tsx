'use client';

import { useState } from 'react';
import { Button, VStack, Heading, Text, useToast } from '@chakra-ui/react';
import { ethers } from 'ethers';
import abi from '../lib/synthCat.json';

const CONTRACT_ADDRESS = '0xbb039e9b4030fb08ff13fc5BCc2906bb03F55093';

export default function Home() {
  const [signer, setSigner] = useState<ethers.Signer | null>(null);
  const [account, setAccount] = useState<string | null>(null);
  const [minting, setMinting] = useState(false);
  const toast = useToast();

  const connectWallet = async () => {
    if (!window.ethereum) return alert('Please install MetaMask');
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    const address = await signer.getAddress();
    setSigner(signer);
    setAccount(address);
  };

  const handleMint = async () => {
    if (!signer) return toast({ title: 'Connect wallet first', status: 'warning' });
    setMinting(true);
    try {
      const contract = new ethers.Contract(CONTRACT_ADDRESS, abi, signer);
      const tx = await contract.mint(1, {
        value: ethers.parseEther("0.001"),
      });
      await tx.wait();
      toast({ title: 'Mint successful!', status: 'success' });
    } catch (err: any) {
      toast({ title: 'Mint failed', description: err.message, status: 'error' });
    }
    setMinting(false);
  };

  return (
    <VStack spacing={4} p={8}>
      <Heading>NFT Mint</Heading>
      {account ? (
        <Text>Connected: {account.slice(0, 6)}...{account.slice(-4)}</Text>
      ) : (
        <Button onClick={connectWallet}>Connect Wallet</Button>
      )}
      <Button isLoading={minting} onClick={handleMint} colorScheme="teal">
        Mint NFT
      </Button>
    </VStack>
  );
}
