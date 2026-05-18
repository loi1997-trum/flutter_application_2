require('dotenv').config({ path: require('path').join(__dirname, '.env') });

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

app.use('/api/weather',  require('./routes/weather'));
app.use('/api/unsplash', require('./routes/unsplash'));
app.use('/api/places',   require('./routes/places'));
app.use('/api/currency', require('./routes/currency'));
app.use('/api/auth',     require('./routes/auth'));
app.use('/api/tours',    require('./routes/tours'));
app.use('/api/trips',    require('./routes/trips'));

app.get('/', (req, res) => {
  res.json({ message: '🚀 Backend Travel App đang chạy!' });
});

mongoose.connect(process.env.MONGODB_URI)
  .then(() => console.log('✅ MongoDB connected'))
  .catch(err => console.log('❌ MongoDB error:', err.message));

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`🚀 Server: http://localhost:${PORT}`));