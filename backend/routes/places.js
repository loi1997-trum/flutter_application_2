const express = require('express');
const router = express.Router();
const axios = require('axios');

// TÌM KIẾM ĐỊA ĐIỂM - GET /api/places?query=bãi biển đà nẵng
router.get('/', async (req, res) => {
  try {
    const query = req.query.query || 'tourist attraction Da Nang';

    const response = await axios.get(
      'https://maps.googleapis.com/maps/api/place/textsearch/json',
      {
        params: {
          query,
          language: 'vi',
          key: process.env.GOOGLE_API_KEY
        }
      }
    );

    const places = response.data.results.map(p => ({
      id:       p.place_id,
      name:     p.name,
      address:  p.formatted_address,
      rating:   p.rating || 0,
      total_ratings: p.user_ratings_total || 0,
      photo:    p.photos?.[0]
        ? `https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=${p.photos[0].photo_reference}&key=${process.env.GOOGLE_API_KEY}`
        : null,
      location: p.geometry?.location,
      types:    p.types,
      open_now: p.opening_hours?.open_now ?? null
    }));

    res.json({ success: true, total: places.length, places });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

// CHI TIẾT ĐỊA ĐIỂM - GET /api/places/:placeId
router.get('/:placeId', async (req, res) => {
  try {
    const response = await axios.get(
      'https://maps.googleapis.com/maps/api/place/details/json',
      {
        params: {
          place_id: req.params.placeId,
          language: 'vi',
          fields: 'name,formatted_address,rating,photos,geometry,opening_hours,formatted_phone_number,website,user_ratings_total',
          key: process.env.GOOGLE_API_KEY
        }
      }
    );

    const p = response.data.result;
    res.json({
      success: true,
      place: {
        name:          p.name,
        address:       p.formatted_address,
        rating:        p.rating,
        total_ratings: p.user_ratings_total,
        phone:         p.formatted_phone_number,
        website:       p.website,
        hours:         p.opening_hours?.weekday_text,
        open_now:      p.opening_hours?.open_now ?? null,
        location:      p.geometry?.location,
        photos:        p.photos?.slice(0, 5).map(ph =>
          `https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=${ph.photo_reference}&key=${process.env.GOOGLE_API_KEY}`
        )
      }
    });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

module.exports = router;