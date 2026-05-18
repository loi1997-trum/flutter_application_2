const mongoose = require('mongoose');

const tripSchema = new mongoose.Schema({
  userId:    { type: String },
  title:     { type: String, required: true },
  location:  { type: String, default: '' },
  startDate: { type: Date },
  endDate:   { type: Date },
  status:    { 
    type: String, 
    enum: ['upcoming', 'ongoing', 'completed', 'wishlist'], 
    default: 'upcoming' 
  },
  notes:     { type: String, default: '' },
  guide:     { type: String, default: '' },
  price:     { type: Number, default: 0 },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Trip', tripSchema);