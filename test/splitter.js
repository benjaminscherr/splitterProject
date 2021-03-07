const Splitter = artifacts.require("Splitter");

//Checks to ensure half was sent to the bob address
contract('Splitter', (accounts) => {
      it('should have a balance of 50 for bob', async () => {
       
        const splitterInstance = await Splitter.deployed();
        const valueSent = 100;

        await splitterInstance.splitEther({ value: valueSent, from: accounts[0] });

        const finalBobBalance = await splitterInstance.balances.call(accounts[1]);
        assert.strictEqual(finalBobBalance.toString(10), "50", "Funds did not transfer correctly");

    });
      it('should have a balance of 50 for carol', async () => {
        const splitterInstance = await Splitter.deployed();

        const finalCarolBalance = await splitterInstance.balances.call(accounts[1]);
        assert.strictEqual(finalCarolBalance.toString(10), "50", "Funds did not transfer correctly");

    });
});


