<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <label>Name: </label>
    <input type="text" v-model="name"><br><br>
    <label>National ID: </label>
    <input type="text" v-model="nationalID"><br><br>
    <button v-on:click="register()">Register</button>
  </div>
</template>

<script>

export default {
  name: 'Registration',
  props: {
    msg: String,
    web3: Object,
    biconomy: Object,
    contract: Object,
    account: String
  },
  data() {
    return {
      display: '',
      name: '',
      nationalID: ''
    }
  },

  methods: {

    async register() {
      console.log("Test: ", this.name);
      const result = await this.contract.methods.register(this.name, this.nationalID).send({from:this.account, signatureType: this.biconomy.EIP712_SIGN,});
      if (result) {
        console.log("Registered successfully");
        alert("Registered successfully");
        this.display = "Successful!"
      } else {
        this.display = "Something went wrong, please try again.";
      }
    }

  }
}
</script>
