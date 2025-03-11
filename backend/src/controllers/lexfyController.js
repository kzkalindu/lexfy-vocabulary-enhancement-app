const { lexfyDB } = require('../config/db');

const getLexfyQuestions = (req, res) => {
    const query = 'SELECT * FROM questions ORDER BY RAND() LIMIT 10';

    lexfyDB.query(query, (err, results) => {
        if (err) {
            console.error('❌ Error fetching lexfy questions:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }
        res.json(results);
    });
};

module.exports = { getLexfyQuestions };
