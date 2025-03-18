import express from 'express';
const router = express.Router();
import { getVideos } from '../controllers/learningController.js';

// Route for fetching videos
router.get('/videos', getVideos);

export { router };