const express = require('express');
const router = express.Router();
const Tour = require('../models/Tour');

// LẤY TẤT CẢ TOURS - GET /api/tours
// Query params: ?category=beach&minPrice=100000&maxPrice=500000&page=1&limit=10
router.get('/', async (req, res) => {
  try {
    const { category, minPrice, maxPrice, page = 1, limit = 10 } = req.query;
    let filter = {};

    if (category) filter.category = category;
    if (minPrice || maxPrice) {
      filter.price = {};
      if (minPrice) filter.price.$gte = Number(minPrice);
      if (maxPrice) filter.price.$lte = Number(maxPrice);
    }

    const tours = await Tour.find(filter)
      .skip((page - 1) * limit)
      .limit(Number(limit))
      .sort({ createdAt: -1 });

    const total = await Tour.countDocuments(filter);
    res.json({ success: true, total, page: Number(page), tours });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

// SEED DATA MẪU - GET /api/tours/seed
router.get('/seed', async (req, res) => {
  try {
    await Tour.deleteMany({});

    const sampleTours = [
      {
        title: 'Tour Bà Nà Hills',
        description: 'Khám phá khu du lịch Bà Nà Hills với cầu Vàng nổi tiếng',
        location: 'Đà Nẵng',
        price: 850000,
        duration: '1 ngày',
        image: 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?w=800',
        rating: 4.8,
        category: 'mountain'
      },
      {
        title: 'Tour Hội An',
        description: 'Phố cổ Hội An về đêm lung linh đèn lồng',
        location: 'Hội An',
        price: 650000,
        duration: '1 ngày',
        image: 'https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=800',
        rating: 4.9,
        category: 'city'
      },
      {
        title: 'Tour Biển Mỹ Khê',
        description: 'Tắm biển và thưởng thức hải sản tươi ngon',
        location: 'Đà Nẵng',
        price: 350000,
        duration: '1 ngày',
        image: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
        rating: 4.6,
        category: 'beach'
      },
      {
        title: 'Tour Ngũ Hành Sơn',
        description: 'Khám phá núi đá cẩm thạch huyền bí',
        location: 'Đà Nẵng',
        price: 200000,
        duration: 'Nửa ngày',
        image: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
        rating: 4.5,
        category: 'mountain'
      },
      {
        title: 'Tour Mỹ Sơn',
        description: 'Thánh địa Mỹ Sơn - Di sản văn hóa thế giới',
        location: 'Quảng Nam',
        price: 750000,
        duration: '1 ngày',
        image: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
        rating: 4.7,
        category: 'culture'
      },
      {
        title: 'Tour Sơn Trà',
        description: 'Bán đảo Sơn Trà xanh mướt, ngắm voọc chà vá chân nâu',
        location: 'Đà Nẵng',
        price: 300000,
        duration: 'Nửa ngày',
        image: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
        rating: 4.6,
        category: 'nature'
      },
      {
        title: 'Tour Cù Lao Chàm',
        description: 'Lặn ngắm san hô, tắm biển trong xanh tuyệt đẹp',
        location: 'Hội An',
        price: 950000,
        duration: '1 ngày',
        image: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800',
        rating: 4.8,
        category: 'beach'
      }
    ];

    await Tour.insertMany(sampleTours);
    res.json({ success: true, message: `Đã tạo ${sampleTours.length} tours mẫu!` });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

// LẤY CHI TIẾT TOUR - GET /api/tours/:id
router.get('/:id', async (req, res) => {
  try {
    const tour = await Tour.findById(req.params.id);
    if (!tour) return res.status(404).json({ success: false, message: 'Không tìm thấy tour' });
    res.json({ success: true, tour });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

module.exports = router;