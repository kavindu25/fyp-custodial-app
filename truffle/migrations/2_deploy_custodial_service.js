const CustodialService = artifacts.require("CustodialServiceContract");

module.exports = function (deployer, network, accounts) {
  const marketplaceOwner = accounts[0]
  deployer.deploy(CustodialService, marketplaceOwner);
  //0x9A31D1FbadDD7E132DD10Df1F36F0B1204ca265b
  //0xBdB2e28972daa994F34b6b99bCEe1240d273753e   - 10
};