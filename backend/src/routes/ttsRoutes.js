import express from 'express';
import { textToSpeech } from '../controllers/aiController.js';

const router = express.Router();

router.post('/tts', async (req, res) => {
  const { text } = req.body;
  if (!text) {
    return res.status(400).json({ error: 'Text is required' });
  }

  try {
    const audioBase64 = await textToSpeech(text);
    res.status(200).send(audioBase64);
  } catch (error) {
    console.error('❌ TTS Error:', error);
    res.status(500).json({ error: 'Failed to generate TTS audio' });
  }
});

export { router };