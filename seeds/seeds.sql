-- seeds/seeds.sql
-- Seed data generator using recursive CTE (MySQL 8+). Configure ROWS to control scale.
-- WARNING: Large ROWS values can take long in CI. Use a smaller number in CI (e.g., 10_000).

SET @ROWS = 100000; -- default number of task rows; override before running: SET @ROWS = 20000;
SET @USERS = 10000;

USE sales_savvy_bench;

-- Create some users
INSERT INTO users (name, email, created_at)
SELECT
  CONCAT('User ', n) AS name,
  CONCAT('user', n, '@example.com') AS email,
  NOW() - INTERVAL (n % 365) DAY
FROM (
  WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n+1 FROM seq WHERE n < @USERS
  ) SELECT n FROM seq
) x;

-- Create leads
INSERT INTO leads (user_id, company, amount, status, created_at)
SELECT
  (1 + FLOOR(RAND() * @USERS)) AS user_id,
  CONCAT('Company ', FLOOR(RAND()*10000)),
  ROUND(RAND()*100000,2),
  ELT(1 + FLOOR(RAND()*5), 'new','contacted','qualified','lost','won'),
  NOW() - INTERVAL FLOOR(RAND()*365) DAY
FROM (
  WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n+1 FROM seq WHERE n < FLOOR(@ROWS/10)
  ) SELECT n FROM seq
) x;

-- Create tasks using recursive CTE
INSERT INTO tasks (user_id, title, description, status, priority, metadata, created_at)
SELECT
  (1 + FLOOR(RAND() * @USERS)) AS user_id,
  CONCAT('Task title ', n) AS title,
  CONCAT('Description for task ', n, ' random: ', MD5(RAND())) AS description,
  ELT(1 + FLOOR(RAND()*3), 'todo','doing','done') AS status,
  1 + FLOOR(RAND()*5) AS priority,
  JSON_OBJECT('seed', n, 'random', MD5(RAND())) AS metadata,
  NOW() - INTERVAL FLOOR(RAND()*365) DAY
FROM (
  WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n+1 FROM seq WHERE n < @ROWS
  ) SELECT n FROM seq
) x;
