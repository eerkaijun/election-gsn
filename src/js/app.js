//const { RelayProvider } = require('@opengsn/gsn')
//const configuration = { relayHubAddress: relayHub.address, stakeManagerAddress: stakeManager.address };
//const provider = new RelayProvider(web3.currentProvider, configuration);
//const web3 = new Web3(provider);

const conf = {
	target:    '0x022E6D19FDfD34E876424cb69f0626d387d93453',
	paymaster: '0x580d8b8118324c6A0C7eb17DB603D558059e344D',
	relayhub:  '0xEF46DD512bCD36619a6531Ca84B188b47D85124b',
	stakemgr:  '0x41c7C7c1Bf501e2F43b51c200FEeEC87540AC925',
	gasPrice:  20000000000   // 20 Gwei
};

const Gsn = require("@opengsn/gsn/dist/src/relayclient/");
const RelayProvider = Gsn.RelayProvider;

const configureGSN = require('@opengsn/gsn/dist/src/relayclient/GSNConfigurator').configureGSN;

//const ethers = require("ethers")
const gsnConfig = configureGSN({
	relayHubAddress: conf.relayhub,
	paymasterAddress: conf.paymaster,
	stakeManagerAddress: conf.stakemgr,
	gasPriceFactorPercent: 70,
	methodSuffix: '_v4',
	jsonStringifyRequest: true,
	chainId: 3,
	relayLookupWindowBlocks: 1e5
})    // gsnConfig

//const origProvider = window.ethereum;
//const gsnProvider = new RelayProvider(origProvider, gsnConfig);
//const provider = new ethers.providers.Web3Provider(gsnProvider);

const gsnProvider = new RelayProvider(web3.currentProvider, gsnConfig);

App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {

		//
		//ethereum.enable();
		//web3 = new Web3(gsnProvider);

    if (typeof web3 !== 'undefined') {
      //App.web3Provider = web3.currentProvider;
			App.web3Provider = gsnProvider;
      ethereum.enable();
      web3 = new Web3(web3.currentProvider);
    } else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      ethereum.enable();
      web3 = new Web3(App.web3Provider);
    }
    return App.initContractElection();
  },

  initContractElection: function() {
    //the reason this works is because of bs-config file
    $.getJSON("Election.json", function(election){
      App.contracts.Election = TruffleContract(election);
      App.contracts.Election.setProvider(App.web3Provider);
      //App.listenForEvents();
      return App.render();
    })
  },

  render: function() {
    var electionInstance;
    var loader = $("#loader");
    var content = $("#content");

    loader.show();
    content.hide();

    web3.eth.getCoinbase(function(err, account) {
      if (err === null) {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    App.contracts.Election.deployed().then(function(instance) {
      electionInstance = instance;
      return electionInstance.candidatesCount();
    }).then(function(candidatesCount) {
      var candidatesResults = $("#candidatesResults");
      candidatesResults.empty();

      var candidatesSelect = $('#candidatesSelect');
      candidatesSelect.empty();

      for (var i = 1; i <= candidatesCount; i++) {
        electionInstance.candidates(i).then(function(candidate) {
          var id = candidate[0];
          var name = candidate[1];
          var voteCount = candidate[2];

          // Render candidate Result
          var candidateTemplate = "<tr><th>" + id + "</th><td>" + name + "</td><td>" + voteCount + "</td></tr>";
          candidatesResults.append(candidateTemplate);

          var candidateOption = "<option value='" + id + "' >" + name + "</ option>"
          candidatesSelect.append(candidateOption);
        });
      }
      return electionInstance.voters(App.account);
      //loader.hide();
      //content.show();
    }).then(function(hasVoted) {
      if(hasVoted) {
        $('form').hide();
      }
      loader.hide();
      content.show();
    }).catch(function(error) {
      console.warn(error);
    });
  },

  castVote: function() {
    var candidateId = $('#candidatesSelect').val();
    App.contracts.Election.deployed().then(function(instance) {
      return instance.vote(candidateId, { from: App.account });
    }).then(function(result) {
      // Wait for votes to update
      $("#content").hide();
      $("#loader").show();
    }).catch(function(err) {
      console.error(err);
    });
  },

  /*
  getVotingTicket: function() {
    App.contracts.Vote.deployed().then(function(instance) {
      return instance.mint({from: App.account});
    });
  },*/

  /*
  transferToken: function() {
    //var electionInstance;
    App.contracts.Election.deployed().then(function(i) {
      electionInstance = i;
      return App.contracts.Vote.deployed().address;
    }).then(function(_voteAddress) {
      return electionInstance.transferOwnership(_voteAddress, {from:App.account});
    });
  },*/



  /*
  listenForEvents: function() {
    App.contracts.Election.deployed().then(function(instance) {
      instance.votedEvent({}, {
        fromBlock: 0,
        toBlock: 'latest'
      }).watch(function(error, event) {
        console.log("event triggered", event)
        // Reload when a new vote is recorded
        App.render();
      });
    });
  }*/

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
