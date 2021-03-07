pragma solidity >=0.4.22 <0.9.0;

contract Splitter {
    
    
    
    // 1)  there are 3 people: Alice, Bob and Carol.
    // 2)  we can see the balance of the Splitter contract on the Web page.
    // 3)  whenever Alice sends ether to the contract for it to be split, half of it goes to Bob and the other half to Carol.
    // 4)  we can see the balances of Alice, Bob and Carol on the Web page.
    // 5)  Alice can use the Web page to split her ether.
    
    //Owner represents the original deployer of the contract
    address payable owner;
    address public aliceAddress;
    address payable public bobAddress;
    address payable public carolAddress;
    bool reEntrancyMutex = false;
    uint amountSent;

    //mapping declaration
    mapping (address => uint) public balances;
    
    
    //event declarations
    event ContractDeployed(address _splitterAddress);
    event FundsSplit(uint _totalSent, uint _splitAmount);
    event FundsWithdrawn(uint _totalSent, address _address);
    
    //This constructor will set their addresses upon contract creation only
    constructor(address payable _aliceAddress, address payable _bobAddress, address payable _carolAddress) public{
        owner = msg.sender;
        aliceAddress = _aliceAddress;
        bobAddress = _bobAddress;
        carolAddress = _carolAddress;
        emit ContractDeployed(address(this));
    }
    
    

    function getIndividalBalance(address _user) public view returns(uint) {
        return address(_user).balance;
    }
    
    //Only Alice is allowed to split her ether
    //Below is the function to split ether from alice to carol and bob
    function splitEther() public payable {

        require(msg.sender == aliceAddress, "You are not Alice!");
        require(msg.value % 2 == 0, "This contract requires even amounts of ether to be split");

        balances[bobAddress] = (msg.value / 2);
        balances[carolAddress] = (msg.value / 2);

        emit FundsSplit(msg.value, msg.value/2);
    }
    
    function withdrawEther(uint amount) public {
        
        require(!reEntrancyMutex);
        reEntrancyMutex = true;
        require(amount <= balances[msg.sender]);
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
        reEntrancyMutex = false;
        emit FundsWithdrawn(amount, msg.sender);
        
        
    }
    
    //The owner (original deployer) is entitled to any extra funds recieved by the callback
    
    function () external payable {
        balances[owner] = msg.value;
    }
}
