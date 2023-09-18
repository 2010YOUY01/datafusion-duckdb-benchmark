#!/bin/bash
set -e

rm -rf G1_1e7_1e2_5_0.csv*

echo "Downloading h2o.csv"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    wget https://github.com/duckdb/duckdb-data/releases/download/v1.0/G1_1e7_1e2_5_0.csv.gz
elif [[ "$OSTYPE" == "darwin"* ]]; then
    curl -LO https://github.com/duckdb/duckdb-data/releases/download/v1.0/G1_1e7_1e2_5_0.csv.gz
else
    echo "Unsupported OS"
    exit 1
fi

gunzip G1_1e7_1e2_5_0.csv.gz

echo "duckdb: h2o.csv -> h2o.parquet"
python3 -m venv `pwd`/venv
source venv/bin/activate
pip install duckdb==0.8.1 psutil

# clean out old database
rm -f *.duckdb*

commands=(
    "create table h2o as from 'G1_1e7_1e2_5_0.csv'"
    "COPY h2o TO 'h2o.parquet' (FORMAT PARQUET);"
)

for cmd in "${commands[@]}"; do
    echo "$cmd" | ../common/create-view-duckdb.py
done
