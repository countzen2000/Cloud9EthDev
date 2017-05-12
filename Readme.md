Ethereum Dev Container!
=======================

IMPORTANT:
==========
Make sure to serve all things to port 
```
0.0.0.0
```

Just a limitation of docker.

(i.e. ```embark run -b 0.0.0.0```)

Quickstart:
===========
* Run the image as described below
* go to [http://localhost:8181](http://localhost:8181) for Cloud 9
* go to [http://localhost:5001/webui](http://localhost:5001/webui)

Run the image:
==============
Just run this in the terminal 
```
./scripts/launch.sh
```

Build the Image:
================
Just run this in the terminal 
```
./scripts/build-image.sh
```

Separate commands
=================
If you want to run them separately, perhaps in your cloud 9 terminal windows:
```
docker run -v ${SRC}:/src -i --publish-all=true -p 445:445 -p 3000:3000 -p 4001:4001 -p 5001:5001 -p 2222:2222 -p 8000:8000 -p 8080:8080 -p 8181:8181 -p 8545:8545 -t countzen/blackops:latest
service ssh start
ipfs init
ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001
ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "GET", "POST", "OPTIONS"]'
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Credentials '["true"]'
ipfs daemon
testrpc -d 0.0.0.0 --gasLimit 1111115141592 -b 1
```

TMUX:
=====
The output is going to your terminal using TMUX. You can switch the 'virtual windows' by:
`ctrl+b` followed `n`.

IPFS, Cloud9, test-rpc and your basic bash is all on its own window.

Here's a [cheat sheet](https://tmuxcheatsheet.com/).

Volumes:
========
I set it up so that it connects to a local mounted folder, in this case the `/src` folder on your ROOT directory. 

Pushing Image:
==============
To update image on dockerhub:
```
docker push countzen/blackops
```

GOTCHAs
=======
- Check your VPN if you are having issues connecting to the outside word from any service.

Defaults:
========
Stuff that's avalible:
* Truffle
* Solc
* Embark
* IPFS (running on launch)
* TestRPC (running on launch)
* geth
* node
* npm
* Cloud9
* tmux
* webpack


By default test-rpc is running in the background to test against Embark or Truffle.
