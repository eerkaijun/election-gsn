<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <button v-on:click="initCandidates()">View Candidates</button>
    <h3>Candidates</h3>
    <ul>
      <li>{{ candidate1 }}<br><button v-on:click="vote(0)">Vote</button></li>
      <li>{{ candidate2 }}<br><button v-on:click="vote(1)">Vote</button></li>
    </ul>
  </div>
</template>

<script>

export default {
  name: 'HelloWorld',
  props: {
    msg: String,
    web3: Object,
    biconomy: Object,
    contract: Object,
    account: String
  },
  data() {
    return {
      candidate1: '',
      candidate2: ''
    }
  },

  methods: {

    async initCandidates() {
      console.log("Starting...");
      this.candidate1 = await this.contract.methods.getCandidateName(0).call();
      this.candidate2 = await this.contract.methods.getCandidateName(1).call();
      console.log("Initialised candidates");
    },

    async vote(candidateID) {
      await this.contract.methods.vote(candidateID).send({from:this.account, signatureType: this.biconomy.EIP712_SIGN,});
      console.log("Voted successfully!");
      alert("Voted successfully");
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
