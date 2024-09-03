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
    }

    function addSuccessor(address payable walletAddress,string memory name) public {
        require(msg.sender == owner, "Only the onwer can call this function.");
        bool successorExist = false;
        if(successor.length >=1){
            for(uint i=0; i<successor.length; i++){
                if(successor[i].walletAddress == walletAddress){
                    successorExist = true;
                }
            }
        }
        if(successorExist==false){
            successor.push(Successor(walletAddress,name));        
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

    //5.distribute inheritage
    function distrubiteInheritage() public {
        require(address(this).balance > 0, "Insufficient balance in the contract.");
        if(successor.length>=1){
            uint amount = address(this).balance / successor.length;
            for(uint i=0; i<successor.length; i++){
                transfer(successor[i].walletAddress,amount);
            }
        }
    }

    function transfer(address payable walletAddress, uint amount) internal {
        walletAddress.transfer(amount);
    }

    //6.keep alive
}