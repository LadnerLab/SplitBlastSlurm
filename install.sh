#!/bin/bash
grep -q "MASTER_BLASTER_PATH" ~/.profile

if [[ $? -ne 0 ]]; then  
    for file in $(ls ~/.*profile*); do
        echo "export MASTER_BLASTER_PATH="$(pwd) >> "$file"
        source "$file"
    done

    echo MASTER_BLASTER_PATH set to "$MASTER_BLASTER_PATH"
    echo To realize these changes in the current shell session,
    echo refresh your bash profile.

else
    echo MASTER_BLASTER_PATH is already set to "$MASTER_BLASTER_PATH"
fi
