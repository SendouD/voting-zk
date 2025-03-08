use dep::std;
fn main(root: pub Field, secret: Field, index: Field,hash_path:[Field; 2])  {
    let commit_from_secret=std::hash::pedersen_hash([secret]);
    let checkroot=std::merkle::compute_merkle_root(commit_from_secret,index,hash_path);
    assert(checkroot==root);
    
}
#[test]
fn test_main() {
    let comm_1 = std::hash::pedersen_hash([1]);
    let comm_2 = std::hash::pedersen_hash([2]);
    let comm_3 = std::hash::pedersen_hash([3]);
    let comm_4 = std::hash::pedersen_hash([4]);
    let left_branch=std::hash::pedersen_hash([comm_1,comm_2]);
    let right_branch=std::hash::pedersen_hash([comm_3,comm_4]);
    let merkle_root=std::hash::pedersen_hash([left_branch,right_branch]);
    std::println(f"root: {merkle_root}");
    std::println(f"comm_2: {comm_2}");
    std::println(f"right_branch: {right_branch}");
    //user 1
    main(merkle_root,1,0,[comm_2,right_branch]);
    //user 3
    main(merkle_root,3,2,[comm_4,left_branch]);

}   
 