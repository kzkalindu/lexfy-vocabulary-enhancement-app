import db from '../config/firestore.js'; // Update to use Firestore

export const getTopics = async (req, res) => {
  console.log(`Received request from ${req.ip} for topics`); // Log the request details

  try {
    const topicsSnapshot = await db.collection('topics').get();
    const topics = topicsSnapshot.docs.map(doc => ({
      name: doc.data().name,
      icon_svg: doc.data().icon_svg
    }));

    // Shuffle the topics array and select the first 4
    const shuffledTopics = topics.sort(() => 0.5 - Math.random()).slice(0, 4);

    console.log("✅ Topics fetched:", shuffledTopics);
    res.json(shuffledTopics);
  } catch (err) {
    console.error("❌ Firestore Error:", err);
    res.status(500).json({ error: "Database error" });
  }
};