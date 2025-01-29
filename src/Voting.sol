    //SPDX-License-Identifier: MIT
    pragma solidity ^0.8.18;
    import {UltraVerifier} from "../circuits/target/contract.sol";
    contract Voting {
        uint256 proposalCount;
        UltraVerifier verifier;
        bytes32 merkleRoot;
        mapping (uint256 proposalId => Proposal) public proposals;
        constructor(bytes32 _merkleRoot, address verifierAddress) {
            proposalCount = 0;
            verifier = UltraVerifier(verifierAddress);
            merkleRoot = _merkleRoot;
        }

        struct Proposal {
            string description;
            uint256 deadline;
            uint256 forVotes;
            uint256 againstVotes;
        }
        function propose(string memory description, uint256 deadline) public returns (uint256) {
            proposals[proposalCount] = Proposal(description, deadline, 0, 0);
            return proposalCount++;
        }
        function castVote(bytes calldata proof,uint256 proposalId, uint vote) public returns (bool) {
            require(vote>=0 && vote<=1, "Invalid vote"); 
            bytes32[] memory publicInputs= new bytes32[](1);
            publicInputs[0] = merkleRoot;

            require(verifier.verify(proof, publicInputs));
            if(vote==1){
                proposals[proposalId].forVotes++;
            }else{
                proposals[proposalId].againstVotes++;
            }
            return true;

            


        }
            


        
    }

