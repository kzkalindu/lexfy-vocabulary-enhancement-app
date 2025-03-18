class ConversationManager {
  constructor() {
    this.conversations = new Map();
  }

  initializeConversation(userId, roleDescription) {
    this.conversations.set(userId, [{
      role: "system",
      content: `You are ${roleDescription}. Stay in character and respond professionally. Keep your responses concise and focused, ideally within 2-3 sentences.`
    }]);
    return this.conversations.get(userId);
  }

  addMessage(userId, role, content, roleDescription) {
    if (!this.conversations.has(userId)) {
      const roleDesc = roleDescription || "a helpful assistant"; // Ensure a valid role
      this.initializeConversation(userId, roleDesc);
    }
    this.conversations.get(userId).push({ role, content });

    // Keep last 10 exchanges + system message
    const conversation = this.conversations.get(userId);
    if (conversation.length > 11) {
      conversation.splice(1, conversation.length - 11);
    }
    return conversation;
  }

  getConversation(userId) {
    return this.conversations.get(userId) || [];
  }

  resetConversation(userId) {
    this.conversations.delete(userId);
  }
}

export const conversationManager = new ConversationManager();