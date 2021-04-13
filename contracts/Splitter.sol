pragma solidity >=0.4.22 <0.9.0;

import './SafeMath.sol';

//Updated
contract Splitter {
    
    // 1)  there are 3 people: Alice, Bob and Carol.
    // 2)  we can see the balance of the Splitter contract on the Web page.
    // 3)  whenever Alice sends ether to the contract for it to be split, half of it goes to Bob and the other half to Carol.
    // 4)  we can see the balances of Alice, Bob and Carol on the Web page.
    // 5)  Alice can use the Web page to split her ether.
    
    //Owner represents the original deployer of the contract
    address public owner;

    //mapping declaration
    mapping (address => uint) public balances;
    
    //SafeMath
    using SafeMath for uint;
    
    
    //event declarations
    event ContractDeployed(address _splitterAddress);
    event FundsSplit(address indexed _aliceAddress, address indexed _bobAddress, address indexed _carolAddress, uint _totalSent, uint _amountSent);
    event FundsWithdrawn(uint _amountWithdrawn, address _reciever);
    
    //This constructor will set their addresses upon contract creation only
    constructor() public {
        owner = msg.sender;
        emit ContractDeployed(address(this));
    }
    
    //Only Alice is allowed to split her ether
    //Below is the function to split ether from alice to carol and bob
    function splitEther(address _bobAddress, address _carolAddress) public payable {

        
        require(_bobAddress != address(0), "Error, the zero address was used");
        require(_carolAddress != address(0), "Error, the zero address was used");

        //If an odd amount is entered the owner gets the extra wei. This ensures when msg.value is divided by 2 nothing is lost
        if (msg.value % 2 != 0) {
            balances[owner] = balances[owner].add(1);
        } 

        balances[_bobAddress] =  balances[_bobAddress].add(msg.value / 2);
        balances[_carolAddress] = balances[_carolAddress].add(msg.value / 2);

        emit FundsSplit(msg.sender, _bobAddress, _carolAddress, msg.value, msg.value/2);
    }
    
    function withdrawEther(uint amount) public {
        uint balance = balances[msg.sender];
        require(amount <= balance);
        balances[msg.sender] = balance.sub(amount);
        (bool success,) = msg.sender.call.value(amount)("");
        require(success, "Send Failed");
        emit FundsWithdrawn(amount, msg.sender);
    }
    
}
