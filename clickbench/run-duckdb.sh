#!/bin/bash

# create file
CREATE=${CREATE:-create-single-duckdb.sql}
TRIES=5
QUERY_NUM=1
sweep_cores=$1
echo "Using $CREATE, appending results to clickbench_duckdb.csv"

python3 -m venv `pwd`/venv
source venv/bin/activate
pip install duckdb==0.8.1 psutil

# clean out old database
rm -f my-db.duckdb*

cat ${CREATE} | ../common/create-view-duckdb.py

cat queries-duckdb.sql | while read query; do
    sync
    echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null
    sync

    echo "qnum: $QUERY_NUM"
    ../common/run-query-duckdb.py $QUERY_NUM $sweep_cores clickbench_duckdb.csv <<< "${query}" | tee /tmp/duckdb.log

    QUERY_NUM=$((QUERY_NUM + 1))
done
