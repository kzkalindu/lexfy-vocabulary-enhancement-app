const mysql = require('mysql2');

// Test Database Connection
const testDB = mysql.createConnection({
    host: process.env.TEST_DB_HOST,
    user: process.env.TEST_DB_USER,
    password: process.env.TEST_DB_PASSWORD || '',
    database: process.env.TEST_DB_NAME,
    port: process.env.TEST_DB_PORT || 3306,
});

// Lexfynew Database Connection
const lexfyDB = mysql.createConnection({
    host: process.env.LEXFY_DB_HOST,
    user: process.env.LEXFY_DB_USER,
    password: process.env.LEXFY_DB_PASSWORD || '',
    database: process.env.LEXFY_DB_NAME,
    port: process.env.LEXFY_DB_PORT || 3306,
});

// Connect to Test Database
testDB.connect((err) => {
    if (err) {
        console.error('❌ Test Database connection failed:', err);
    } else {
        console.log('✅ Connected to Test Database');
    }
});

// Connect to Lexfynew Database
lexfyDB.connect((err) => {
    if (err) {
        console.error('❌ Lexfynew Database connection failed:', err);
    } else {
        console.log('✅ Connected to Lexfynew Database');
    }
});

module.exports = { testDB, lexfyDB };

