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
import {Biconomy} from "@biconomy/mexa";

export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data() {
    return {
      web3: null,
      biconomy: null,
      contract: null,
      account: '0x0',
      candidate1: '',
      candidate2: ''
    }
  },

  async mounted() {
    console.log("Starting up!");
    await this.initProvider();
    console.log("Successfully initialised");
  },

  methods: {

    async initProvider() {
      if (window.ethereum) {

        this.biconomy = new Biconomy(window.ethereum,{apiKey: "Pj7HMFUMB.15802489-8c48-4782-a908-bf1846da7d46", debug: true});
        this.web3 = new Web3(this.biconomy);

        console.log("Current web3 version:",this.web3.version);

        let accounts = await this.web3.eth.getAccounts();
        this.account = accounts[0];
        console.log("Current connected account:",this.account);

        this.biconomy.onEvent(this.biconomy.READY, () => {
          // Initialize your dapp here once ready
          console.log("Biconomy initialised successfully");
        }).onEvent(this.biconomy.ERROR, (error) => {
          // Handle error while initializing mexa
          console.log("Error initialising Biconomy: ", error);
        });

        //const contractAddress = "0xB84D7C7241E5C3acA5fBE63c12F40a3697891C64"; //ropsten testnet
        const contractAddress = "0xB84D7C7241E5C3acA5fBE63c12F40a3697891C64"; //mumbai testnet
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
      await this.contract.methods.vote(candidateID).send({from:this.account, signatureType: this.biconomy.EIP712_SIGN,});
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
