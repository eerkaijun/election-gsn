var Paymaster = artifacts.require("./Paymaster.sol");

module.exports = function(deployer) {
  deployer.deploy(Paymaster);
};
