pragma solidity ^0.8.17;

import {HonkVerifier} from "../circuits/target/contract.sol";

contract Voting {
    uint256 proposalCount;
    HonkVerifier public verifier;
    bytes32 public root;
    mapping (uint256 => Proposal) public proposals;
    constructor(bytes32 _root, HonkVerifier _verifier) {
        proposalCount = 0;
        verifier = _verifier;
        root = _root;
    } 
    struct Proposal {
        string description;
        uint256 deadline;
        uint256 forVote;
        uint256 againstVote;
    }
    function propose(
        string memory description,
        uint256 deadline
    )public returns(uint){
        proposals[proposalCount] = Proposal(
            description,
            deadline,
            0,
            0
        );
        proposalCount++;
        return proposalCount-1;
    }
    function castVote( bytes memory proof,uint256 proposalId,uint256 vote, bytes32[] memory publicInputs) public {

        require(verifier.verify(proof,publicInputs),"Invalid proof");
        if(vote==1){
            proposals[proposalId].forVote++;
        }else{
            proposals[proposalId].againstVote++;
        }
        

        
    }
}
