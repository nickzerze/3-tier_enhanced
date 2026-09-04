const dbcreds = require('./DbConfig');
const mysql = require('mysql');

const pool = mysql.createPool({
  connectionLimit: 10,
  host: dbcreds.DB_HOST,
  user: dbcreds.DB_USER,
  password: dbcreds.DB_PWD,
  database: dbcreds.DB_DATABASE
});

function query(sql, parameters = []) {
  return new Promise((resolve, reject) => {
    pool.query(sql, parameters, (error, results) => {
      if (error) {
        reject(error);
        return;
      }
      resolve(results);
    });
  });
}

async function initializeDatabase() {
  const sql = `
    CREATE TABLE IF NOT EXISTS transactions (
      id INT UNSIGNED NOT NULL AUTO_INCREMENT,
      amount DECIMAL(12, 2) NOT NULL,
      description VARCHAR(255) NOT NULL,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (id)
    ) ENGINE=InnoDB
  `;
  return query(sql);
}

async function addTransaction(amount, description) {
  const sql = 'INSERT INTO transactions (amount, description) VALUES (?, ?)';
  return query(sql, [amount, description]);
}

async function getAllTransactions() {
  return query('SELECT id, amount, description FROM transactions');
}

async function findTransactionById(id) {
  const rows = await query(
    'SELECT id, amount, description FROM transactions WHERE id = ?',
    [id]
  );
  return rows[0] || null;
}

async function deleteAllTransactions() {
  return query('DELETE FROM transactions');
}

async function deleteTransactionById(id) {
  return query('DELETE FROM transactions WHERE id = ?', [id]);
}

module.exports = {
  initializeDatabase,
  addTransaction,
  getAllTransactions,
  findTransactionById,
  deleteAllTransactions,
  deleteTransactionById
};
