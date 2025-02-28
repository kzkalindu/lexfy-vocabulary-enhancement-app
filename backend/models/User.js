const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  firebaseId: {
    type: String,
    required: true,
    unique: true
  },
  email: {
    type: String,
    required: true,
    unique: true
  },
  displayName: String,
  progress: {
    words: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Word' }],
    lessons: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Lesson' }],
    quizzes: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Quiz' }]
  },
  settings: {
    language: { type: String, default: 'en' },
    notifications: { type: Boolean, default: true }
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('User', userSchema); 