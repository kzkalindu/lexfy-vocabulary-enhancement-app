const express = require('express');
const router = express.Router();
const { getRandomWords, searchWord } = require('../controllers/wordController');

router.get('/random', getRandomWords);
router.get('/search/:word', searchWord);

module.exports = router; 