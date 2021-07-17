var Vote = artifacts.require("./Vote.sol");
//var Paymaster = artifacts.require("./Paymaster.sol");

module.exports = function(deployer) {
  deployer.deploy(Vote);
  //deployer.deploy(Paymaster);
};
