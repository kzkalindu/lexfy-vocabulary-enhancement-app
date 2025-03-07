const express = require('express');
const cors = require('cors');
const { getVideos } = require('./src/learning/learning'); // Import the function

const app = express();
const port = 3000;

app.use(cors());

// Route for fetching videos
app.get('/api/videos', getVideos);

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});