# Seeds README

This directory contains SQL to seed the local MySQL 8.0 database used for benchmarking.

How to run

1. Adjust sizes in sql/seeds.sql by setting `@ROWS` and `@USERS` at the top (or override after connecting):
   SET @ROWS = 100000; SET @USERS = 10000;

2. Run the file with the mysql client:
   mysql -u your_user -p -h $MYSQL_HOST -P $MYSQL_PORT < seeds/seeds.sql

Notes
- The seed uses recursive CTEs (MySQL 8+). Be cautious with very large ROW counts in CI; use smaller values like 10_000 for quick runs.
- This script intentionally uses RAND() which is not deterministic; for deterministic runs replace RAND() with a function of n.
