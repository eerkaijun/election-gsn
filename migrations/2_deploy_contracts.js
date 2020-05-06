var Election = artifacts.require("./Election.sol");
var Paymaster = artifacts.require("./Paymaster.sol");

module.exports = function(deployer) {
  deployer.deploy(Election);
  deployer.deploy(Paymaster);
};
