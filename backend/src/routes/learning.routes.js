const express = require('express');
const router = express.Router();
const { getVideos } = require('../controllers/learningController');

// Route for fetching videos
router.get('/videos', getVideos);

module.exports = router;
