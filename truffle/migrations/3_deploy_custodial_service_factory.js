const CustodialServiceFactory = artifacts.require("CustodialServiceContractFactory");

module.exports = function (deployer) {
  deployer.deploy(CustodialServiceFactory);
};