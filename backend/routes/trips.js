const express = require('express');
const router = express.Router();
const Trip = require('../models/Trip');

// LẤY TRIPS CỦA USER - GET /api/trips?userId=xxx&status=upcoming
router.get('/', async (req, res) => {
  try {
    const { userId, status } = req.query;
    let query = {};
    if (userId) query.userId = userId;
    if (status) query.status = status;

    const trips = await Trip.find(query).sort({ createdAt: -1 });
    res.json({ success: true, trips });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

// TẠO TRIP MỚI - POST /api/trips
router.post('/', async (req, res) => {
  try {
    const { userId, title, location, startDate, endDate, notes, status, guide, price } = req.body;
    const trip = new Trip({
      userId,
      title,
      location,
      startDate,
      endDate,
      notes,
      guide,
      price,
      status: status || 'upcoming'
    });
    await trip.save();
    res.json({ success: true, message: 'Tạo trip thành công!', trip });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

// LẤY CHI TIẾT TRIP - GET /api/trips/:id
router.get('/:id', async (req, res) => {
  try {
    const trip = await Trip.findById(req.params.id);
    if (!trip) return res.status(404).json({ success: false, message: 'Không tìm thấy trip' });
    res.json({ success: true, trip });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

// CẬP NHẬT TRIP - PUT /api/trips/:id
router.put('/:id', async (req, res) => {
  try {
    const trip = await Trip.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    if (!trip) return res.status(404).json({ success: false, message: 'Không tìm thấy trip' });
    res.json({ success: true, message: 'Cập nhật thành công!', trip });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

// XÓA TRIP - DELETE /api/trips/:id
router.delete('/:id', async (req, res) => {
  try {
    await Trip.findByIdAndDelete(req.params.id);
    res.json({ success: true, message: 'Đã xóa trip' });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

module.exports = router;