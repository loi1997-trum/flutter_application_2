const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

const JWT_SECRET = 'travel_app_secret_2024';

// Middleware verify token
const verifyToken = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ success: false, message: 'Không có token' });
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.userId = decoded.userId;
    next();
  } catch {
    res.status(401).json({ success: false, message: 'Token không hợp lệ' });
  }
};

// ĐĂNG KÝ
router.post('/register', async (req, res) => {
  try {
    const { name, email, password } = req.body;
    const existing = await User.findOne({ email });
    if (existing) return res.status(400).json({ success: false, message: 'Email đã tồn tại' });
    const hashed = await bcrypt.hash(password, 10);
    const user = new User({ name, email, password: hashed });
    await user.save();
    const token = jwt.sign({ userId: user._id }, JWT_SECRET, { expiresIn: '30d' });
    res.json({
      success: true,
      message: 'Đăng ký thành công!',
      token,
      user: { id: user._id, name: user.name, email: user.email }
    });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

// ĐĂNG NHẬP
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ success: false, message: 'Email không tồn tại' });
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ success: false, message: 'Sai mật khẩu' });
    const token = jwt.sign({ userId: user._id }, JWT_SECRET, { expiresIn: '30d' });
    res.json({
      success: true,
      message: 'Đăng nhập thành công!',
      token,
      user: { id: user._id, name: user.name, email: user.email, avatar: user.avatar }
    });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

// XEM PROFILE
router.get('/profile', verifyToken, async (req, res) => {
  try {
    const user = await User.findById(req.userId).select('-password');
    if (!user) return res.status(404).json({ success: false, message: 'Không tìm thấy user' });
    res.json({ success: true, user });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

// CẬP NHẬT PROFILE
router.put('/profile', verifyToken, async (req, res) => {
  try {
    const updates = {};
    if (req.body.name)   updates.name   = req.body.name;
    if (req.body.phone)  updates.phone  = req.body.phone;
    if (req.body.avatar) updates.avatar = req.body.avatar;
    const user = await User.findByIdAndUpdate(
      req.userId, updates, { new: true }
    ).select('-password');
    res.json({ success: true, user });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

module.exports = router;