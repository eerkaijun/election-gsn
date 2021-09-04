<template>
  <div id="app">
    <img alt="Vue logo" src="./assets/logo.jpg">
    <Registration  msg="Please register yourself"/>
    <HelloWorld msg="Welcome to the e-voting system"/>
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
