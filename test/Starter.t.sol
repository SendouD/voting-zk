pragma solidity ^0.8.17;
import "../contract/Starter.sol";
import "../circuits/target/contract.sol";
import "forge-std/console.sol";

import "forge-std/Test.sol";
import {NoirHelper} from "../lib/foundry-noir-helper/src/NoirHelper.sol";



contract StarterTest is Test {
    Voting public voteContract;
    HonkVerifier public verifier;

    NoirHelper public noirHelper;
    uint deadline=block.timestamp+10000000;
    bytes32 root=bytes32(0x215597bacd9c7e977dfc170f320074155de974be494579d2586e5b268fa3b629);
    uint proposalId;






    function setUp() public {
        verifier= new HonkVerifier();
        noirHelper = new NoirHelper();
        voteContract = new Voting(root,verifier);
        proposalId=voteContract.propose("I love ZKP",deadline);
    }

    function testValidVote() public {
         bytes32[] memory hash_path = new bytes32[](2);
        hash_path[0] = bytes32(0x1efa9d6bb4dfdf86063cc77efdec90eb9262079230f1898049efad264835b6c8);
        hash_path[1] = bytes32(0x2a653551d87767c545a2a11b29f0581a392b4e177a87c8e3eb425c51a26a8c77);
        noirHelper.withInput("index", uint256(0)).withInput("secret",uint256(1)).withInput("hash_path",hash_path ).withInput("root",root);
        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof("test_verifyProof", 1);

        voteContract.castVote(proof,proposalId,1,publicInputs);
    }
}