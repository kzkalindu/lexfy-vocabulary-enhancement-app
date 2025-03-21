import db from '../config/firestore.js';

const getQuizzesByLevel = async (req, res) => {
  try {
    const level = parseInt(req.query.level);
    if (!level || level < 1) {
      return res.status(400).json({ error: 'Invalid level' });
    }

    const snapshot = await db.collection('quizzes')
      .where('level', '==', level)
      .limit(5)
      .get();

    if (snapshot.empty) {
      return res.status(404).json({ error: `No quizzes found for level ${level}` });
    }

    const quizzes = snapshot.docs.map(doc => ({
      id: doc.id,
      question: doc.data().question,
      options: doc.data().options,
      answerIndex: doc.data().answerIndex,
      category: doc.data().category,
      level: doc.data().level,
    }));

    res.status(200).json(quizzes);
  } catch (error) {
    console.error('Error fetching quizzes:', error);
    res.status(500).json({ error: 'Failed to fetch quizzes' });
  }
};

export default {
  getQuizzesByLevel,
};