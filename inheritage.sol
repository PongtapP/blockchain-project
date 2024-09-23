// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract inheritage {
    address owner;
    Successor[] successor;
    uint lastAlive;
    uint constant aliveInterval = 365 days; //  1 minutes; 30 seconds;

    constructor(){
        owner = msg.sender;
        lastAlive = block.timestamp;
    }

    //1. Put money into the pool
    function putmoney() payable public {
    }

    //2. View pool balance
    function viewbalance() public view returns(uint){
        return address(this).balance;
    }

    //3. Add/remove person
    struct Successor{
        address payable walletAddress;
        string name;
        uint percentage;
    }

    function addSuccessor(address payable walletAddress, string memory name, uint percentage) public {
        require(msg.sender == owner, "Only the owner can call this function.");
        require(percentage > 0 && percentage <= 100, "Percentage must be between 1 and 100.");
        require(getTotalPercentage() + percentage <= 100, "Total percentage exceeds 100%.");

        bool successorExist = false;
        for(uint i = 0; i < successor.length; i++){
            if(successor[i].walletAddress == walletAddress){
                successorExist = true;
                break;
            }
        }

        if(!successorExist){
            successor.push(Successor(walletAddress, name, percentage));        
        }
    }

    function removeSuccessor(address payable walletAddress) public{
        require(msg.sender == owner, "Only the owner can call this function.");

        for(uint i = 0; i < successor.length; i++){
            if(successor[i].walletAddress == walletAddress){
                for(uint j = i; j < successor.length - 1; j++){
                    successor[j] = successor[j + 1];
                }
                successor.pop();
                break;
            }
        }
    }

    //4. View successors
    function viewSuccessor() public view returns(Successor[] memory) {
        return successor;
    }

    //5. Distribute   
    function distributeInheritage() public {
        require(msg.sender == owner, "Only the owner can call this function.");
        require(address(this).balance > 0, "Insufficient balance in the contract.");

        uint totalBalance = address(this).balance;

        for(uint i = 0; i < successor.length; i++){
            uint amount = (totalBalance * successor[i].percentage) / 100;
            transfer(successor[i].walletAddress, amount);
        }
    }

    function transfer(address payable walletAddress, uint amount) internal {
        walletAddress.transfer(amount);
    }

    function getTotalPercentage() internal view returns(uint) {
        uint totalPercentage = 0;
        for(uint i = 0; i < successor.length; i++){
            totalPercentage += successor[i].percentage;
        }
        return totalPercentage;
    }

    //6.keep alive
    function keepAlive() public {
        require(msg.sender == owner, "Only the owner can call this function.");

        lastAlive = block.timestamp;
    }

    // No Alive Distribute
    function noAliveDistribute() public {
        require(block.timestamp > lastAlive + aliveInterval, "The owner is still alive.");
        require(address(this).balance > 0, "Insufficient balance in the contract.");
        
        uint totalBalance = address(this).balance;

        for(uint i = 0; i < successor.length; i++){
            uint amount = (totalBalance * successor[i].percentage) / 100;
            transfer(successor[i].walletAddress, amount);
        }
    }
}