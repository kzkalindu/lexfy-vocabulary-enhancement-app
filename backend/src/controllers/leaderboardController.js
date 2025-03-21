import db from '../config/firestore.js';

export const getLeaderboard = async (req, res) => {
  try {
    const leaderboardSnapshot = await db.collection('users')
      .orderBy('xpPoints', 'desc')
      .get();

    if (leaderboardSnapshot.empty) {
      return res.status(200).json({ leaderboard: [] });
    }

    const leaderboardData = leaderboardSnapshot.docs.map((doc) => {
      const data = doc.data();
      let rank;
      const xp = data.xpPoints || 0;

      if (xp >= 5000) rank = 'Master';
      else if (xp >= 2500) rank = 'Expert';
      else if (xp >= 1000) rank = 'Pro';
      else if (xp >= 100) rank = 'Beginner';
      else rank = 'Newbie';

      let username = data.displayName || '';
      if (!username && data.email && data.email.includes('@')) {
        username = data.email.split('@')[0];
      } else if (!username) {
        username = 'Unknown';
      }

      return {
        username,
        email: data.email || '',
        xp,
        rank,
        avatar: data.avatar || 'assets/images/avatars/avatar1.png',
        level: data.currentLevel || 1,
        uid: doc.id,
      };
    });

    return res.status(200).json({ leaderboard: leaderboardData });
  } catch (error) {
    console.error('❌ Error fetching leaderboard:', error);
    return res.status(500).json({ error: 'Failed to fetch leaderboard data' });
  }
};

export const getCurrentUserStats = async (req, res) => {
  try {
    const { userId } = req.params;
    if (!userId) return res.status(400).json({ error: 'User ID is required' });

    const userDoc = await db.collection('users').doc(userId).get();
    if (!userDoc.exists) return res.status(404).json({ error: 'User not found' });

    const userData = userDoc.data();
    const usersSnapshot = await db.collection('users').orderBy('xpPoints', 'desc').get();
    let currentUserRank = 0;

    usersSnapshot.docs.forEach((doc, index) => {
      if (doc.id === userId) currentUserRank = index + 1;
    });

    const xp = userData.xpPoints || 0;
    let rankTitle;
    if (xp >= 5000) rankTitle = 'Master';
    else if (xp >= 2500) rankTitle = 'Expert';
    else if (xp >= 1000) rankTitle = 'Pro';
    else if (xp >= 100) rankTitle = 'Beginner';
    else rankTitle = 'Newbie';

    let username = userData.displayName || '';
    if (!username && userData.email && data.email.includes('@')) {
      username = userData.email.split('@')[0];
    } else if (!username) {
      username = 'Unknown';
    }

    return res.status(200).json({
      username,
      email: userData.email || '',
      xp,
      rank: currentUserRank,
      rankTitle,
      avatar: userData.avatar || 'assets/images/avatars/avatar1.png',
      level: userData.currentLevel || 1,
      uid: userId,
    });
  } catch (error) {
    console.error('❌ Error fetching user stats:', error);
    return res.status(500).json({ error: 'Failed to fetch user statistics' });
  }
};

export const searchUsers = async (req, res) => {
  try {
    const { query } = req.query;
    if (!query) return res.status(400).json({ error: 'Search query is required' });

    const usersSnapshot = await db.collection('users').get();
    const searchResults = usersSnapshot.docs
      .map((doc) => {
        const data = doc.data();
        let username = data.displayName || '';
        if (!username && data.email && data.email.includes('@')) {
          username = data.email.split('@')[0];
        } else if (!username) {
          username = 'Unknown';
        }

        return {
          username,
          email: data.email || '',
          xp: data.xpPoints || 0,
          avatar: data.avatar || 'assets/images/avatars/avatar1.png',
          level: data.currentLevel || 1,
          uid: doc.id,
        };
      })
      .filter((user) => user.username.toLowerCase().includes(query.toLowerCase()))
      .sort((a, b) => b.xp - a.xp);

    return res.status(200).json({ users: searchResults });
  } catch (error) {
    console.error('❌ Error searching users:', error);
    return res.status(500).json({ error: 'Failed to search users' });
  }
};