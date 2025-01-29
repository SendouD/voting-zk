//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "forge-std/Test.sol";
import "../src/Voting.sol";
import "forge-std/console.sol";


contract VotingTest is Test {
    Voting public voting;
    UltraVerifier public verifier;
    bytes proofofBytes;
    bytes32 merkleRoot;

    function setUp() public {
        merkleRoot=bytes32(0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629);
        
        verifier = new UltraVerifier();
        voting = new Voting(merkleRoot, address(verifier));
        string memory proofFilepath="./circuits/target/proof";
        console.log("Reading proof from file: ", proofFilepath);
        proofofBytes = vm.readFileBinary(proofFilepath);
        

    }
 
    function test_validVote() public {
         string memory description = "Test Proposal";
        uint256 deadline = block.timestamp + 1 days;
        uint256 proposalId = voting.propose(description, deadline);
        bool success = voting.castVote(
            proofofBytes,
            proposalId,
            1
        );
        console.log("Vote success: ", success);
        assertTrue(success, "Vote should be successful");
            }
    function test_propose() public {
        string memory description = "Test Proposal";
        uint256 deadline = block.timestamp + 1 days;
        uint256 proposalId = voting.propose(description, deadline);
        console.log("Proposal ID: ", proposalId);
        assertTrue(proposalId ==0, "Proposal should be successful");
            }
    // function testFail_Vote() public {
    //     voting.castVote(
    //         "0x123456",
    //         0,
    //         1
    //     );
    //         }
}


