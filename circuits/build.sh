#!/bin/bash
rm -rf target

echo "compiling..."
nargo compile




echo "writing verification key..."
bb write_vk_ultra_keccak_honk -b ./target/with_foundry.json
bb contract_ultra_honk


echo "Verifier contracts generated successfully."

echo "generating proofs"
nargo execute with_foundry
bb prove_ultra_keccak_honk -b ./target/with_foundry.json -w ./target/with_foundry.gz -o ./target/proof

echo "proof generated successfully."
