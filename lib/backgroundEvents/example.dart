// import 'package:flutter/material.dart';

// class SSEConnectionPage extends StatefulWidget {
//   @override
//   _SSEConnectionPageState createState() => _SSEConnectionPageState();
// }

// class _SSEConnectionPageState extends State<SSEConnectionPage> {
//   final ServerSideEventService _sseService = ServerSideEventService();
//   List<String> _receivedEvents = [];

//   @override
//   void initState() {
//     super.initState();
//     _initializeSSEConnection();
//   }

//   void _initializeSSEConnection() {
//     // Replace with your actual SSE endpoint
//     const String sseUrl = 'https://your-sse-endpoint.com/events';

//     // Connect to SSE
//     _sseService.connectToServerSentEvents(sseUrl);

//     // Start background connection
//     _sseService.startBackgroundConnection(sseUrl);

//     // Listen to events
//     _sseService.eventStream.listen((event) {
//       setState(() {
//         _receivedEvents.add(event);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Server-Side Events')),
//       body: ListView.builder(
//         itemCount: _receivedEvents.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(_receivedEvents[index]),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _sseService.dispose();
//     super.dispose();
//   }
// }
