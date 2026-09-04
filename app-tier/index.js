const transactionService = require('./TransactionService');
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = Number(process.env.PORT) || 4000;

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Browser requests are same-origin in AWS. Set CORS_ORIGIN only for a trusted
// local or external frontend that must call the API directly.
app.use(cors({ origin: process.env.CORS_ORIGIN || false }));

app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

app.post('/transaction', async (req, res) => {
  const amount = Number(req.body.amount);
  const description = String(req.body.desc || '').trim();

  if (!Number.isFinite(amount) || !description || description.length > 255) {
    res.status(400).json({ message: 'A numeric amount and description of 1-255 characters are required.' });
    return;
  }

  try {
    await transactionService.addTransaction(amount, description);
    res.status(201).json({ message: 'Transaction added successfully.' });
  } catch (error) {
    console.error('Failed to add transaction:', error.message);
    res.status(500).json({ message: 'Unable to add transaction.' });
  }
});

app.get('/transaction', async (req, res) => {
  try {
    const transactions = await transactionService.getAllTransactions();
    res.json({ result: transactions });
  } catch (error) {
    console.error('Failed to list transactions:', error.message);
    res.status(500).json({ message: 'Unable to list transactions.' });
  }
});

app.delete('/transaction', async (req, res) => {
  try {
    await transactionService.deleteAllTransactions();
    res.json({ message: 'All transactions deleted.' });
  } catch (error) {
    console.error('Failed to delete transactions:', error.message);
    res.status(500).json({ message: 'Unable to delete transactions.' });
  }
});

app.get('/transaction/:id', async (req, res) => {
  const id = Number.parseInt(req.params.id, 10);
  if (!Number.isInteger(id) || id < 1) {
    res.status(400).json({ message: 'A positive transaction ID is required.' });
    return;
  }

  try {
    const transaction = await transactionService.findTransactionById(id);
    if (!transaction) {
      res.status(404).json({ message: 'Transaction not found.' });
      return;
    }
    res.json(transaction);
  } catch (error) {
    console.error('Failed to retrieve transaction:', error.message);
    res.status(500).json({ message: 'Unable to retrieve transaction.' });
  }
});

app.delete('/transaction/:id', async (req, res) => {
  const id = Number.parseInt(req.params.id, 10);
  if (!Number.isInteger(id) || id < 1) {
    res.status(400).json({ message: 'A positive transaction ID is required.' });
    return;
  }

  try {
    const result = await transactionService.deleteTransactionById(id);
    if (result.affectedRows === 0) {
      res.status(404).json({ message: 'Transaction not found.' });
      return;
    }
    res.json({ message: `Transaction ${id} deleted.` });
  } catch (error) {
    console.error('Failed to delete transaction:', error.message);
    res.status(500).json({ message: 'Unable to delete transaction.' });
  }
});

async function start() {
  await transactionService.initializeDatabase();
  return app.listen(port, () => {
    console.log(`AWS 3-tier app listening on port ${port}`);
  });
}

if (require.main === module) {
  start().catch((error) => {
    console.error('Application startup failed:', error.message);
    process.exit(1);
  });
}

module.exports = app;
