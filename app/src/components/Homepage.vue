<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <h3>Candidates</h3>
    <ul>
      <li>{{ candidate1 }}<br><button v-on:click="vote(0)">Vote</button></li>
      <li>{{ candidate2 }}<br><button v-on:click="vote(1)">Vote</button></li>
    </ul>
  </div>
</template>

<script>

import VoteABI from '../abi/Vote';
const Web3 = require('web3');
const { RelayProvider } = require('@opengsn/provider');

// Ropsten accept-everything paymaster (pre-deployed)
//const paymasterAddress = "0x05319d82fa69EA8434A967CdF4A2699Db4Ff40e8";
// Mumbai accept-everything paymaster (pre-deployed)
//const paymasterAddress = "0xcA94aBEdcC18A10521aB7273B3F3D5ED28Cf7B8A";
// Mumbai accept-everything paymaster (self-deployed)
const paymasterAddress = "0x627Ed19358C1b8194eb49c6e7Cfe538Be1C73d2c";
const gsnConfig = {
    paymasterAddress,
    loggerConfiguration: {
        logLevel: 'debug',
        loggerUrl: 'logger.opengsn.org',
    }
};
const useGSN = false; //boolean to indicate whether user needs to pay their own gas

export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data() {
    return {
      web3: null,
      contract: null,
      account: '0x0',
      candidate1: '',
      candidate2: ''
    }
  },

  async mounted() {
    console.log("Starting up!");
    this.initProvider();
  },

  methods: {

    async initProvider() {
      if (window.ethereum) {

        if (useGSN) {
          // with GSN
          console.log("Sponsoring gas fee through gas station network~~");
          const provider = await RelayProvider.newProvider({ provider: window.ethereum, gsnConfig }).init();
          this.web3 = new Web3(provider);
        } else {
          // without GSN
          this.web3 = new Web3(window.ethereum); //force it to version 1.3.0
        }

        console.log("Current web3 version:",this.web3.version);

        let accounts = await this.web3.eth.getAccounts();
        this.account = accounts[0];
        console.log("Current connected account:",this.account);

        //const contractAddress = "0xB84D7C7241E5C3acA5fBE63c12F40a3697891C64"; //ropsten testnet
        const contractAddress = "0x81E2cb23446745772b8cF4D3298DE054D84A4a27"; //mumbai testnet
        this.contract = await new this.web3.eth.Contract(VoteABI, contractAddress);
        this.candidate1 = await this.contract.methods.getCandidateName(0).call();
        this.candidate2 = await this.contract.methods.getCandidateName(1).call();

      } else {
        console.log("Please install Metamask to continue.");
      }

      setInterval(async() => {
        //check whether account is changed at every one second interval
        let updated;
        updated = await this.web3.eth.getAccounts();
        if (updated[0] !== this.account) {
          this.account = updated[0];
        }
      }, 1000);
    },

    async vote(candidateID) {
      await this.contract.methods.vote(candidateID).send({from:this.account});
      console.log("Voted successfully!");
    }

  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
</style>
