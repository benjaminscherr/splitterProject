const Splitter = artifacts.require("Splitter");

module.exports = function(deployer, network, accounts) {

  const aliceAddress = accounts[0];
  const bobAddress = accounts[1];
  const carolAddress = accounts[2];
  deployer.deploy(Splitter, aliceAddress, bobAddress, carolAddress);

};
