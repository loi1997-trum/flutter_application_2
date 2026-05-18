const express = require('express');
const router = express.Router();
const axios = require('axios');

// LẤY THỜI TIẾT - GET /api/weather?city=Da Nang
router.get('/', async (req, res) => {
  try {
    const city = req.query.city || 'Da Nang';

    const response = await axios.get(
      'https://api.openweathermap.org/data/2.5/weather',
      {
        params: {
          q: city,
          appid: process.env.WEATHER_API_KEY,
          units: 'metric',
          lang: 'vi'
        }
      }
    );

    const d = response.data;
    res.json({
      success: true,
      city: d.name,
      country: d.sys.country,
      temperature: Math.round(d.main.temp),
      feels_like: Math.round(d.main.feels_like),
      temp_min: Math.round(d.main.temp_min),
      temp_max: Math.round(d.main.temp_max),
      humidity: d.main.humidity,
      description: d.weather[0].description,
      icon: d.weather[0].icon,
      icon_url: `https://openweathermap.org/img/wn/${d.weather[0].icon}@2x.png`,
      wind_speed: d.wind.speed,
      visibility: d.visibility
    });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
});

module.exports = router;