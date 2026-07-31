#!/usr/bin/env bash
# bench/bench_mysql.sh
# Simple bash wrapper to run EXPLAIN ANALYZE and timed queries using the mysql client.

set -euo pipefail

HOST=${MYSQL_HOST:-127.0.0.1}
PORT=${MYSQL_PORT:-3306}
USER=${MYSQL_USER:-root}
PASSWORD=${MYSQL_PASSWORD:-}
DATABASE=${MYSQL_DATABASE:-sales_savvy_bench}
ITERATIONS=${BENCH_ITERATIONS:-20}
USER_ID=${BENCH_USER_ID:-42}

export MYSQL_PWD="$PASSWORD"

QUERY="SELECT COUNT(*) as cnt FROM tasks WHERE user_id = ${USER_ID} AND status = 'todo';"

echo "Running EXPLAIN ANALYZE"
mysql -h "$HOST" -P "$PORT" -u "$USER" -D "$DATABASE" -e "EXPLAIN ANALYZE $QUERY"

echo "Running $ITERATIONS timed iterations (client-side timing)"
for i in $(seq 1 $ITERATIONS); do
  START=$(date +%s%3N)
  mysql -h "$HOST" -P "$PORT" -u "$USER" -D "$DATABASE" -e "$QUERY" >/dev/null
  END=$(date +%s%3N)
  echo $((END-START))
done
