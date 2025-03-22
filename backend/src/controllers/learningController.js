import axios from 'axios';

// Parse multiple API keys from environment variable
const apiKeys = process.env.YOUTUBE_API_KEYS.split(',');

// Function to get the next API key
let currentKeyIndex = 0;
function getNextApiKey() {
    const key = apiKeys[currentKeyIndex];
    currentKeyIndex = (currentKeyIndex + 1) % apiKeys.length; // Rotate keys
    return key;
}

// English learning topics for university students
const queries = [
    // Grammar and Language Structure
    'Advanced English grammar',
    'English grammar for academic writing',

    // Speaking and Communication Skills
    'English speaking tips for university students',
    'English pronunciation practice',
    'Academic presentation skills in English',

    // Listening and Comprehension
    'English listening practice for advanced learners',
    'Understanding academic English lectures',

    // Writing and Academic Skills
    'How to write a research paper in English',
    'Essay writing tips',
    'Academic vocabulary for essays',

    // Vocabulary Building
    'Advanced English vocabulary for students',
    'Learn academic English words',

    // Soft Skills in English
    'Email writing skills in English',
    'Professional communication in English'
];

// Function to get a random query
function getRandomQuery() {
    const randomIndex = Math.floor(Math.random() * queries.length);
    return queries[randomIndex];
}

// Fetch YouTube Videos
const getVideos = async (req, res) => {
    try {
        const selectedQuery = getRandomQuery();
        console.log(`Fetching videos for: ${selectedQuery}`);

        // Get the next API key
        const apiKey = getNextApiKey();
        console.log(`Using API key: ${apiKey}`);

        const url = `https://www.googleapis.com/youtube/v3/search?part=snippet&q=${encodeURIComponent(selectedQuery)}&type=video&maxResults=10&videoDuration=medium&key=${apiKey}`;

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

export { getVideos };