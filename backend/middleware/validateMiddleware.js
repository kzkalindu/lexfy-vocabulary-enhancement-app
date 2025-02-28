const { validationResult } = require('express-validator');

exports.validate = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  next();
};

exports.quizSubmissionRules = [
  body('quizId').notEmpty().isMongoId(),
  body('answers').isArray(),
  body('score').isNumeric()
];

exports.lessonCompletionRules = [
  body('score').isNumeric(),
]; 