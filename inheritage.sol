// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract inheritage {
    address owner;
    Successor[] successor;

    constructor(){
        owner = msg.sender;
    }

    //1.put money in to pool
    function putmoney() payable public {

    }

    //2.view pool balance
    function viewbalance() public view returns(uint){
        return address(this).balance;
    }

    //3.add/remove person
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

    function removeWaitress(address payable walletAddress) public{
        if(successor.length>=1){
            for(uint i=0; i<successor.length; i++){
                if(successor[i].walletAddress==walletAddress){
                    for(uint j=i; j<successor.length-1; j++){
                        successor[j]=successor[j+1];
                    }
                    successor.pop();
                    break;
                }
                
            }
        }
    }

    function removeSuccessor(address payable walletAddress) public{
        if(successor.length>=1){
            for(uint i=0; i<successor.length; i++){
                if(successor[i].walletAddress==walletAddress){
                    for(uint j=i; j<successor.length-1; j++){
                        successor[j]=successor[j+1];
                    }
                    successor.pop();
                    break;
                }
                
            }
        }
    }

    //4.view person
    function viewSuccessor() public view returns(Successor[] memory) {
        return successor;
    }

    function distrubiteInheritage() public {
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

    function getTotalPercentage() public view returns(uint) {
        uint totalPercentage = 0;
        for(uint i = 0; i < successor.length; i++){
            totalPercentage += successor[i].percentage;
        }
        return totalPercentage;
    }

    //6.keep alive
    
}