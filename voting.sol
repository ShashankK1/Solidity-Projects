// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.9.0;

contract Voting{

    struct Voter{
        bool voted;
        uint weight;
        uint vote;
    }

    struct Proposal{
        bytes32 name;
        uint voteCount;
    }

    Proposal[] public proposals;
    mapping(address => Voter) public voters;

    address public manager;

    constructor(bytes32[] memory proposalNames){
        
        manager = msg.sender;
        voters[manager].weight = 1;
        for(uint i=0; i<proposalNames.length;i++){
            proposals.push(
                Proposal({
                    name: proposalNames[i],
                    voteCount: 0
                })
            );
        }
    }

    function giveRightToVote(address voter) public {
        require(msg.sender == manager);
        require(!voters[voter].voted);
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0);
        require(!sender.voted);
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount = proposals[proposal].voteCount + sender.weight;
    }

    function winningProposal() public view returns (uint winningProposal_){
        uint winningVoteCount = 0;
        for(uint i=0; i<proposals.length; i++){
            if(proposals[i].voteCount > winningVoteCount){
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }
    }

    function winningName() public view returns (bytes32 winningName_){
        winningName_ = proposals[winningProposal()].name;
    }

}