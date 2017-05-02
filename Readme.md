Ethereum Dev Container!
=======================

Quickstart:
===========
* Run the image as described below
* go to [http://localhost:8181](http://localhost:8181) for Cloud 9
* go to [http://localhost:5001/webui](http://localhost:8181) for IPFS

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
