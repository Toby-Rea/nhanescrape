#!/bin/bash

# Start the first process
/bin/bash scripts/available_datasets.sh &&
/bin/bash scripts/attributes.sh &

# Wait for any process to exit
wait -n
