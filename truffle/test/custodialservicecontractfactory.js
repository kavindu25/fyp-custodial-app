const CustodialServiceFactory = artifacts.require("CustodialServiceContractFactory");
const CustodialService = artifacts.require("CustodialServiceContract");

contract("CustodialServiceFactory", (accounts) => {
    let custodialServiceFactory;

    beforeEach(async () => {
        custodialServiceFactory = await CustodialServiceFactory.new();
    });

    it("should create a new CustodialServiceContract instance.", async () => {
        await custodialServiceFactory.createCustodialService(accounts[0]);
        const deployedCustodialServices = await custodialServiceFactory.getDeployedCustodialServiceContracts();
        assert.equal(deployedCustodialServices.length, 1);

        const custodialService = await CustodialService.at(deployedCustodialServices[0]);
        const owner = await custodialService.owner();
        assert.equal(owner, accounts[0] )
    });

    it('should create multiple CustodialServiceContract instances', async () => {
        await custodialServiceFactory.createCustodialService(accounts[0]);
        await custodialServiceFactory.createCustodialService(accounts[1]);

        const deployedCustodialServices = await custodialServiceFactory.getDeployedCustodialServiceContracts();
        assert.equal(deployedCustodialServices.length, 2);
    });

});