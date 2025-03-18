import express from 'express';
import { getTopics } from '../controllers/topicController.js';

const router = express.Router();

router.get('/topics', getTopics);

export default router;