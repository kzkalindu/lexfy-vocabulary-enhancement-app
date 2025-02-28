const mongoose = require('mongoose');

const lessonSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: String,
  videoUrl: String,
  youtubeId: String,
  category: {
    type: String,
    required: true,
    enum: ['grammar', 'vocabulary', 'pronunciation', 'conversation']
  },
  level: {
    type: String,
    enum: ['beginner', 'intermediate', 'advanced'],
    default: 'beginner'
  },
  duration: Number, // in minutes
  points: { type: Number, default: 10 },
  order: { type: Number, required: true }
}, {
  timestamps: true
});

module.exports = mongoose.model('Lesson', lessonSchema); 