const Splitter = artifacts.require("Splitter");
const truffleAssert = require('truffle-assertions');
const BN = require('bn.js');

//Checks to ensure half was sent to the bob address
contract('Splitter', (accounts) => {

    //In this case alice is the deployer
      //const deployerAddress = accounts[0];
      const aliceAddress = accounts[0];
      const bobAddress = accounts[1];
      const carolAddress = accounts[2];

      let splitterInstance;

      beforeEach("should create a new instance", async () => {
        splitterInstance = await Splitter.new({from: aliceAddress})

      });

      it('should have a balance of 50 for bob and carol', async () => {

        const result = await splitterInstance.splitEther(bobAddress, carolAddress, { value: 100, from: aliceAddress });

        //Check that the event was emitted with parameters, otherwise test will fail


        truffleAssert.eventEmitted(result, 'FundsSplit', (ev) => {
          return (ev._aliceAddress == "0x16d938749466Ae97b25A34b247D5aaAa6eD9De82" && ev._bobAddress == "0x12E9Af04c2F307dD506ab99A6E637e6FcfFe144d" && ev._carolAddress == "0x0901530f3Ea45e728D18070B987A026A688569DD");
        });

        const finalBobBalance = await splitterInstance.balances.call(accounts[1]);
        const finalCarolBalance = await splitterInstance.balances.call(accounts[2]);

        assert.strictEqual(finalCarolBalance.toString(10), "50", "Funds did not transfer correctly");
        assert.strictEqual(finalBobBalance.toString(10), "50", "Funds did not transfer correctly");

    });

      it('should be able to withdraw ether', async () => {

    
        //let carolStartingBalance;

        await splitterInstance.splitEther(bobAddress, carolAddress, { value: 100, from: aliceAddress });

        //const carolStartingBalance = await web3.eth.getBalance(carolAddress);
        //web3.eth.getBalance(carolAddress).then(balance => {carolStartingBalance = balance.toNumber()});
        const carolStartingBalance = await web3.eth.getBalance(carolAddress);

        //execution gas cost by remix was used to simulate an accurate gas cost here
        const result = await splitterInstance.withdrawEther(50, { from: carolAddress });
        const gasUsed = new BN(result.receipt.gasUsed, 10);


        const tx = await web3.eth.getTransaction(result.tx);
        const TotalGas = new BN(tx.gasPrice, 10).mul(gasUsed)

        truffleAssert.eventEmitted(result, 'FundsWithdrawn', (ev) => {
          return (ev._amountWithdrawn == 50 && ev._receiver === "0x0901530f3Ea45e728D18070B987A026A688569DD");
        });

        //truffleAssert.eventEmitted(result, 'FundsWithdrawn', { _amountWithdrawn: 50, _receiver: "0x0901530f3Ea45e728D18070B987A026A688569DD"});

        const carolEndingBalance = await web3.eth.getBalance(carolAddress);

        //const carolStartingBalanceBN = new BN(carolStartingBalance);
        const carolEndingBalanceBN = new BN(carolEndingBalance, 10);

        const numberAdd = new BN('50', 10);
        

        const carolExpectedFinal = new BN(carolStartingBalance, 10).add(numberAdd).sub(TotalGas);

        assert.strictEqual(carolEndingBalanceBN.toString(), carolExpectedFinal.toString(), "Funds didnt withdraw correctly");



      });

});


