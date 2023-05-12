// SPDX-License-Identifier: MIT
pragma solidity >=0.7 <=0.9;

contract Lottery{
    address public manager;
    address payable[] public participants;

    constructor(){
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 1 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    function selectWinner() public {
        require(msg.sender == manager);
        require(participants.length > 2);
        uint r = random();
        address payable winner;
        uint idx = r % participants.length;
        winner = participants[idx];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
}