#!/bin/bash

/bin/bash scripts/available_datasets.sh &&
/bin/bash scripts/dataset_attributes.sh &

# Wait for any process to exit
wait -n
