pragma solidity >=0.4.22 <0.9.0;

import './SafeMath.sol';

contract Splitter {
    
    // 1)  there are 3 people: Alice, Bob and Carol.
    // 2)  we can see the balance of the Splitter contract on the Web page.
    // 3)  whenever Alice sends ether to the contract for it to be split, half of it goes to Bob and the other half to Carol.
    // 4)  we can see the balances of Alice, Bob and Carol on the Web page.
    // 5)  Alice can use the Web page to split her ether.
    
    //Owner represents the original deployer of the contract
    address owner;

    //mapping declaration
    mapping (address => uint) public balances;
    
    
    //event declarations
    event ContractDeployed(address _splitterAddress);
    event FundsSplit(uint _totalSent, uint _splitAmount);
    event FundsWithdrawn(uint _totalSent, address _address);
    
    //This constructor will set their addresses upon contract creation only
    constructor() public {
        owner = msg.sender;
        emit ContractDeployed(address(this));
    }
    
    //Only Alice is allowed to split her ether
    //Below is the function to split ether from alice to carol and bob
    function splitEther(address _bobAddress, address _carolAddress) public payable {

        //Removed requirement for only alice to send, now anyone can submit to have ether split
        require(msg.value % 2 == 0, "This contract requires even amounts of ether to be split");
        
        balances[_bobAddress] = SafeMath.add(balances[_bobAddress], msg.value/2);
        balances[_carolAddress] = SafeMath.add(balances[_carolAddress], msg.value/2);

        emit FundsSplit(msg.value, msg.value/2);
    }
    
    function withdrawEther(uint amount) public {
        
        require(amount <= balances[msg.sender]);
        balances[msg.sender] = SafeMath.sub(balances[msg.sender], amount);
        msg.sender.transfer(amount);
        emit FundsWithdrawn(amount, msg.sender);
        
        
    }
    
    //The owner (original deployer) is entitled to any extra funds recieved by the callback
    
    function () external payable {
        balances[owner] = SafeMath.add(balances[owner], msg.value);
    }
}
