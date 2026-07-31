# MySQL Benchmark README

This README explains how to run the MySQL benchmark for SalesSavvy-Backend.

Overview
- Files added:
  - sql/schema.sql — schema for users, leads, and tasks
  - sql/indexes.sql — suggested optimized indexes
  - seeds/seeds.sql — data seeding (configurable row count)
  - bench/bench_node.js — Node.js benchmark using mysql2
  - bench/bench_mysql.sh — bash wrapper that runs EXPLAIN ANALYZE and timings
  - .github/workflows/mysql-benchmark.yml — optional CI job to run benchmarks

Quickstart (local)
1. Start MySQL 8.0 and create a user with privileges.
2. Run schema:
   mysql -u user -p -h $MYSQL_HOST -P $MYSQL_PORT < sql/schema.sql
3. Seed (adjust @ROWS in seeds/seeds.sql if needed):
   mysql -u user -p -h $MYSQL_HOST -P $MYSQL_PORT < seeds/seeds.sql
4. Run the Node benchmark:
   npm install mysql2
   BENCH_ITERATIONS=50 BENCH_USER_ID=42 MYSQL_HOST=127.0.0.1 MYSQL_USER=user MYSQL_PASSWORD=p MYSQL_DATABASE=sales_savvy_bench node bench/bench_node.js

Benchmarking workflow
- Baseline run: apply schema and baseline indexes (do not apply sql/indexes.sql), seed data, run benchmark and save results.
- Optimized run: apply optimized indexes from sql/indexes.sql, run the same benchmark and compare results.

CI
- The workflow `.github/workflows/mysql-benchmark.yml` is configured to run on `workflow_dispatch` and will use a MySQL 8 service in GitHub Actions. Add repository secrets if you want it to run against an external DB.

Notes
- Benchmarks are environment-sensitive. Record DB version, CPU, memory, storage type, and any other relevant details.
- For consistent benchmarking consider restarting the DB between baseline and optimized runs or clearing buffers where possible.
