var app = new Vue({
  el: '#app',
  data: {
    web3Provider: null,
    contracts: {},
    account: '0x0',
    message: 'Welcome to polling station!',
    loading: true,
    results: [],
    selected_id: -1,
  },

  created: function() {
    const self = this;
    if (typeof web3 !== 'undefined') {
      this.web3Provider = web3.currentProvider;
      ethereum.enable();
      web3 = new Web3(web3.currentProvider);
    } else {
      console.log("Please set up provider ie Metamask");
    }

    fetch('Election.json').then(function(response){
      return response.json();
    }).then(function(data) {
      //cannot use this keyword here because of different scope
      self.contracts.Election = TruffleContract(data);
      self.contracts.Election.setProvider(app.web3Provider);
    });

    web3.eth.getCoinbase(function(err, account) {
      if (err === null) {
        self.account = account;
      }
    });

  },

  methods: {

    render: function(instance) {
      const self = this;
      var electionInstance;
      this.loading = false;

      //console.log(this.contracts.Election);
      this.contracts.Election.deployed().then(function(instance) {
        electionInstance = instance;

        return electionInstance.candidatesCount();
      }).then(function(candidatesCount) {

        for (var i = 1; i <= candidatesCount; i++) {
          //console.log("test");
          electionInstance.candidates(i).then(function(candidate) {

            //var id = candidate[0];
            //var name = candidate[1];
            //var voteCount = candidate[2];
            //console.log(id);
            //console.log(name);
            // Render candidate Result
            //var candidateTemplate = "<tr><th>" + id + "</th><td>" + name + "</td><td>" + voteCount + "</td></tr>";
            //candidatesResults.append(candidateTemplate);

            self.results.push({id:parseInt(candidate[0]), name:candidate[1], voteCount:parseInt(candidate[2])});
            console.log(self.results);

            //var candidateOption = "<option value='" + id + "' >" + name + "</ option>"
            //candidatesSelect.append(candidateOption);
          });
        }
        return electionInstance.voters(self.account);
        //loader.hide();
        //content.show();
      }).then(function(hasVoted) {
        if(hasVoted) {
          self.message = "You have already voted";
          self.loading = true;
        }
      })
    },

    castVote: function(candidateId) {
      const self = this;
      this.contracts.Election.deployed().then(function(instance) {
        return instance.vote(candidateId, { from: this.account });
      }).then(function(result) {
        self.message = "Thanks for Voting!";
      }).catch(function(err) {
        console.error(err);
      });
    },

  },
});


Vue.component('candidates-results', {
	props: ['results'],
	template: `
  <table class="table">
    <thead>
      <tr>
        <th scope="col">#</th>
        <th scope="col">Name</th>
        <th scope="col">Votes</th>
      </tr>
    </thead>
    <tbody v-for="result in results">
      <tr><th>{{result.id}}</th><td>{{result.name}}</td><td>{{result.voteCount}}</td></tr>
    </tbody>
  </table>
	`
})
