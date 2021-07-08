<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <h3>Candidates</h3>
    <ul>
      <li>{{ candidate1 }}<br><button v-on:click="vote(0)">Vote</button></li>
      <li>{{ candidate2 }}<br><button v-on:click="vote(1)">Vote</button></li>
    </ul>
    <h3>Ecosystem</h3>
    <ul>
      <li><a href="https://router.vuejs.org" target="_blank" rel="noopener">vue-router</a></li>
      <li><a href="https://vuex.vuejs.org" target="_blank" rel="noopener">vuex</a></li>
      <li><a href="https://github.com/vuejs/vue-devtools#vue-devtools" target="_blank" rel="noopener">vue-devtools</a></li>
      <li><a href="https://vue-loader.vuejs.org" target="_blank" rel="noopener">vue-loader</a></li>
      <li><a href="https://github.com/vuejs/awesome-vue" target="_blank" rel="noopener">awesome-vue</a></li>
    </ul>
  </div>
</template>

<script>

import VoteABI from '../abi/Vote';
const Web3 = require('web3');

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
    this.initContract();
  },

  methods: {

    async initProvider() {
      if (window.ethereum) {
        this.web3 = new Web3(window.ethereum); //force it to version 1.3.0
        console.log("Current web3 version:",this.web3.version);
        let accounts = await this.web3.eth.getAccounts();
        this.account = accounts[0];
        console.log("Current connected account:",this.account);
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

    async initContract() {
      const contractAddress = "0x474F8eBacD6341B4E6e44018D5eDa65687D72Fbd"; //ropsten testnet
      this.contract = await new this.web3.eth.Contract(VoteABI, contractAddress);
      // hardcoded - to be improved in the future
      this.candidate1 = await this.contract.methods.getCandidateName(0).call();
      this.candidate2 = await this.contract.methods.getCandidateName(1).call();
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
a {
  color: #42b983;
}
</style>
