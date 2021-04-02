const Splitter = artifacts.require("Splitter");
const truffleAssert = require('truffle-assertions');

//Checks to ensure half was sent to the bob address
contract('Splitter', (accounts) => {

    //In this case alice is the deployer
      //const deployerAddress = accounts[0];
      const aliceAddress = accounts[0];
      const bobAddress = accounts[1];
      const carolAddress = accounts[2];

      let splitterInstance;

      beforeEach("should create a new instance", async () => {
        return splitterInstance = await Splitter.new({from: aliceAddress})
        // console.log(splitterInstance);
        // return splitterInstance;
      });

      it('should have a balance of 50 for bob', async () => {
       
        const valueSent = 100;

        let result = await splitterInstance.splitEther(bobAddress, carolAddress, { value: valueSent, from: aliceAddress });

        //Check that the event was emitted with parameters, otherwise test will fail

        truffleAssert.eventEmitted(result, 'FundsSplit', {_aliceAddress: "0x16d938749466Ae97b25A34b247D5aaAa6eD9De82", _bobAddress: "0x12E9Af04c2F307dD506ab99A6E637e6FcfFe144d", _carolAddress: "0x0901530f3Ea45e728D18070B987A026A688569DD"});

        const finalBobBalance = await splitterInstance.balances.call(accounts[1]);
        assert.strictEqual(finalBobBalance.toString(10), "50", "Funds did not transfer correctly");

    });
      it('should have a balance of 50 for carol', async () => {
      
       const valueSent = 100;

       let result = await splitterInstance.splitEther(bobAddress, carolAddress, { value: valueSent, from: aliceAddress });
        
       //Check that the event was emitted with parameters, otherwise test will fail
       truffleAssert.eventEmitted(result, 'FundsSplit', {_aliceAddress: "0x16d938749466Ae97b25A34b247D5aaAa6eD9De82", _bobAddress: "0x12E9Af04c2F307dD506ab99A6E637e6FcfFe144d", _carolAddress: "0x0901530f3Ea45e728D18070B987A026A688569DD"});


        const finalCarolBalance = await splitterInstance.balances.call(accounts[2]);
        assert.strictEqual(finalCarolBalance.toString(10), "50", "Funds did not transfer correctly");

    });
      it('should be able to withdraw ether', async () => {

        const valueSent = 100;

        let carolStartingBalance = await web3.eth.getBalance(carolAddress);

        await splitterInstance.splitEther(bobAddress, carolAddress, { value: valueSent, from: aliceAddress });

        await splitterInstance.withdrawEther(50, { from: carolAddress, gasPrice: 0 });

        let carolEndingBalance = await web3.eth.getBalance(carolAddress);

        assert.strictEqual(parseInt(carolEndingBalance), parseInt(carolStartingBalance) + 50, "Funds didnt withdraw correctly");



      });

});


