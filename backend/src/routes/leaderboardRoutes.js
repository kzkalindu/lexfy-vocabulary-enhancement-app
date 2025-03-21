import express from 'express';
import { getLeaderboard, getCurrentUserStats, searchUsers } from '../controllers/leaderboardController.js';

const router = express.Router();

router.get('/', getLeaderboard);
router.get('/user/:userId', getCurrentUserStats);
router.get('/search', searchUsers);

export default router;