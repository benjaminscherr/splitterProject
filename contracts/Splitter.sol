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
    event FundsSplit(address _aliceAddress, address _bobAddress, address _carolAddress, uint _totalSent, uint _amountSent);
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

        uint256 amountToSplit = 0;
        
        //If an odd amount is entered, the owner will get the extra wei and participants will recieve an even amount
        if (msg.value % 2 != 0) {
            amountToSplit = msg.value.sub(1);
            balances[owner] = balances[owner].add(1);
        } else {
            amountToSplit = msg.value;
        }

        balances[_bobAddress] =  balances[_bobAddress].add(amountToSplit / 2);
        balances[_carolAddress] = balances[_carolAddress].add(amountToSplit / 2);

        emit FundsSplit(msg.sender, _bobAddress, _carolAddress, amountToSplit, amountToSplit/2);
    }
    
    function withdrawEther(uint amount) public {
        uint balance = balances[msg.sender];
        require(amount <= balance);
        balances[msg.sender] = balances[msg.sender].sub(amount);
        msg.sender.transfer(amount);
        emit FundsWithdrawn(amount, msg.sender);
    }
    
}
