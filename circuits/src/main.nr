use dep::std;

fn main(root: pub Field, secret: Field, index: Field, hash_path: [Field; 2]) {
    let commit_from_secret = std::hash::pedersen_hash([secret]);
    let check_root = std::merkle::compute_merkle_root(commit_from_secret, index, hash_path);
    assert(root == check_root, "Secret does not match commitment");
}

#[test]
fn test_main() {
    let c0 = std::hash::pedersen_hash([1]);
    let c1 = std::hash::pedersen_hash([2]);
    let c2 = std::hash::pedersen_hash([3]);
    let c3 = std::hash::pedersen_hash([4]);

    let left = std::hash::pedersen_hash([c0, c1]);
    let right = std::hash::pedersen_hash([c2, c3]);
    let merkle = std::hash::pedersen_hash([left, right]);
    std::println(merkle);
    std::println(c1);
    std::println(right);
    main(merkle, 1, 0, [c1, right]);
}
