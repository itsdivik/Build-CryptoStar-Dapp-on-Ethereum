const HDWalletProvider = require("truffle-hdwallet-provider");
const mnemonic = "rebel salad visit never tattoo chuckle skate south system coral connect paddle";
const infuraEndpoint = "https://rinkeby.infura.io/v3/27d005760d8a4c219c1ac040d6ed3161";
 module.exports = {
      networks: {
        development: {
            host: '127.0.0.1',
            port: 8545,
            network_id: "*",
            gas: 6721975,
			},
             rinkeby: {
            host: "localhost",
            provider: () => new HDWalletProvider(mnemonic, infuraEndpoint),
            network_id: 4,
            gas: 6721975,
            gasPrice: 20000000000,
			},
		},
           solc: {
        optimizer: {
            enabled: true,
            runs: 200
        }}		
        };
