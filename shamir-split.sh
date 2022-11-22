#!/bin/bash
cd $HOME

# capture parameters
while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        v="${1/--/}"
        declare $v="$2"
   fi

  shift
done

# --sek must-be passed
if [[ "$sek" == "" ]]
then
  echo "Must pass in paramater --sek!"
  exit 1
fi

# split key to shares and test the shares can be combined back
# default 2-3 scheme
shares=$(cat $sek | ./go-shamir/bin/shamir  split -t 2 -p 3)
readarray -t SHARE_ARR <<< "$shares"
arraylength=${#SHARE_ARR[@]}
for ((i=0; i<${arraylength}; i++)); do              
  for ((j=${i}+1; j<${arraylength}; j++)); do         
    
    target=$(cat tss_service_key)
    echo ${SHARE_ARR[i]} > testTemp
    echo ${SHARE_ARR[j]} >> testTemp
    recontruct=$(./go-shamir/bin/shamir combine < testTemp)

    if [[ "$recontruct" != "$target" ]];
    then
      echo "The values of secret share is incorrect!"
      exit 1
    else
      echo "Can construct key with share_${i} and share_${j}!"
    fi
  done
  rm -rf testTemp
done

# store the shares
for ((i=0; i<${arraylength}; i++)); do   
  echo "Storing share to share_${i}"
  echo ${SHARE_ARR[i]} > share_${i}
  if [[ "${?}" -ne 0 ]];
  then 
    echo "Error storing share! Aborting..."
    exit 1
  fi
done