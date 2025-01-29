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
bb write_vk -b ./target/zkp.json
bb contract

echo "Generating proof..."
nargo execute zkp
bb prove -b ./target/zkp.json -w ./target/zkp.gz -o ./target/proof

echo "Verifying proof..."
bb verify -k ./target/vk -p ./target/proof


echo "Done"