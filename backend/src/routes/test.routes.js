const express = require('express');
const router = express.Router();
const { getTestQuestions } = require('../controllers/testController');

router.get('/questions', getTestQuestions);

module.exports = router;
