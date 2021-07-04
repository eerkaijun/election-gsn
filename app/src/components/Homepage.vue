<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <p>
      For a guide and recipes on how to configure / customize this project,<br>
      check out the
      <a href="https://cli.vuejs.org" target="_blank" rel="noopener">vue-cli documentation</a>.
    </p>
    <h3>Candidates</h3>
    <ul>
      <li>{{ candidate1 }}</li>
      <li>{{ candidate2 }}</li>
    </ul>
    <h3>Installed CLI Plugins</h3>
    <ul>
      <li><a href="https://github.com/vuejs/vue-cli/tree/dev/packages/%40vue/cli-plugin-babel" target="_blank" rel="noopener">babel</a></li>
      <li><a href="https://github.com/vuejs/vue-cli/tree/dev/packages/%40vue/cli-plugin-eslint" target="_blank" rel="noopener">eslint</a></li>
    </ul>
    <h3>Essential Links</h3>
    <ul>
      <li><a href="https://vuejs.org" target="_blank" rel="noopener">Core Docs</a></li>
      <li><a href="https://forum.vuejs.org" target="_blank" rel="noopener">Forum</a></li>
      <li><a href="https://chat.vuejs.org" target="_blank" rel="noopener">Community Chat</a></li>
      <li><a href="https://twitter.com/vuejs" target="_blank" rel="noopener">Twitter</a></li>
      <li><a href="https://news.vuejs.org" target="_blank" rel="noopener">News</a></li>
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
