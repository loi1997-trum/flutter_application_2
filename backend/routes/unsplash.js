const express = require('express');
const router = express.Router();
const axios = require('axios');

// TÌM ẢNH - GET /api/unsplash?query=da nang&count=10
router.get('/', async (req, res) => {
  try {
    const query = req.query.query || 'Da Nang Vietnam';
    const count = req.query.count || 10;

    const response = await axios.get(
      'https://api.unsplash.com/search/photos',
      {
        params: {
          query,
          per_page: count,
          orientation: 'landscape'
        },
        headers: {
          Authorization: `Client-ID ${process.env.UNSPLASH_ACCESS_KEY}`
        }
      }
    );

    const photos = response.data.results.map(photo => ({
      id: photo.id,
      url: photo.urls.regular,
      thumb: photo.urls.thumb,
      small: photo.urls.small,
      description: photo.alt_description || query,
      photographer: photo.user.name,
      photographer_url: photo.user.links.html
    }));

    res.json({ success: true, total: response.data.total, photos });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

module.exports = router;