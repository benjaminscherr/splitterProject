const Splitter = artifacts.require("Splitter");

//Checks to ensure half was sent to the bob address
contract('Splitter', (accounts) => {

    //In this case alice is the deployer
      //const deployerAddress = accounts[0];
      const aliceAddress = accounts[0];
      const bobAddress = accounts[1];
      const carolAddress = accounts[2];

      let splitterInstance;

      beforeEach(() => {
        return Splitter.new(aliceAddress,bobAddress,carolAddress,{from: aliceAddress})
        .then((instance) => {
          splitterInstance=instance;
        });
      });

      it('should have a balance of 50 for bob', async () => {
       
        const valueSent = 100;

        await splitterInstance.splitEther({ value: valueSent, from: accounts[0] });

        const finalBobBalance = await splitterInstance.balances.call(accounts[1]);
        assert.strictEqual(finalBobBalance.toString(10), "50", "Funds did not transfer correctly");

    });
      it('should have a balance of 50 for carol', async () => {
      
       const valueSent = 100;

       await splitterInstance.splitEther({ value: valueSent, from: accounts[0] });

        const finalCarolBalance = await splitterInstance.balances.call(accounts[2]);
        assert.strictEqual(finalCarolBalance.toString(10), "50", "Funds did not transfer correctly");

    });

});


