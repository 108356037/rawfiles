#!/bin/bash
export PATH=$PATH:/usr/local/go/bin:$HOME/tink/tools/bazel-bin/tinkey
cd $HOME

# create a AES256_GCM key using tink
tinkey create-keyset \
       --out test_use_service_key \
       --out-format binary \
       --key-template AES256_GCM_RAW

echo "Generated AES256_GCM key at ${pwd}/test_use_service_key"

# encrypt key with openssl and public key from GCP
openssl pkeyutl \
        -encrypt \
        -in ./test_use_service_key \
        -pubin -inkey ./rawfiles/test-use-pubkey.pub \
        -pkeyopt rsa_padding_mode:oaep \
        -pkeyopt rsa_oaep_md:sha256 \
        -pkeyopt rsa_mgf1_md:sha256 \
        -out ./encrypted_test_use_service_key

echo "Generated AES256_GCM key at ${pwd}/test_use_service_key"