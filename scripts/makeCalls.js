const {encode} = require("./utils/enc");

const ExampleClient = require('../artifacts/contracts/client/ExampleClient.sol/ExampleClient.json')

const PROVIDER_ID = "0xd9c5115d8ca09413513b0348ccd4aa5d5d2b8183823763b527bfd81f40d86f2a";
const CONSUMER_ID = 1;
const EXAMPLECLIENT_CONTRACT_ADDRESS = "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9";
const CONSUMER_ADMIN_PRIVATE_KEY = "0x75fc7599ca0dc0f860d1e4a1b2921d4d7195b26d11b541491f4e2bf0d517e105";
const DAPI_WALLET = "0xE500370A81a95e68E6C0b8Fecd1D26fB4DDf94D4";

async function main() {
    const clientContract = await new ethers.Contract(EXAMPLECLIENT_CONTRACT_ADDRESS, ExampleClient.abi, ethers.getDefaultProvider());

    let provider = new ethers.providers.JsonRpcProvider("http://127.0.0.1:8545");
    let wallet = new ethers.Wallet(CONSUMER_ADMIN_PRIVATE_KEY);
    wallet = await wallet.connect(provider);
    const client = clientContract.connect(wallet);

    const endpointId1 = ethers.utils.keccak256(ethers.utils.defaultAbiCoder.encode(['string'], ['getCoinPrice']));
    await client.makeRequestInt256(PROVIDER_ID, endpointId1, CONSUMER_ID, DAPI_WALLET, encode([
        {name: 'id', type: 'string', value: "bitcoin"},
    ]));
    await client.makeRequestUint256(PROVIDER_ID, endpointId1, CONSUMER_ID, DAPI_WALLET, encode([
        {name: 'id', type: 'string', value: "bitcoin"},
    ]));

    const endpointId2 = ethers.utils.keccak256(ethers.utils.defaultAbiCoder.encode(['string'], ['coinExists']));
    await client.makeRequestBool(PROVIDER_ID, endpointId2, CONSUMER_ID, DAPI_WALLET, encode([
        {name: 'id', type: 'string', value: "bitcoin"},
    ]));

    const endpointId3 = ethers.utils.keccak256(ethers.utils.defaultAbiCoder.encode(['string'], ['getCoinDesc']));
    await client.makeRequestString(PROVIDER_ID, endpointId3, CONSUMER_ID, DAPI_WALLET, encode([
        {name: 'id', type: 'string', value: "bitcoin"},
    ]));
    await client.makeRequestBytes(PROVIDER_ID, endpointId3, CONSUMER_ID, DAPI_WALLET, encode([
        {name: 'id', type: 'string', value: "bitcoin"},
    ]));
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
