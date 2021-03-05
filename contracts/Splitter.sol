pragma solidity >=0.4.22 <0.9.0;

contract Splitter {
    
    
    
    // 1)  there are 3 people: Alice, Bob and Carol.
    // 2)  we can see the balance of the Splitter contract on the Web page.
    // 3)  whenever Alice sends ether to the contract for it to be split, half of it goes to Bob and the other half to Carol.
    // 4)  we can see the balances of Alice, Bob and Carol on the Web page.
    // 5)  Alice can use the Web page to split her ether.
    
    //Owner represents the original deployer of the contract
    address owner;
    address public AliceAddress;
    address payable public BobAddress;
    address payable public CarolAddress;
    bool reEntrancyMutex = false;
    
    
    //event declarations
    event ContractDeployed(address _splitterAddress);
    event FundsSplit(uint _totalSent, uint _splitAmount);
    
    //This constructor will set their addresses upon contract creation only
    constructor(address payable _aliceAddress, address payable _bobAddress, address payable _carolAddress) public{
        owner = msg.sender;
        AliceAddress = _aliceAddress;
        BobAddress = _bobAddress;
        CarolAddress = _carolAddress;
        emit ContractDeployed(address(this));
    }
    
    
    //Function to return the balance of the splitter contract
    function getSplitterBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    //Function to return balance of Alice, Bob, and Carol on the Web page
    //This assumes the middleware would know the order of the uints returned here [Alice, Bob, Carol]
    function getParticipantBalance() public view returns(uint, uint, uint) {
        return ( address(AliceAddress).balance, address(BobAddress).balance, address(CarolAddress).balance);
    }

    function getIndividalBalance(address _user) public view returns(uint) {
        return address(_user).balance;
    }
    
    //Only Alice is allowed to split her ether
    //Below is the function to split ether from alice to carol and bob
    function splitEther() public payable {
        require(!reEntrancyMutex);
        require(msg.sender == AliceAddress, "You are not Alice!");
        require(msg.value % 2 == 0, "This contract requires even amounts of ether");
        //The reEntrancyMutex is probably overkill since using .transfer() sends limited gas, but i included just to be safe
        reEntrancyMutex = true;
        BobAddress.transfer(msg.value / 2);
        CarolAddress.transfer(msg.value / 2);
        reEntrancyMutex = false;
        emit FundsSplit(msg.value, msg.value/2);
    }
    
    function recieveFunds() public payable {}
    
    function () external payable {}
}
