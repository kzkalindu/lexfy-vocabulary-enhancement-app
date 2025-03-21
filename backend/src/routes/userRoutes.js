import express from 'express';
import userController from '../controllers/userController.js';
import authMiddleware from '../middleware/auth.js';

const router = express.Router();

router.post('/progress', authMiddleware, userController.updateUserProgress);

export { router };