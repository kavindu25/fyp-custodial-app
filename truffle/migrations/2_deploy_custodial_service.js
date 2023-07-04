const CustodialService = artifacts.require("CustodialServiceContract");

module.exports = function (deployer) {
  deployer.deploy(CustodialService);
};