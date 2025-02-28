const mongoose = require('mongoose');

const progressSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  lessonProgress: [{
    lessonId: { type: mongoose.Schema.Types.ObjectId, ref: 'Lesson' },
    completed: { type: Boolean, default: false },
    score: Number,
    completedAt: Date
  }],
  quizProgress: [{
    quizId: { type: mongoose.Schema.Types.ObjectId, ref: 'Quiz' },
    score: Number,
    completedAt: Date
  }],
  streak: { type: Number, default: 0 },
  lastStreak: { type: Date },
  totalXP: { type: Number, default: 0 },
  level: { type: Number, default: 1 }
}, {
  timestamps: true
});

module.exports = mongoose.model('Progress', progressSchema); 