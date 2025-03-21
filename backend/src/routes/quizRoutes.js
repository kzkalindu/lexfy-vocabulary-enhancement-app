import express from 'express';
import quizController from '../controllers/quizController.js';
import authMiddleware from '../middleware/auth.js';

const router = express.Router();

router.get('/', authMiddleware, quizController.getQuizzesByLevel);

export { router };