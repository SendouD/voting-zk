set -e

rm -rf target
echo "Compiling circuit..."
if ! nargo compile; then
  echo "Compilation failed. Exiting..."
  exit 1
fi

echo "Gate count:"
bb gates -b target/zkp.json | jq '.functions[0].circuit_size'

echo "Generating vkey..."
bb write_vk_ultra_keccak_honk -b ./target/zkp.json -o ./target/vk -c ~/.bb-crs -v

echo "Generating solidity verifier..."
bb contract_ultra_honk -k ./target/vk -c ~/.bb-crs -o ./target/Verifier.sol -v

echo "Generating proof..."
nargo execute
bb prove_ultra_keccak_honk -b ./target/zkp.json -w ./target/zkp.gz -o ./target/proof -c ~/.bb-crs -v
bb proof_as_fields_honk -k ./target/vk -p ./target/proof -c ~/.bb-crs -v

echo "Verifying proof..."
bb verify_ultra_keccak_honk -k ./target/vk -p ./target/proof -b ./target/zkp.json -c ~/.bb-crs -v

echo "Done"
