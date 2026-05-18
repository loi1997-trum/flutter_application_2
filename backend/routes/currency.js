const express = require('express');
const router = express.Router();
const axios = require('axios');

router.get('/', async (req, res) => {
  try {
    const from = req.query.from || 'USD';
    const to = req.query.to || 'VND';
    const amount = parseFloat(req.query.amount) || 1;

    const response = await axios.get(
      `https://api.exchangerate-api.com/v4/latest/${from}`
    );

    const rate = response.data.rates[to];
    const result = amount * rate;

    res.json({
      success: true,
      from,
      to,
      amount,
      rate,
      result: Math.round(result),
      result_formatted: result.toLocaleString('vi-VN'),
    });

  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

module.exports = router;