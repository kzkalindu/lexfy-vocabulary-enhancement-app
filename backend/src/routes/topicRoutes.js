import express from 'express';
const router = express.Router();
import { getTopics } from '../controllers/topicController.js';

// Route for fetching topics
router.get('/data', getTopics);

export { router };