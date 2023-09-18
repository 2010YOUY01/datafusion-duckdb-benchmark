#!/bin/bash
set -e

# 1st arg:
# default - run benchmark with number of avaialble CPU cores
# single - run with single core
# multi - scalability test
case "$1" in
    default)
        sweep_cores=$(nproc)
        ;;
    single)
        sweep_cores=1
        ;;
    multi)
        sweep_cores="multi"
        ;;
    *)
        echo "Invalid input for the first argument. Expected 'default', 'single', or 'multi'."
        exit 1
        ;;
esac


rm -rf h2o_datafusion.csv 
rm -rf h2o_duckdb.csv

bash run-duckdb.sh $sweep_cores
bash run-datafusion.sh $sweep_cores
