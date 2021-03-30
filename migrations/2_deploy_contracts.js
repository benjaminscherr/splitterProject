const Splitter = artifacts.require("Splitter");
const SafeMath = artifacts.require("SafeMath");

module.exports = function(deployer, network, accounts) {

  deployer.deploy(SafeMath);
  deployer.link(SafeMath, Splitter);
  deployer.deploy(Splitter, {from: accounts[0]});

};
