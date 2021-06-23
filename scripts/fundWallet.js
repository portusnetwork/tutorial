async function main() {
  let provider = new ethers.providers.JsonRpcProvider("http://127.0.0.1:8545");
  let wallet = ethers.Wallet.fromMnemonic("test test test test test test test test test test test junk");
  wallet = await wallet.connect(provider);
  await wallet.sendTransaction({ to: process.env.WALLET, value: ethers.utils.parseEther("1.0") })
 
  let balance = await provider.getBalance(process.env.WALLET);
  console.log("Wallet balance: " + ethers.utils.formatEther(balance));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });