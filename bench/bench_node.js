// bench/bench_node.js
// Node.js benchmark script using mysql2/promise
// Usage: DATABASE_URL or individual env vars (MYSQL_HOST, MYSQL_PORT, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE)

const mysql = require('mysql2/promise');
const os = require('os');

const ITERATIONS = parseInt(process.env.BENCH_ITERATIONS || "50", 10);
const USER_ID = parseInt(process.env.BENCH_USER_ID || "42", 10);

function stats(arr) {
  const sorted = arr.slice().sort((a,b)=>a-b);
  const sum = arr.reduce((a,b)=>a+b,0);
  const avg = sum/arr.length;
  const median = sorted[Math.floor(sorted.length/2)];
  return {runs: arr.length, avg, median, min: sorted[0], max: sorted[sorted.length-1]};
}

(async ()=>{
  const config = {
    host: process.env.MYSQL_HOST || "127.0.0.1",
    port: parseInt(process.env.MYSQL_PORT || "3306", 10),
    user: process.env.MYSQL_USER || "root",
    password: process.env.MYSQL_PASSWORD || "",
    database: process.env.MYSQL_DATABASE || "sales_savvy_bench",
    multipleStatements: false
  };

  console.log("Connecting to MySQL", config.host+":"+config.port, "DB=", config.database);
  const conn = await mysql.createConnection(config);

  const query = "SELECT COUNT(*) as cnt FROM tasks WHERE user_id = ? AND status = ?";
  const times = [];

  // Warm-up
  for (let i=0;i<5;i++) {
    await conn.execute(query, [USER_ID, "todo"]);
  }

  for (let i=0;i<ITERATIONS;i++){
    const start = Date.now();
    const [rows] = await conn.execute(query, [USER_ID, "todo"]);
    const elapsed = Date.now() - start;
    times.push(elapsed);
  }

  await conn.end();
  console.log("Benchmark results:", stats(times));
})();
