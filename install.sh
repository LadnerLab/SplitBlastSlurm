#!/bin/bash
grep -q "MASTER_BLASTER_PATH" ~/.bashrc

if [[ $? -ne 0 ]]; then  
    echo "export MASTER_BLASTER_PATH="$(pwd) >> ~/.bashrc
    source ~/.bashrc

    echo MASTER_BLASTER_PATH set to "$MASTER_BLASTER_PATH"
    echo To realize these changes in the current shell session,
    echo do 'source ~/.bashrc'

else
    echo MASTER_BLASTER_PATH is already set to "$MASTER_BLASTER_PATH"
fi
