const mongoose = require('mongoose');

const questionSchema = new mongoose.Schema({
  question: { type: String, required: true },
  options: [String],
  correctAnswer: { type: String, required: true },
  explanation: String
});

const quizSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: String,
  category: {
    type: String,
    required: true,
    enum: ['grammar', 'vocabulary', 'pronunciation', 'reading']
  },
  questions: [questionSchema],
  timeLimit: Number, // in minutes
  points: { type: Number, default: 10 },
  difficulty: {
    type: String,
    enum: ['easy', 'medium', 'hard'],
    default: 'easy'
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('Quiz', quizSchema); 