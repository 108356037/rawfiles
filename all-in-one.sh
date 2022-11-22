#!/bin/bash

sudo apt-get update
sudo apt install -y apt-transport-https curl gnupg make default-jdk

cd $HOME
tinkey_1_6_1_checksum=156e902e212f55b6747a55f92da69a7e10bcbd00f8942bc1568c0e7caefff3e1
wget https://storage.googleapis.com/tinkey/tinkey-1.6.1.tar.gz
echo "$tinkey_1_6_1_checksum tinkey-1.6.1.tar.gz" | sha256sum --check

go1_19_3_checksum=74b9640724fd4e6bb0ed2a1bc44ae813a03f1e72a4c76253e2d5c015494430ba
wget https://go.dev/dl/go1.19.3.linux-amd64.tar.gz
echo "$go1_19_3_checksum go1.19.3.linux-amd64.tar.gz" | sha256sum --check

sudo tar -xzf go1.19.3.linux-amd64.tar.gz -C /usr/local/
export PATH=$PATH:/usr/local/go/bin
git clone https://github.com/108356037/go-shamir.git
make all -C $HOME/go-shamir 

git clone https://github.com/108356037/rawfiles.git

tar -xzf tinkey-1.6.1.tar.gz
$HOME/tinkey create-keyset \
       --out tss_service_key \
       --out-format binary \
       --key-template AES256_GCM_RAW


openssl pkeyutl \
        -encrypt \
        -in $HOME/tss_service_key \
        -pubin -inkey $HOME/rawfiles/test-use-pubkey.pub \
        -pkeyopt rsa_padding_mode:oaep \
        -pkeyopt rsa_oaep_md:sha256 \
        -pkeyopt rsa_mgf1_md:sha256 \
        -out $HOME/encrypted_tss_service_key

rawfiles/shamir-split.sh --sek tss_service_key