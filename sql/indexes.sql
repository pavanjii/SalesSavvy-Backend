-- sql/indexes.sql
-- Baseline (keep): existing indexes in schema.sql
-- Optimized indexes (apply these to measure improvements)

USE sales_savvy_bench;

-- Index for common filter: user + status + created_at desc for most-recent queries
CREATE INDEX IF NOT EXISTS idx_tasks_user_status_created_at ON tasks (user_id, status, created_at DESC);

-- Covering index for queries that fetch title and status by user
CREATE INDEX IF NOT EXISTS idx_tasks_user_priority_status ON tasks (user_id, priority, status);

-- Index for leads queries: status + amount
CREATE INDEX IF NOT EXISTS idx_leads_status_amount ON leads (status, amount DESC);
