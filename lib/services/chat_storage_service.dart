// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class ChatMessage {
//   final String text;
//   final bool isUser;
//   final DateTime timestamp;
//   final String? agentName;

//   ChatMessage({
//     required this.text,
//     required this.isUser,
//     required this.timestamp,
//     this.agentName,
//   });

//   // Convert ChatMessage to JSON for storage
//   Map<String, dynamic> toJson() {
//     return {
//       'text': text,
//       'isUser': isUser,
//       'timestamp': timestamp.toIso8601String(),
//       'agentName': agentName,
//     };
//   }

//   // Create ChatMessage from JSON
//   factory ChatMessage.fromJson(Map<String, dynamic> json) {
//     return ChatMessage(
//       text: json['text'],
//       isUser: json['isUser'],
//       timestamp: DateTime.parse(json['timestamp']),
//       agentName: json['agentName'],
//     );
//   }
// }

// class ChatStorageService {
//   static const String _chatKey = 'chat_messages';
//   static const String _lastChatDateKey = 'last_chat_date';

//   // Save chat messages to local storage
//   static Future<void> saveChatMessages(List<ChatMessage> messages) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final messagesJson = messages.map((msg) => msg.toJson()).toList();
//       await prefs.setString(_chatKey, jsonEncode(messagesJson));

//       // Save the current date for chat history management
//       final now = DateTime.now();
//       await prefs.setString(_lastChatDateKey, now.toIso8601String());
//     } catch (e) {
//       print('Error saving chat messages: $e');
//     }
//   }

//   // Load chat messages from local storage
//   static Future<List<ChatMessage>> loadChatMessages() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final messagesString = prefs.getString(_chatKey);

//       if (messagesString != null) {
//         final messagesJson = jsonDecode(messagesString) as List;
//         return messagesJson.map((json) => ChatMessage.fromJson(json)).toList();
//       }
//     } catch (e) {
//       print('Error loading chat messages: $e');
//     }

//     return [];
//   }

//   // Add a single message to storage
//   static Future<void> addMessage(ChatMessage message) async {
//     try {
//       final messages = await loadChatMessages();
//       messages.add(message);
//       await saveChatMessages(messages);
//     } catch (e) {
//       print('Error adding message: $e');
//     }
//   }

//   // Clear all chat messages
//   static Future<void> clearChatMessages() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove(_chatKey);
//       await prefs.remove(_lastChatDateKey);
//     } catch (e) {
//       print('Error clearing chat messages: $e');
//     }
//   }

//   // Get the last chat date
//   static Future<DateTime?> getLastChatDate() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final dateString = prefs.getString(_lastChatDateKey);
//       if (dateString != null) {
//         return DateTime.parse(dateString);
//       }
//     } catch (e) {
//       print('Error getting last chat date: $e');
//     }
//     return null;
//   }

//   // Check if chat messages exist for today
//   static Future<bool> hasTodayChat() async {
//     try {
//       final lastDate = await getLastChatDate();
//       if (lastDate != null) {
//         final now = DateTime.now();
//         return lastDate.year == now.year &&
//             lastDate.month == now.month &&
//             lastDate.day == now.day;
//       }
//     } catch (e) {
//       print('Error checking today chat: $e');
//     }
//     return false;
//   }

//   // Get chat messages for a specific date
//   static Future<List<ChatMessage>> getChatMessagesForDate(DateTime date) async {
//     try {
//       final messages = await loadChatMessages();
//       return messages.where((msg) {
//         return msg.timestamp.year == date.year &&
//             msg.timestamp.month == date.month &&
//             msg.timestamp.day == date.day;
//       }).toList();
//     } catch (e) {
//       print('Error getting chat messages for date: $e');
//     }
//     return [];
//   }

//   // Export chat messages as JSON string
//   static Future<String> exportChatMessages() async {
//     try {
//       final messages = await loadChatMessages();
//       final messagesJson = messages.map((msg) => msg.toJson()).toList();
//       return jsonEncode(messagesJson);
//     } catch (e) {
//       print('Error exporting chat messages: $e');
//       return '[]';
//     }
//   }

//   // Get chat statistics
//   static Future<Map<String, dynamic>> getChatStatistics() async {
//     try {
//       final messages = await loadChatMessages();
//       final userMessages = messages.where((msg) => msg.isUser).length;
//       final agentMessages = messages.where((msg) => !msg.isUser).length;
//       final totalMessages = messages.length;

//       return {
//         'totalMessages': totalMessages,
//         'userMessages': userMessages,
//         'agentMessages': agentMessages,
//         'lastMessageDate': messages.isNotEmpty ? messages.last.timestamp : null,
//       };
//     } catch (e) {
//       print('Error getting chat statistics: $e');
//       return {
//         'totalMessages': 0,
//         'userMessages': 0,
//         'agentMessages': 0,
//         'lastMessageDate': null,
//       };
//     }
//   }
// }
