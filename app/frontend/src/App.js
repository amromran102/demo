import React, { useState, useEffect } from 'react';

function App() {
  const [messages, setMessages] = useState([]);
  const [newMessage, setNewMessage] = useState('');

  // Fetch messages on mount
  useEffect(() => {
    fetch('/api/messages')
      .then(res => res.json())
      .then(data => setMessages(data))
      .catch(err => console.error('Error fetching messages'));
  }, []);

  // Handle message submission
  const handleSubmit = async (e) => {
    e.preventDefault();
    await fetch('/api/messages', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ content: newMessage }),
    });
    // Refresh messages
    const res = await fetch('/api/messages');
    setMessages(await res.json());
    setNewMessage('');
  };

  return (
    <div style={{ padding: '20px' }}>
      <h1>Sample App</h1>
      <h2>Messages</h2>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={newMessage}
          onChange={(e) => setNewMessage(e.target.value)}
          placeholder="Enter a message"
          required
        />
        <button type="submit">Submit</button>
      </form>
      <ul>
        {messages.map(msg => (
          <li key={msg.id}>{msg.content} <em>({new Date(msg.created_at).toLocaleString()})</em></li>
        ))}
      </ul>
    </div>
  );
}

export default App;