#!/bin/bash
grep -q "MASTER_BLASTER_PATH" ~/.profile

if [[ $? -ne 0 ]]; then  
    echo "export MASTER_BLASTER_PATH="$(pwd) >> ~/.profile
    source ~/.profile
    echo MASTER_BLASTER_PATH set to "$MASTER_BLASTER_PATH"
    echo To realize these changes in the current shell session, do:
    echo 'source ~/.profile'

else
    echo MASTER_BLASTER_PATH is already set to "$MASTER_BLASTER_PATH"
fi
