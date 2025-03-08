#!/bin/bash
rm -rf target

echo "compiling..."
nargo compile




echo "writing verification key..."
bb write_vk_ultra_keccak_honk -b ./target/with_foundry.json
bb contract_ultra_honk


echo "Verifier contracts generated successfully."


