<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.jpg"><br>
    <button v-on:click="getAccount()">Enable Polygon</button>
    <Registration  msg="Please register yourself"
      v-bind:biconomy="biconomy"
      v-bind:contract="contract"
      v-bind:web3="web3"
      v-bind:account="account"/>
    <HelloWorld msg="Welcome to the e-voting system"
      v-bind:biconomy="biconomy"
      v-bind:contract="contract"
      v-bind:web3="web3"
      v-bind:account="account"/>
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
// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyAI87js9PTS1RmAWisH3sta0bg-4FjbWvc",
  authDomain: "web-hosting-6bbb1.firebaseapp.com",
  projectId: "web-hosting-6bbb1",
  storageBucket: "web-hosting-6bbb1.appspot.com",
  messagingSenderId: "535890411968",
  appId: "1:535890411968:web:e9f0d6b6a2b746ff960825"
};

// Initialize Firebase
// const app = initializeApp(firebaseConfig);
initializeApp(firebaseConfig);

import VoteABI from './abi/Vote';
const Web3 = require('web3');
import {Biconomy} from "@biconomy/mexa";

import HelloWorld from './components/Homepage.vue';
import Registration from './components/Registration.vue';

export default {
  name: 'App',
  components: {
    HelloWorld,
    Registration
  },
  data() {
    return {
      web3: null,
      biconomy: null,
      contract: null,
      account: '0x0',
    }
  },

  async mounted() {
    console.log("Starting up!");
    this.initProvider();
  },

  methods: {

    async getAccount() {
      if (window.ethereum) {
        const accounts = await window.ethereum.request({method: 'eth_requestAccounts'});
        this.account = accounts[0];
        console.log("Finally connected successfully: ", this.account);
      }
    },

    async initProvider() {
      if (window.ethereum) {

        this.biconomy = new Biconomy(window.ethereum,{apiKey: "Pj7HMFUMB.15802489-8c48-4782-a908-bf1846da7d46", debug: true});
        this.web3 = new Web3(this.biconomy);

        //this.web3 = new Web3(window.ethereum); //force it to version 1.3.0
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

        const contractAddress = "0xB84D7C7241E5C3acA5fBE63c12F40a3697891C64"; //mumbai testnet
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
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
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
