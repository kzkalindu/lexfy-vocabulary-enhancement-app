const mongoose = require('mongoose');

const wordSchema = new mongoose.Schema({
  word: { type: String, required: true },
  definition: { type: String, required: true },
  example: String,
  partOfSpeech: String,
  isDaily: { type: Boolean, default: false },
  date: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Word', wordSchema); 