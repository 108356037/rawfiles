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

# cat <<EOF | ./bin/shamir combine
#  07cfbaa1bf6982413dd52abb2578ca6373
#  c9cc6036850debccca9dd598bebf27acd1
#  EOF


# a=./go-shamir/bin/shamir combine <<STDIN 
# ${ADDR[0]}
# ${ADDR[2]}
# ${ADDR[1]}
# STDIN

./go-shamir/bin/shamir combine <<STDIN
${ADDR[0]}
${ADDR[1]}
${ADDR[1]}
STDIN