#!/usr/bin/env bash
SRC=~/src

MSG="\n\
1. Booting instant-dapp-ide instance...\n\
- SSH on port 2222\n\
- Dapp served on port 8080\n\
- Cloud9 IDE served on port 8181\n\
- IPFS console at http://localhost:5001/webui\n\
- Ethereum RPC served on port 8545\n"
echo -e $MSG
docker run -v ${SRC}:/src -i --publish-all=true -p 445:445 -p 3000:3000 -p 4001:4001 -p 5001:5001 -p 2222:2222 -p 8000:8000 -p 8080:8080 -p 8181:8181 -p 8545:8545 -t countzen/blackops:latest
