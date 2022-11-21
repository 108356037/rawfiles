#!/bin/bash

# install bazel
sudo apt-get update
sudo apt install -y apt-transport-https curl gnupg make
# curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg
# sudo mv bazel-archive-keyring.gpg /usr/share/keyrings
# echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
# sudo apt update && \
# sudo apt install -y bazel && \
# sudo apt install -y bazel-5.1.1

# # install java sdk
# sudo apt install -y default-jdk

# # build tink from source
# git clone https://github.com/google/tink.git
# cd $HOME/tink/tools
# bazel build tinkey
#export PATH=$PATH:$HOME/tink/tools/bazel-bin/tinkey

cd $HOME

# install golang for go-shamir
go1_19_3_checksum=74b9640724fd4e6bb0ed2a1bc44ae813a03f1e72a4c76253e2d5c015494430ba
wget https://go.dev/dl/go1.19.3.linux-amd64.tar.gz

echo "$go1_19_3_checksum go1.19.3.linux-amd64.tar.gz" | sha256sum --check
if [[ "${?}" -ne 0 ]]
then
  echo "Downloaded golang doesn't match checksum!"
  exit 1
fi

sudo tar -xzf go1.19.3.linux-amd64.tar.gz -C /usr/local/
if [[ "${?}" -ne 0 ]]
then
  echo "Cannot extract compressed golang to /usr/local!"
  exit 1
else
  echo "Successfully installed golang to /usr/local !"
fi


# build go-shamir
export PATH=$PATH:/usr/local/go/bin
git clone https://github.com/108356037/go-shamir.git
make all -C $HOME/go-shamir

if [[ "${?}" -ne 0 ]]
then
  echo "Error building go-shamir!"
  exit 1
else
  echo "Successfully built go-shamir exec at $HOME/go-shamir/bin/shamir!"
fi