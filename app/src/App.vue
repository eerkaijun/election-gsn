<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.jpg">
    <Registration  msg="Please register yourself"/>
    <HelloWorld msg="Welcome to the e-voting system"/>
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
