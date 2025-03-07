const axios = require('axios');

const apiKey = 'AIzaSyCm6AnaMAh0L6a0JqSHU-BNQjYEl3VCqnk'; // Replace with your API key

// Multiple queries for different topics
const queries = [
    'learn English grammar',
    'research paper writing',
    'university level English writing',
    'study tips for university exams',
    'English grammar practice tests',
    'English for academic research',
    'public speaking for university students'
  ];
  

// Function to get a random query
function getRandomQuery() {
  return queries[Math.floor(Math.random() * queries.length)];
}

// Fetch videos from YouTube API
const getVideos = async (req, res) => {
  try {
    const selectedQuery = getRandomQuery();
    console.log(`Fetching videos for: ${selectedQuery}`);

    const url = `https://www.googleapis.com/youtube/v3/search?part=snippet&q=${encodeURIComponent(selectedQuery)}&type=video&maxResults=15&videoDuration=medium&key=${apiKey}`;
    
    const response = await axios.get(url);

    const videos = response.data.items.map((item) => ({
      id: item.id.videoId,
      title: item.snippet.title,
      thumbnail: item.snippet.thumbnails.high.url,
    }));

    res.json(videos);
  } catch (error) {
    console.error('Error fetching videos:', error);
    res.status(500).json({ error: 'Failed to fetch videos' });
  }
};

module.exports = { getVideos };
