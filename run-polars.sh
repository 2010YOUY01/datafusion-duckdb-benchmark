#!/bin/bash

# create file
CREATE=${CREATE:-create-single-duckdb.sql}
TRIES=5
QUERY_NUM=1
echo "Using $CREATE, appending results to duckdb.csv"

source venv/bin/activate

# clean out old database
rm -f my-db.duckdb*

cat ${CREATE} | ./create-view-duckdb.py

cat queries-duckdb.sql | while read query; do
    sync
    echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null
    sync

    echo "qnum: $QUERY_NUM"
    ./run-query-duckdb.py $QUERY_NUM  <<< "${query}" | tee /tmp/duckdb.log

    QUERY_NUM=$((QUERY_NUM + 1))
done