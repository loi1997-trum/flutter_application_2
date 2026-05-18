const mongoose = require('mongoose');

const tourSchema = new mongoose.Schema({
  title:       { type: String, required: true },
  description: { type: String },
  location:    { type: String },
  price:       { type: Number },
  duration:    { type: String },  // VD: "3 ngày 2 đêm"
  image:       { type: String },  // URL ảnh
  rating:      { type: Number, default: 0 },
  category:    { type: String },  // VD: "beach", "mountain", "city"
  createdAt:   { type: Date, default: Date.now }
});

module.exports = mongoose.model('Tour', tourSchema);