require('@nomiclabs/hardhat-waffle');
require('hardhat-deploy');

module.exports = {
    networks: {
        hardhat: {
            chainId: 31337,
            accounts: {
                mnemonic: "test test test test test test test test test test test junk",
                initialIndex: 0,
                path: "m/44'/60'/0'/0",
                count: 10,
                accountsBalance: "10000000000000000000000"
            }
        }
    },
    solidity: {
        version: "0.6.12",
        settings: {
            optimizer: {
                enabled: true,
                runs: 200
            }
        }
    }
}
