#!/bin/bash

# install bazel and java-sdk to install tink
sudo apt install -y apt-transport-https curl gnupg default-jdk
curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg
sudo mv bazel-archive-keyring.gpg /usr/share/keyrings
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
sudo apt update && \
sudo apt install -y bazel && \
sudo apt install -y bazel-5.1.1

# install tink
git clone https://github.com/google/tink.git
cd tink/tools
bazel build tinkey
export PATH=$PATH:$HOME/tink/tools/bazel-bin/tinkey

cd $HOME
tinkey list-key-templates
