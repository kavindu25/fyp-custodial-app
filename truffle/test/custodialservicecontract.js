const CustodialService = artifacts.require("CustodialServiceContract");

contract('CustodialServiceContract', (accounts) =>{
    let custodialService;
    const owner = accounts[0];
    const user1 = accounts[1];
    const user2 = accounts[2];
    //const user1wla = accounts[3];
    //const user2wla = accounts[4];

    beforeEach(async () => {
        custodialService = await CustodialService.new({ from: owner });
    });

    // it('should add a new user', async () => {
    //     await custodialService.addUser(user1, accounts[1], { from: owner });

    //     //const userInfo = await custodialService.users(user1);
    //     const userInfo = await custodialService.getUserInfo(user1);
    //     assert.equal(userInfo.isActive, true, "User is not activated");
    //     assert.equal(userInfo.balance, 0, "User balnce has not been set to 0");
    //     assert.equal(userInfo.whitelistAddress, accounts[1], "User does not have a whitelist address");
    // });

    // it('should deactivate a user', async () => {
    //     await custodialService.addUser(user1, accounts[1], { from: owner });
    //     await custodialService.deactivateUser(user1, { from: owner });

    //     //const userInfo = await custodialService.users(user1);
    //     const userInfo = await custodialService.getUserInfo(user1);
    //     assert.equal(userInfo.isActive, false, "User has not deactivated");
    // });

    // it('should allow owner to top up a user balance', async () => {
    //     const amount = web3.utils.toWei('1', 'ether');

    //     await custodialService.addUser(user1, accounts[1], { from: owner });
    //     await custodialService.topUpETH(amount, user1, { from: owner, value: amount });

    //     //const userInfo = await custodialService.users(user1);
    //     const userInfo = await custodialService.getUserInfo(user1);
    //     assert.equal(userInfo.balance.toString(), amount, "User balance does not match with topped up amount");
    // });

    // it('should allow users to transfer balance', async () => {
    //     const amount = web3.utils.toWei('1', 'ether');
    //     const transferAmount = web3.utils.toWei('0.5', 'ether');

    //     await custodialService.addUser(user1, accounts[1], { from: owner });
    //     await custodialService.addUser(user2, accounts[2], { from: owner });

    //     await custodialService.topUpETH(amount, user1, { from: owner, value: amount });
    //     await custodialService.transferETH(user1, user2, transferAmount, { from: user1 });

    //     //const user1Info = await custodialService.users(user1);
    //     //const user2Info = await custodialService.users(user2);

    //     const user1Info = await custodialService.getUserInfo(user1);
    //     const user2Info = await custodialService.getUserInfo(user2);

    //     assert.equal(user1Info.balance.toString(), web3.utils.toWei('0.5', 'ether'), "Sender balance is incorrect");
    //     assert.equal(user2Info.balance.toString(), web3.utils.toWei('0.5', 'ether'), "Receiver balance is incorrect");
    // });

    it('should allow users to withdraw their funds', async () => {
        const amount = web3.utils.toWei('1', 'ether');
        const transferAmount = web3.utils.toWei('0.5', 'ether');

        await custodialService.addUser(user1, accounts[1], { from: owner });
        await custodialService.topUpETH(amount, user1, { from: owner, value: amount });

        await custodialService.withdrawETH(transferAmount, user1, accounts[1]);
        const userInfo = await custodialService.getUserInfo(user1);
        assert.equal(userInfo.balance.toString(), web3.utils.toWei('0.5', 'ether'), "Sender balance incorrect" );
        assert.equal(accounts[2].balance.toString(), web3.utils.toWei('100', 'ether'), "Receiver balance incorrect" );

    });
    
});