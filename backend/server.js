require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Create MySQL connection
const db = mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'test'
});

db.connect(err => {
    if (err) {
        console.error('Database connection failed:', err);
        console.error('Connection config:', {
            host: process.env.DB_HOST,
            user: process.env.DB_USER,
            database: process.env.DB_NAME
        });
        return;
    }
    console.log('Connected to MySQL database');
});

// Handle database connection errors
db.on('error', (err) => {
    console.error('Database error:', err);
    if (err.code === 'PROTOCOL_CONNECTION_LOST') {
        console.error('Database connection was closed.');
    }
    if (err.code === 'ER_CON_COUNT_ERROR') {
        console.error('Database has too many connections.');
    }
    if (err.code === 'ECONNREFUSED') {
        console.error('Database connection was refused.');
    }
});

// Fetch leaderboard data
app.get('/api/leaderboard', (req, res) => {
    const sql = 'SELECT DISTINCT username, total_xp AS xp, avatar_url AS avatar FROM leaderboard ORDER BY total_xp DESC';

    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching leaderboard:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }
        res.json(results);
    });
});

// Fetch user profile
app.get('/api/profile/:username', (req, res) => {
    const { username } = req.params;
    const sql = 'SELECT username, avatar_url, total_xp FROM leaderboard WHERE username = ?';
    
    db.query(sql, [username], (err, result) => {
        if (err) {
            console.error('Error fetching user profile:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }
        if (result.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }
        res.json(result[0]);
    });
});

// Update user avatar
app.put('/api/profile/avatar', (req, res) => {
    const { username, avatarUrl } = req.body;
    if (!username || !avatarUrl) {
        return res.status(400).json({ error: 'Username and avatar URL are required' });
    }

    const sql = 'UPDATE leaderboard SET avatar_url = ? WHERE username = ?';
    db.query(sql, [avatarUrl, username], (err, result) => {
        if (err) {
            console.error('Error updating avatar:', err);
            return res.status(500).json({ error: 'Database update failed' });
        }
        res.json({ message: 'Avatar updated successfully' });
    });
});

app.post('/register', async (req, res) => {
    const { username, email } = req.body;
    
    console.log("Received Data:", req.body);  // 👈 This will print the incoming request

    if (!username || !email) {
        return res.status(400).json({ error: "Missing username or email" });
    }

    try {
        const query = "INSERT INTO user (username, email) VALUES (?, ?)";
        await db.execute(query, [username, email]);
        res.status(201).json({ message: "User registered successfully" });
    } catch (error) {
        console.error("Database Error:", error);
        res.status(500).json({ error: "Database insertion failed" });
    }
});



app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
