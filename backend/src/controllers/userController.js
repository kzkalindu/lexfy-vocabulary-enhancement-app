import db from '../config/firestore.js';
import Constants from '../utils/constants.js';

const updateUserProgress = async (req, res) => {
  try {
    const { currentLevel, xpPoints, completedLevels } = req.body;
    const userId = req.user.uid;

    const userRef = db.collection('users').doc(userId);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      const newUser = {
        uid: userId,
        email: req.user.email,
        currentLevel: currentLevel || 1,
        xpPoints: xpPoints || 0,
        rank: 'Newbie',
        completedLevels: completedLevels || [1],
      };
      await userRef.set(newUser);
      return res.status(201).json(newUser);
    }

    const userData = userDoc.data();
    const updatedData = {
      currentLevel: currentLevel || userData.currentLevel,
      xpPoints: xpPoints || userData.xpPoints,
      completedLevels: completedLevels || userData.completedLevels,
      rank: calculateRank(xpPoints || userData.xpPoints),
      email: userData.email,
      uid: userId,
    };

    await userRef.update(updatedData);
    res.status(200).json(updatedData);
  } catch (error) {
    console.error('Error updating user progress:', error);
    res.status(500).json({ error: 'Failed to update user progress' });
  }
};

const calculateRank = (xp) => {
  if (xp >= Constants.RANKS_MASTER_XP) return 'Master';
  if (xp >= Constants.RANKS_EXPERT_XP) return 'Expert';
  if (xp >= Constants.RANKS_LEARNER_XP) return 'Learner';
  return 'Newbie';
};

export default {
  updateUserProgress,
};