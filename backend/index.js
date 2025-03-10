require('dotenv').config();
const express = require('express');
const cors = require('cors');
const testRoutes = require('./src/routes/test.routes');
const lexfyRoutes = require('./src/routes/lexfy.routes');
const learningRoutes = require('./src/routes/learning.routes');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Routes for Test & Lexfy Databases
app.use('/api/test', testRoutes);
app.use('/api/lexfy', lexfyRoutes);

// Route for Learning Module (YouTube Videos)
app.use('/api/learning', learningRoutes);

app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});
