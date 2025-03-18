import express from 'express';
const router = express.Router();
import { getRandomWords, searchWord } from '../controllers/wordController.js';

router.get('/random', getRandomWords);
router.get('/search/:word', searchWord);

export { router };