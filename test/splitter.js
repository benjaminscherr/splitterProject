const Splitter = artifacts.require("Splitter");

//Checks to ensure half was sent to the bob address
contract('Splitter', (accounts) => {
      it('should split the ether sent to it', async () => {
        const splitterInstance = await Splitter.deployed();
        
        
        const initialBobBalance = await splitterInstance.getIndividalBalance.call(accounts[1]);
        const valueSent = 100;
        const expectedBobBalance = (BigInt(initialBobBalance) + BigInt(50)).toString(10);

     

      
        return splitterInstance.splitEther({ value: valueSent, from: accounts[0] })
            .then(async () => {
                const finalBobBalance = await splitterInstance.getIndividalBalance.call(accounts[1]);
                const finalCarolBalance = await splitterInstance.getIndividalBalance.call(accounts[2])
                assert.equal(finalBobBalance.toString(10), expectedBobBalance,"Funds did not transfer correctly");
               
            });
    
    
    });
});


