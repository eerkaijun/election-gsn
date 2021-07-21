<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <label>Name: </label>
    <input type="text" v-model="name"><br><br>
    <label>National ID: </label>
    <input type="text" v-model="nationalID"><br><br>
    <button v-on:click="register()">Register</button>
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
  name: 'Registration',
  props: {
    msg: String,
  },
  data() {
    return {
      web3: null,
      contract: null,
      account: '0x0',
      display: '',
      name: '',
      nationalID: ''
    }
  },

  async mounted() {
    console.log("Starting up!");
    this.initProvider();
  },

  methods: {

    async initProvider() {
      if (window.ethereum) {

        this.web3 = new Web3(window.ethereum); //force it to version 1.3.0
        console.log("Current web3 version:",this.web3.version);

        let accounts = await this.web3.eth.getAccounts();
        this.account = accounts[0];
        console.log("Current connected account:",this.account);

        //const contractAddress = "0xB84D7C7241E5C3acA5fBE63c12F40a3697891C64"; //ropsten testnet
        const contractAddress = "0x81E2cb23446745772b8cF4D3298DE054D84A4a27"; //mumbai testnet
        this.contract = await new this.web3.eth.Contract(VoteABI, contractAddress);

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

    async register() {
      console.log("Test: ", this.name);
      const result = await this.contract.methods.register(this.name, this.nationalID).send({from:this.account});
      if (result) {
        console.log("Registered successfully");
        this.display = "Successful!"
      } else {
        this.display = "Something went wrong, please try again.";
      }
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
