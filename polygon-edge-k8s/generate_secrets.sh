#!/bin/bash

set -x
get_public_addr_from_file() {
  input=$1
  publicAddr=""
  while IFS='=' read -ra line; do
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
  while IFS='=' read -ra line; do
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

data_dir1="/usr/share/polygon-edge/data-dirs/data-dir1"
data_dir2="/usr/share/polygon-edge/data-dirs/data-dir2"
data_dir3="/usr/share/polygon-edge/data-dirs/data-dir3"
data_dir4="/usr/share/polygon-edge/data-dirs/data-dir4"

rm -rf /usr/share/polygon-edge/data-dirs/genesis.json
rm -rf $data_dir1
rm -rf $data_dir2
rm -rf $data_dir3
rm -rf $data_dir4

mkdir $data_dir1
mkdir $data_dir2
mkdir $data_dir3
mkdir $data_dir4

polygon-edge secrets init --data-dir $data_dir1 > $data_dir1/nodeId.txt
polygon-edge secrets init --data-dir $data_dir2 > $data_dir2/nodeId.txt
polygon-edge secrets init --data-dir $data_dir3 > $data_dir3/nodeId.txt
polygon-edge secrets init --data-dir $data_dir4 > $data_dir4/nodeId.txt


addr1=$(get_public_addr_from_file $data_dir1/nodeId.txt)
nodeId1=$(get_node_id_from_file $data_dir1/nodeId.txt)

addr2=$(get_public_addr_from_file $data_dir2/nodeId.txt)
nodeId2=$(get_node_id_from_file $data_dir2/nodeId.txt)


addr3=$(get_public_addr_from_file $data_dir3/nodeId.txt)
nodeId3=$(get_node_id_from_file $data_dir3/nodeId.txt)

addr4=$(get_public_addr_from_file $data_dir4/nodeId.txt)
nodeId4=$(get_node_id_from_file $data_dir4/nodeId.txt)

bootNode1=/ip4/$MY_POD_IP/tcp/1478/p2p/$nodeId1
bootNode2=/ip4/$MY_POD_IP/tcp/1478/p2p/$nodeId2


cd /usr/share/polygon-edge/data-dirs/

polygon-edge genesis --consensus ibft --ibft-validator=$addr1 --ibft-validator=$addr2 --ibft-validator=$addr3 --ibft-validator=$addr4 --bootnode=$bootNode1 --bootnode=$bootNode2