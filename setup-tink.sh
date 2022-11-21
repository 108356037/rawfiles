#!/bin/bash

# install bazel and java-sdk to install tink
sudo apt-get update
sudo apt install -y apt-transport-https curl gnupg
curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg
sudo mv bazel-archive-keyring.gpg /usr/share/keyrings
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
sudo apt update && \
sudo apt install -y bazel && \
sudo apt install -y bazel-5.1.1

# install tink
sudo apt install -y default-jdk
git clone https://github.com/google/tink.git
cd tink/tools
bazel build tinkey
export PATH=$PATH:$HOME/tink/tools/bazel-bin/tinkey

cd $HOME

# create a AES256_GCM key using tink
tinkey create-keyset \
       --out test_use_service_key \
       --out-format binary \
       --key-template AES256_GCM_RAW

# encrypt key with openssl and public key from GCP
openssl pkeyutl \
        -encrypt \
        -in ./test_use_service_key \
        -pubin -inkey ./rawfiles/test-use-pubkey.pub \
        -pkeyopt rsa_padding_mode:oaep \
        -pkeyopt rsa_oaep_md:sha256 \
        -pkeyopt rsa_mgf1_md:sha256 \
        -out ./encrypted_test_use_service_key