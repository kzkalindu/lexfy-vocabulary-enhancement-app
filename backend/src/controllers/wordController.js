const axios = require('axios');

// Curated list of academic verbs relevant for university students
const academicVerbs = [
    'analyze', 'research', 'study', 'examine', 'investigate',
    'evaluate', 'synthesize', 'critique', 'demonstrate', 'explain',
    'interpret', 'discuss', 'explore', 'review', 'assess',
    'develop', 'implement', 'conduct', 'present', 'argue',
    'compare', 'contrast', 'define', 'describe', 'elaborate',
    'illustrate', 'outline', 'summarize', 'validate', 'verify'
];

const getRandomWords = async (req, res) => {
    try {
        // Add CORS headers
        res.header('Access-Control-Allow-Origin', '*');
        res.header('Access-Control-Allow-Methods', 'GET');
        res.header('Access-Control-Allow-Headers', 'Content-Type');

        // Shuffle and select 25 verbs
        const shuffledVerbs = academicVerbs.sort(() => Math.random() - 0.5).slice(0, 25);
        const allVerbDetails = [];
        
        // Process verbs in batches of 5
        const batchSize = 5;
        for (let i = 0; i < shuffledVerbs.length; i += batchSize) {
            const batch = shuffledVerbs.slice(i, i + batchSize);
            const batchPromises = batch.map(async (verb) => {
                try {
                    const details = await axios.get(`https://api.dictionaryapi.dev/api/v2/entries/en/${verb}`);
                    const data = details.data[0];
                    
                    // Find verb-specific definitions
                    const verbMeanings = data.meanings.filter(m => 
                        m.partOfSpeech === 'verb'
                    )[0] || data.meanings[0];

                    // Get academic context definition when possible
                    const academicDefinition = verbMeanings.definitions.find(d => 
                        d.definition.toLowerCase().includes('academic') ||
                        d.definition.toLowerCase().includes('study') ||
                        d.definition.toLowerCase().includes('research')
                    ) || verbMeanings.definitions[0];

                    return {
                        word: verb,
                        definition: academicDefinition.definition || 'No definition found',
                        example: academicDefinition.example || 'No example available',
                        partOfSpeech: 'verb',
                        context: 'academic',
                        usage: 'Commonly used in academic writing and research',
                        synonyms: (verbMeanings.synonyms || []).slice(0, 3)
                    };
                } catch (error) {
                    // Log error and return null for invalid verbs
                    console.log(`Error fetching verb "${verb}":`, error.message);
                    return null;
                }
            });
            
            const batchResults = await Promise.all(batchPromises);
            allVerbDetails.push(...batchResults.filter(verb => verb !== null));
            
            // Add delay between batches to avoid rate limiting
            if (i + batchSize < shuffledVerbs.length) {
                await new Promise(resolve => setTimeout(resolve, 1000));
            }
        }

        const validVerbs = allVerbDetails.filter(Boolean);

        if (validVerbs.length === 0) {
            return res.status(404).json({
                error: 'No valid academic verbs found. Please try again.'
            });
        }

        res.json(validVerbs);
    } catch (error) {
        console.error('Error in getRandomWords:', error);
        res.status(500).json({ 
            error: 'Failed to fetch academic verbs',
            details: error.message 
        });
    }
};

const searchWord = async (req, res) => {
    const { word } = req.params;
    
    try {
        res.header('Access-Control-Allow-Origin', '*');
        res.header('Access-Control-Allow-Methods', 'GET');
        res.header('Access-Control-Allow-Headers', 'Content-Type');

        if (!word || word.trim().length === 0) {
            return res.status(400).json({
                error: 'Please enter a valid word',
                word: ''
            });
        }

        const response = await axios.get(`https://api.dictionaryapi.dev/api/v2/entries/en/${word}`);
        const data = response.data[0];
        
        // Get all meanings
        const meanings = data.meanings || [];
        
        // Find academic/formal context definitions
        const academicMeaning = meanings.find(m => 
            m.definitions.some(d => 
                d.definition.toLowerCase().includes('academic') ||
                d.definition.toLowerCase().includes('scientific') ||
                d.definition.toLowerCase().includes('formal') ||
                d.definition.toLowerCase().includes('study') ||
                d.definition.toLowerCase().includes('research')
            )
        ) || meanings[0];

        // Get the most relevant definition
        const relevantDefinition = academicMeaning.definitions.find(d => 
            d.definition.toLowerCase().includes('academic') ||
            d.definition.toLowerCase().includes('scientific') ||
            d.definition.toLowerCase().includes('formal') ||
            d.definition.toLowerCase().includes('study') ||
            d.definition.toLowerCase().includes('research')
        ) || academicMeaning.definitions[0];

        const wordDetails = {
            word: data.word,
            phonetic: data.phonetic || '',
            definition: relevantDefinition.definition,
            example: relevantDefinition.example || 'No example available',
            partOfSpeech: academicMeaning.partOfSpeech,
            synonyms: (academicMeaning.synonyms || []).slice(0, 5),
            antonyms: (academicMeaning.antonyms || []).slice(0, 5),
            context: 'academic',
            usage: meanings.length > 1 ? 
                'This word has multiple meanings. Showing the most relevant academic usage.' : 
                'Common academic term'
        };
        
        res.json(wordDetails);
    } catch (error) {
        console.error('Error searching word:', error);
        
        // Handle specific error cases
        if (error.response?.status === 404) {
            res.status(404).json({
                error: 'Word not found in dictionary',
                word: word,
                suggestion: 'Please check the spelling or try another word'
            });
        } else if (error.code === 'ECONNABORTED') {
            res.status(408).json({
                error: 'Request timeout',
                word: word,
                suggestion: 'Please try again later'
            });
        } else {
            res.status(500).json({
                error: 'Failed to fetch word details',
                word: word,
                suggestion: 'Please try again later'
            });
        }
    }
};

module.exports = {
    getRandomWords,
    searchWord
}; 