// ChainLords MongoDB initialization script

db = db.getSiblingDB('chainlords');

// Create collections
db.createCollection('game_events');
db.createCollection('battle_logs');
db.createCollection('chat_messages');
db.createCollection('leaderboards');

// Create indexes
db.game_events.createIndex({ "timestamp": 1 });
db.game_events.createIndex({ "player_id": 1 });
db.battle_logs.createIndex({ "battle_id": 1 });
db.chat_messages.createIndex({ "created_at": -1 });
db.leaderboards.createIndex({ "score": -1 });

print("MongoDB initialization complete");
