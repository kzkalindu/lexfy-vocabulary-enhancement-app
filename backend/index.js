import express from 'express';
import cors from 'cors';
import topicRoutes from './routes/topicRoutes.js';
import { initializeWebSocketServer } from './config/websocket.js';
import testRoutes from './src/routes/test.routes';
import lexfyRoutes from './src/routes/lexfy.routes';
import learningRoutes from './src/routes/learning.routes';
import wordRoutes from './src/routes/word.routes';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes for Test & Lexfy Databases
app.use('/api/test', testRoutes);
app.use('/api/lexfy', lexfyRoutes);

// Route for Learning Module (YouTube Videos)
app.use('/api/learning', learningRoutes);

// Add the new word routes
app.use('/api/words', wordRoutes);

// Routes for Topics
app.use('/api', topicRoutes);

const server = app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  initializeWebSocketServer(server); // Initialize WebSocket server with HTTP server instance
});

console.log("🟢 WebSocket Server Started...");