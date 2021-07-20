<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.jpg">
    <Registration v-if="registered==false" msg="Please register yourself"/>
    <HelloWorld v-if="registered" msg="Welcome to the e-voting system"/>
  </div>
</template>

<script>
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
      registered: false
    }
  },

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
</style>
