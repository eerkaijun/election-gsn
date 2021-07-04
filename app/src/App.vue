<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.jpg">
    <HelloWorld msg="Welcome to the e-voting system"/>
  </div>
</template>

<script>
import HelloWorld from './components/Homepage.vue'

export default {
  name: 'App',
  components: {
    HelloWorld
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
</style>
