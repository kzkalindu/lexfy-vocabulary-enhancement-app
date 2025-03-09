const { testDB } = require('../config/db');

const getTestQuestions = (req, res) => {
    const query = 'SELECT * FROM test_questions ORDER BY RAND() LIMIT 10';

    testDB.query(query, (err, results) => {
        if (err) {
            console.error('❌ Error fetching test questions:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }
        res.json(results);
    });
};

module.exports = { getTestQuestions };
