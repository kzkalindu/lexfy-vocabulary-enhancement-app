const express = require('express');
const router = express.Router();
const { getLexfyQuestions } = require('../controllers/lexfyController');

router.get('/questions', getLexfyQuestions);

module.exports = router;
