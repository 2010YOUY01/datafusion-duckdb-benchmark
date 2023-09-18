#!/usr/bin/env python3

## Runs stdin as a command (like create view)
import sys
import duckdb
import timeit
import psutil

con = duckdb.connect(database="my-db.duckdb", read_only=False)

query = sys.stdin.read()

print("duckdb executing: " + query[:-1])

start = timeit.default_timer()
con.execute(query)
end = timeit.default_timer()
print("finished in " + str(end - start))
