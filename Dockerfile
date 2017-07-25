# This installs
# Soidity
# truffle
# embark
# webpack
# testrpc
# IPFS
# tmux
# GO
# geth
# Cloud 9 IDE
# Special VIM for development

FROM ubuntu
MAINTAINER BillyShin

ENV DEBIAN_FRONTEND noninteractive

# Good Housekeepig
RUN apt-get update
RUN apt-get upgrade -q -y
RUN apt-get dist-upgrade -q -y

# Getting Bunch of requirments and cleanup
# Individual lines to support caching.
RUN apt-get -y update && apt-get install -y software-properties-common
RUN apt-get install -y -q apt-utils
RUN apt-get install -y -q sudo
RUN apt-get install -y -q git-all
RUN apt-get install -y -q wget
RUN apt-get install -y -q curl
RUN apt-get install -y -q python3.4
RUN apt-get install -y -q python3-pip
RUN apt-get install -y -q rsync
RUN apt-get install -y -q libssl-dev
RUN apt-get install -y -q python-dev
RUN apt-get install -y -q ca-certificates
RUN apt-get install -y -q apt-transport-https
RUN apt-get install -y -q build-essential libssl-dev
RUN apt-get install -y -q build-essential golang
RUN apt-get install -y -q build-essential g++
RUN apt-get install -y -q figlet
RUN apt-get install -y -q strace
RUN apt-get install -y -q vim
RUN apt-get install -y -q rake
RUN apt-get install -y -q zip
RUN apt-get install -y -q unzip
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*

# Install Node support
RUN curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
RUN apt-get install -y nodejs

# User addition, Not sure we need this, but might be essential in the future
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# This is copied from Cloud9 Docker (https://github.com/dominicwilliams/instant-dapp-ide/blob/master/Dockerfile)
# Install tmux to gain split screen management and screen sharing capabilities
RUN apt-get install -y tmux

# Add TypeScrupt support too
RUN echo "Plug 'leafgarland/typescript-vim'" >> /root/.vimrc.bundles.local
WORKDIR /root/.vim/plugged
RUN git clone https://github.com/leafgarland/typescript-vim.git typescript-vim

# Pimp VIM with Nerd Tree and other goodies using the Braintree setup
# WORKDIR /root
# RUN git clone https://github.com/braintreeps/vim_dotfiles.git
# WORKDIR /root/vim_dotfiles
# RUN ./activate.sh

# Add an SSH server for social hacking i.e. pair/multi programming and configure run on port 2222
RUN apt-get install -y openssh-server
RUN sed -i '/Port 22/c\Port 2222' /etc/ssh/sshd_config
RUN sed -i '/LogLevel INFO/c\LogLevel VERBOSE' /etc/ssh/sshd_config
RUN sed -i '/PasswordAuthentication yes/c\PasswordAuthentication no' /etc/ssh/sshd_config
RUN mkdir /var/run/sshd
RUN mkdir /root/.ssh

# Make sure we are using
RUN echo 'set encoding=utf-8' >> /root/.vimrc

# Configure VIM with support for Solidity
WORKDIR /root
RUN curl -o vim-solidity-master.zip https://codeload.github.com/tomlion/vim-solidity/zip/master
RUN unzip vim-solidity-master.zip
RUN rsync -a vim-solidity-master/ .vim/
RUN rm -rf vim-solidity-master

# Add Cloud9 for IDE, in addition to tmux
WORKDIR /opt
RUN git clone git://github.com/c9/core.git cloud9
WORKDIR /opt/cloud9
RUN scripts/install-sdk.sh
# patch for solidty syntax
ADD patches/c9/node_modules/ace/lib/ace/ext/modelist.js /opt/cloud9/node_modules/ace/lib/ace/ext/modelist.js
ADD patches/c9/node_modules/ace/lib/ace/mode/solidity.js /opt/cloud9/node_modules/ace/lib/ace/mode/solidity.js
ADD patches/c9/node_modules/ace/lib/ace/mode/solidity_highlight_rules.js /opt/cloud9/node_modules/ace/lib/ace/mode/solidity_highlight_rules.js
ADD patches/c9/node_modules/ace/lib/ace/snippets/solidity.js /opt/cloud9/node_modules/ace/lib/ace/snippets/solidity.js

RUN mkdir /opt/cloud9/workspace
WORKDIR /opt/cloud9/workspace
RUN ln -s /src src
RUN echo 'cd /opt/cloud9;node server.js --collab -p 8181  --listen 0.0.0.0 -a : -w /opt/cloud9/workspace' > /usr/local/bin/c9.sh
RUN chmod ugo+x /usr/local/bin/c9.sh

# GO
ENV GOVERSION 1.8.1
ENV GOROOT /opt/go
ENV GOPATH /root/.go
RUN cd /opt && wget https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz && \
    tar zxf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz && \
    sudo rm -rf /usr/bin/go && ln -s /opt/go/bin/go /usr/bin/ && \
    mkdir $GOPATH

# Installing GETH from source
RUN git clone https://github.com/ethereum/go-ethereum
WORKDIR go-ethereum
RUN go version
RUN make geth

# Install webpack, This make a global webpack, which might not be the best practice. Up for discussion.
RUN npm install --global webpack

# Install Embark
RUN npm install -g embark

# Install IPFS and start the daemon
RUN mkdir /ipfs
WORKDIR ipfs
RUN curl -o go-ipfs.tar.gz https://dist.ipfs.io/go-ipfs/v0.4.9/go-ipfs_v0.4.9_linux-amd64.tar.gz
RUN tar xvfz go-ipfs.tar.gz
RUN mv go-ipfs/ipfs /usr/local/bin/ipfs

# ethereumjs-testrpc
# solc
RUN npm install -g ethereumjs-testrpc
RUN npm install -g solc

# This is all for truffle
RUN sudo npm config set unsafe-perm=true
RUN sudo npm install -g solidity-sha3 --allow-root
RUN npm install -g truffle

# Adding React for ya all.
RUN npm install -g create-react-app

#Incase you run this and connect from outside.
EXPOSE 445
EXPOSE 2222
EXPOSE 3000
EXPOSE 4001
EXPOSE 4002/udp
EXPOSE 5001
EXPOSE 8000
EXPOSE 8181
EXPOSE 8080
EXPOSE 8545

# Clean up apt when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# On entry, start sshd, start testrpc, start IPFS, start Cloud9, and run bash
ENTRYPOINT service ssh start && ipfs init && ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001 && ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080 && ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]' && ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "GET", "POST", "OPTIONS"]' && ipfs config --json API.HTTPHeaders.Access-Control-Allow-Credentials '["true"]' && tmux new -s pair 'testrpc -d 0.0.0.0 --gasLimit 1111115141592 -b 1' \; new-window 'c9.sh' \; new-window 'ipfs daemon' \; new-window

# Start user in their source code directory...
WORKDIR /src
