#!/bin/bash

set -x
get_public_addr_from_file() {
  input=$1
  publicAddr=""
  while IFS=$'\r\n=' read -ra line; do
      #echo "full array ${line[*]}"
      #echo "1st element ${line[0]}"
      #echo "2th element ${line[1]}"
      #echo "array length ${line[*]}"
    if [[ "${line[0]}" == Public* ]]; then
      publicAddr="${line[1]}"
    fi
    # for i in "${ADDR[@]}"; do
    #  echo $i
    # done
  done < "$input"
  echo $publicAddr
}

get_node_id_from_file() {
  input=$1
  nodeId=""
  while IFS=$'\r\n=' read -ra line; do
      #echo "full array ${line[*]}"
      #echo "1st element ${line[0]}"
      #echo "2th element ${line[1]}"
      #echo "array length ${line[*]}"
    if [[ "${line[0]}" == Node* ]]; then
      nodeId="${line[1]}"
    fi
    # for i in "${ADDR[@]}"; do
    #  echo $i
    # done
  done < "$input"
  echo $nodeId
}

START=1
END=4
 
rm -rf ./genesis.json
bootNodes=()
for (( c=$START; c<=$END; c++ ))
do
  data_dir="./test-chain-${c}"
  rm -rf $data_dir
  mkdir $data_dir
  
  docker run -v $(pwd):/workspace --workdir="/workspace" -it 0xpolygon/polygon-edge secrets init --data-dir $data_dir > $data_dir/nodeId.txt
  addr=$(get_public_addr_from_file $data_dir/nodeId.txt)
  nodeId=$(get_node_id_from_file $data_dir/nodeId.txt)
  bootNodes+=("/ip4/127.0.0.1/tcp/${c}0001/p2p/${nodeId}")
done

START=0
END=1

bootNodeString=""
for (( c=$START; c<=$END; c++ ))
do
  echo $bootNodeString
  echo $c
  string="--bootnode ${bootNodes[$c]}"
  echo $string
  bootNodeString+="${string} "
  echo $bootNodeString
done

set -x
docker run -v $(pwd):/workspace --workdir="/workspace" -it 0xpolygon/polygon-edge genesis --consensus ibft --ibft-validators-prefix-path test-chain- $bootNodeString


START=1
END=4

for (( c=$START; c<=$END; c++ ))
do
  docker run -d -p ${c}0002:${c}0002 -v $(pwd):/workspace --workdir="/workspace" -it 0xpolygon/polygon-edge server --data-dir ./test-chain-${c} --chain genesis.json --grpc :${c}0000 --libp2p :${c}0001 --jsonrpc :${c}0002 --seal
done