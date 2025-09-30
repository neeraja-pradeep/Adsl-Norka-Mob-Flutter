// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../utils/constants.dart';
// import '../../../widgets/app_text.dart';
// import '../../../services/chat_storage_service.dart';

// class LiveChatPage extends StatefulWidget {
//   const LiveChatPage({super.key});

//   @override
//   State<LiveChatPage> createState() => _LiveChatPageState();
// }

// class _LiveChatPageState extends State<LiveChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<ChatMessage> _messages = [];
//   bool _isTyping = false;
//   bool _isAgentOnline = true;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadChatHistory();
//   }

//   Future<void> _loadChatHistory() async {
//     try {
//       final savedMessages = await ChatStorageService.loadChatMessages();

//       if (savedMessages.isEmpty) {
//         // No saved messages, add welcome message
//         _addWelcomeMessage();
//       } else {
//         // Load saved messages
//         setState(() {
//           _messages.addAll(savedMessages.toList());
//         });

//         // Show a brief message that chat history was loaded
//       }
//     } catch (e) {
//       print('Error loading chat history: $e');
//       _addWelcomeMessage();
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _addWelcomeMessage() {
//     final welcomeMessage = ChatMessage(
//       text:
//           'Hello! Welcome to Norka Care customer support. How can I help you today?',
//       isUser: false,
//       timestamp: DateTime.now(),
//       agentName: 'Support Agent',
//     );

//     _messages.add(welcomeMessage);
//     ChatStorageService.addMessage(welcomeMessage);
//   }

//   void _sendMessage() async {
//     if (_messageController.text.trim().isEmpty) return;

//     final userMessage = _messageController.text.trim();
//     final userChatMessage = ChatMessage(
//       text: userMessage,
//       isUser: true,
//       timestamp: DateTime.now(),
//     );

//     _messages.add(userChatMessage);
//     await ChatStorageService.addMessage(userChatMessage);

//     _messageController.clear();
//     setState(() {});

//     // Simulate agent response
//     _simulateAgentResponse(userMessage);
//   }

//   void _simulateAgentResponse(String userMessage) {
//     setState(() {
//       _isTyping = true;
//     });

//     // Simulate typing delay
//     Future.delayed(const Duration(seconds: 2), () async {
//       String response = _getAutoResponse(userMessage);

//       final agentMessage = ChatMessage(
//         text: response,
//         isUser: false,
//         timestamp: DateTime.now(),
//         agentName: 'Support Agent',
//       );

//       _messages.add(agentMessage);
//       await ChatStorageService.addMessage(agentMessage);

//       setState(() {
//         _isTyping = false;
//       });

//       // Scroll to bottom
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (_scrollController.hasClients) {
//           _scrollController.animateTo(
//             _scrollController.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//           );
//         }
//       });
//     });
//   }

//   String _getAutoResponse(String userMessage) {
//     final message = userMessage.toLowerCase();

//     if (message.contains('claim') || message.contains('file')) {
//       return 'To file a claim, please go to the "My Claims" section in the app and tap "File New Claim". You\'ll need to provide relevant documents like medical bills and prescriptions.';
//     } else if (message.contains('policy') || message.contains('premium')) {
//       return 'You can view your policy details and premium information in the "My Policies" section. For policy modifications, please contact our support team.';
//     } else if (message.contains('family') || message.contains('member')) {
//       return 'To add family members, go to your profile and tap "Family Members", then "Add Family Member". You\'ll need to provide their details and documents.';
//     } else if (message.contains('payment') || message.contains('due')) {
//       return 'Payment due dates vary by policy. You can check your payment schedule in the "My Policies" section. For payment issues, please contact our billing department.';
//     } else if (message.contains('document') || message.contains('paper')) {
//       return 'Required documents typically include medical bills, prescriptions, discharge summaries, and policy documents. Specific requirements may vary based on your policy type.';
//     } else if (message.contains('time') ||
//         message.contains('duration') ||
//         message.contains('how long')) {
//       return 'Standard claims are processed within 7-14 business days. Complex cases may take longer. You can track your claim status in the app.';
//     } else {
//       return 'Thank you for your message. A support agent will review your query and get back to you shortly. For immediate assistance, you can also call us at +91-1800-123-4567.';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: isDarkMode
//           ? AppConstants.darkBackgroundColor
//           : AppConstants.whiteBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: isDarkMode
//             ? AppConstants.darkBackgroundColor
//             : AppConstants.whiteColor,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         surfaceTintColor: Colors.transparent,
//         leading: IconButton(
//           icon: Icon(
//             Theme.of(context).platform == TargetPlatform.iOS
//                 ? CupertinoIcons.back
//                 : Icons.arrow_back,
//             color: AppConstants.primaryColor,
//           ),
//           onPressed: () => Navigator.of(context).pop(),
//         ),

//         title: Row(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: AppConstants.primaryColor,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.support_agent,
//                 color: AppConstants.whiteColor,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppText(
//                     text: 'Live Chat Support',
//                     size: 16,
//                     weight: FontWeight.bold,
//                     textColor: AppConstants.primaryColor,
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         width: 8,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           color: _isAgentOnline
//                               ? AppConstants.greenColor
//                               : AppConstants.redColor,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       AppText(
//                         text: _isAgentOnline ? 'Online' : 'Offline',
//                         size: 12,
//                         weight: FontWeight.w500,
//                         textColor: _isAgentOnline
//                             ? AppConstants.greenColor
//                             : AppConstants.redColor,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.more_vert, color: AppConstants.primaryColor),
//             onPressed: () {
//               _showChatOptions();
//             },
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(color: AppConstants.primaryColor),
//                   const SizedBox(height: 16),
//                   AppText(
//                     text: 'Loading chat history...',
//                     size: 16,
//                     weight: FontWeight.w500,
//                     textColor: AppConstants.greyColor,
//                   ),
//                 ],
//               ),
//             )
//           : Column(
//               children: [
//                 // Chat messages
//                 Expanded(
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 16),
//                     child: ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       itemCount: _messages.length + (_isTyping ? 1 : 0),
//                       itemBuilder: (context, index) {
//                         if (index == _messages.length && _isTyping) {
//                           return _buildTypingIndicator(isDarkMode);
//                         }
//                         return _buildMessageBubble(
//                           _messages[index],
//                           isDarkMode,
//                         );
//                       },
//                     ),
//                   ),
//                 ),

//                 // Typing indicator
//                 if (_isTyping)
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: AppConstants.primaryColor,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.support_agent,
//                             color: AppConstants.whiteColor,
//                             size: 20,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         AppText(
//                           text: 'Support Agent is typing...',
//                           size: 14,
//                           weight: FontWeight.w500,
//                           textColor: AppConstants.greyColor,
//                         ),
//                       ],
//                     ),
//                   ),

//                 // Message input
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? AppConstants.boxBlackColor
//                         : AppConstants.whiteColor,
//                     border: Border(
//                       top: BorderSide(
//                         color: isDarkMode
//                             ? Colors.white.withOpacity(0.1)
//                             : Colors.grey.withOpacity(0.2),
//                         width: 1,
//                       ),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: isDarkMode
//                                 ? Colors.grey.withOpacity(0.1)
//                                 : Colors.grey.withOpacity(0.05),
//                             borderRadius: BorderRadius.circular(24),
//                             border: Border.all(
//                               color: isDarkMode
//                                   ? Colors.white.withOpacity(0.1)
//                                   : Colors.grey.withOpacity(0.2),
//                               width: 1,
//                             ),
//                           ),
//                           child: TextField(
//                             controller: _messageController,
//                             decoration: InputDecoration(
//                               hintText: 'Type your message...',
//                               hintStyle: TextStyle(
//                                 color: AppConstants.greyColor,
//                                 fontSize: 14,
//                               ),
//                               border: InputBorder.none,
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 12,
//                               ),
//                             ),
//                             maxLines: null,
//                             textCapitalization: TextCapitalization.sentences,
//                             onSubmitted: (_) => _sendMessage(),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       GestureDetector(
//                         onTap: _sendMessage,
//                         child: Container(
//                           width: 48,
//                           height: 48,
//                           decoration: BoxDecoration(
//                             color: AppConstants.primaryColor,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.send,
//                             color: AppConstants.whiteColor,
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _buildMessageBubble(ChatMessage message, bool isDarkMode) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         mainAxisAlignment: message.isUser
//             ? MainAxisAlignment.end
//             : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (!message.isUser) ...[
//             Container(
//               width: 32,
//               height: 32,
//               decoration: BoxDecoration(
//                 color: AppConstants.primaryColor,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.support_agent,
//                 color: AppConstants.whiteColor,
//                 size: 16,
//               ),
//             ),
//             const SizedBox(width: 8),
//           ],
//           Flexible(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: message.isUser
//                     ? AppConstants.primaryColor
//                     : (isDarkMode
//                           ? AppConstants.boxBlackColor
//                           : AppConstants.whiteColor),
//                 borderRadius: BorderRadius.circular(16).copyWith(
//                   bottomLeft: message.isUser
//                       ? const Radius.circular(16)
//                       : const Radius.circular(4),
//                   bottomRight: message.isUser
//                       ? const Radius.circular(4)
//                       : const Radius.circular(16),
//                 ),
//                 border: !message.isUser
//                     ? Border.all(
//                         color: isDarkMode
//                             ? Colors.white.withOpacity(0.1)
//                             : Colors.grey.withOpacity(0.2),
//                         width: 1,
//                       )
//                     : null,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (!message.isUser && message.agentName != null) ...[
//                     AppText(
//                       text: message.agentName!,
//                       size: 12,
//                       weight: FontWeight.w600,
//                       textColor: AppConstants.primaryColor,
//                     ),
//                     const SizedBox(height: 4),
//                   ],
//                   AppText(
//                     text: message.text,
//                     size: 14,
//                     weight: FontWeight.normal,
//                     textColor: message.isUser
//                         ? AppConstants.whiteColor
//                         : (isDarkMode
//                               ? AppConstants.whiteColor
//                               : AppConstants.blackColor),
//                   ),
//                   const SizedBox(height: 4),
//                   AppText(
//                     text: _formatTime(message.timestamp),
//                     size: 10,
//                     weight: FontWeight.w500,
//                     textColor: message.isUser
//                         ? AppConstants.whiteColor.withOpacity(0.7)
//                         : AppConstants.greyColor,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (message.isUser) ...[
//             const SizedBox(width: 8),
//             Container(
//               width: 32,
//               height: 32,
//               decoration: BoxDecoration(
//                 color: AppConstants.primaryColor.withOpacity(0.1),
//                 shape: BoxShape.circle,
//                 border: Border.all(color: AppConstants.primaryColor, width: 1),
//               ),
//               child: Icon(
//                 Icons.person,
//                 color: AppConstants.primaryColor,
//                 size: 16,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildTypingIndicator(bool isDarkMode) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         children: [
//           Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               color: AppConstants.primaryColor,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.support_agent,
//               color: AppConstants.whiteColor,
//               size: 16,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               color: isDarkMode
//                   ? AppConstants.boxBlackColor
//                   : AppConstants.whiteColor,
//               borderRadius: BorderRadius.circular(16).copyWith(
//                 bottomRight: const Radius.circular(16),
//                 bottomLeft: const Radius.circular(4),
//               ),
//               border: Border.all(
//                 color: isDarkMode
//                     ? Colors.white.withOpacity(0.1)
//                     : Colors.grey.withOpacity(0.2),
//                 width: 1,
//               ),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildTypingDot(0),
//                 const SizedBox(width: 4),
//                 _buildTypingDot(1),
//                 const SizedBox(width: 4),
//                 _buildTypingDot(2),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTypingDot(int index) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: Duration(milliseconds: 600 + (index * 200)),
//       builder: (context, value, child) {
//         return Container(
//           width: 8,
//           height: 8,
//           decoration: BoxDecoration(
//             color: AppConstants.primaryColor.withOpacity(0.3 + (value * 0.7)),
//             shape: BoxShape.circle,
//           ),
//         );
//       },
//       onEnd: () {
//         if (mounted) {
//           setState(() {});
//         }
//       },
//     );
//   }

//   String _formatTime(DateTime timestamp) {
//     final now = DateTime.now();
//     final difference = now.difference(timestamp);

//     if (difference.inMinutes < 1) {
//       return 'Just now';
//     } else if (difference.inMinutes < 60) {
//       return '${difference.inMinutes}m ago';
//     } else if (difference.inHours < 24) {
//       return '${difference.inHours}h ago';
//     } else {
//       return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
//     }
//   }

//   void _showChatOptions() {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           decoration: BoxDecoration(
//             color: isDarkMode
//                 ? AppConstants.boxBlackColor
//                 : AppConstants.whiteColor,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 margin: const EdgeInsets.only(top: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ListTile(
//                 leading: Icon(
//                   Icons.clear_all,
//                   color: AppConstants.primaryColor,
//                 ),
//                 title: AppText(
//                   text: 'Clear Chat',
//                   size: 16,
//                   weight: FontWeight.w500,
//                   textColor: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _clearChat();
//                 },
//               ),

//               ListTile(
//                 leading: Icon(Icons.phone, color: AppConstants.primaryColor),
//                 title: AppText(
//                   text: 'Call Support',
//                   size: 16,
//                   weight: FontWeight.w500,
//                   textColor: isDarkMode
//                       ? AppConstants.whiteColor
//                       : AppConstants.blackColor,
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _launchPhoneCall();
//                 },
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _clearChat() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//         return AlertDialog(
//           backgroundColor: isDarkMode
//               ? AppConstants.boxBlackColor
//               : AppConstants.whiteColor,
//           title: AppText(
//             text: 'Clear Chat',
//             size: 18,
//             weight: FontWeight.bold,
//             textColor: isDarkMode
//                 ? AppConstants.whiteColor
//                 : AppConstants.blackColor,
//           ),
//           content: AppText(
//             text: 'Are you sure you want to clear all chat messages?',
//             size: 14,
//             weight: FontWeight.normal,
//             textColor: AppConstants.greyColor,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: AppText(
//                 text: 'Cancel',
//                 size: 14,
//                 weight: FontWeight.w500,
//                 textColor: AppConstants.greyColor,
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 Navigator.pop(context);
//                 await ChatStorageService.clearChatMessages();
//                 setState(() {
//                   _messages.clear();
//                   _addWelcomeMessage();
//                 });
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppConstants.primaryColor,
//               ),
//               child: AppText(
//                 text: 'Clear',
//                 size: 14,
//                 weight: FontWeight.w500,
//                 textColor: AppConstants.whiteColor,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _launchPhoneCall() async {
//     const phoneNumber = '+91-1800-123-4567';
//     final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(phoneUri)) {
//       await launchUrl(phoneUri);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Could not launch phone dialer')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
