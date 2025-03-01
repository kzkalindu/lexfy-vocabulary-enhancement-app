const express = require("express");
const cors = require("cors");
const axios = require("axios");

const app = express();
app.use(cors()); 
app.use(express.json());

// Add a simple root route to prevent 404 errors
app.get("/", (req, res) => {
  res.send("Server is running! Go to /api/videos to fetch videos.");
});

const apiKey = "AIzaSyCm6AnaMAh0L6a0JqSHU-BNQjYEl3VCqnk";

// Queries for different topics
const queries = [
  "learn English grammar",
  "English conversation practice",
  "English speaking tips",
  "English vocabulary building",
  "English pronunciation practice",
  "English listening skills",
  "Common English phrases",
  "English level tests",
  "English writing tips",
];

// Function to get a random query
function getRandomQuery() {
  return queries[Math.floor(Math.random() * queries.length)];
}

// Fetch videos from YouTube API
app.get("/api/videos", async (req, res) => {
  try {
    const selectedQuery = getRandomQuery();
    console.log(`Fetching videos for: ${selectedQuery}`);

    const url = `https://www.googleapis.com/youtube/v3/search?part=snippet&q=${encodeURIComponent(
      selectedQuery
    )}&type=video&maxResults=10&videoDuration=long&key=${apiKey}`;

    const response = await axios.get(url);

    const videos = response.data.items.map((item) => ({
      id: item.id.videoId,
      title: item.snippet.title,
      thumbnail: item.snippet.thumbnails.high.url,
    }));

    res.json(videos);
  } catch (error) {
    console.error("Error fetching videos:", error.message);
    res.status(500).json({ error: "Failed to fetch videos" });
  }
});

// Export the Express app for Vercel
module.exports = app;
