import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'hex_color.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  bool isLoading = false;

  OverlayEntry? _overlayEntry;
  final GlobalKey _fabKey = GlobalKey();

  final emailRegex =
  RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b');

  void _showAttachedWindow() {
    final RenderBox renderBox = _fabKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        right: MediaQuery.of(context).size.width - position.dx + 5,
        bottom: MediaQuery.of(context).size.height - position.dy + 5,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 350,
            height: 400,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 310,
                    child: _chatMessages()),
                SizedBox(
                    height: 50,
                    child: _inputField()),
              ],
            ),
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
  }

  void _hideAttachedWindow() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  void _refreshOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text('MIDC CHATBOT', style: TextStyle(),)),
      ),
      floatingActionButton: FloatingActionButton(
        key: _fabKey,
        onPressed: () {
          if (_overlayEntry == null) {
            _showAttachedWindow();
          } else {
            _hideAttachedWindow();
          }
        },
        child: Icon(_overlayEntry == null ? Icons.message : Icons.close),
      ),
    );
  }

  Widget _chatMessages() {
    return messages.isEmpty
        ? Center(
      child: Text(
        'How can I help you today?',
        style: TextStyle(
            fontFamily: "Roboto",
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: HexColor('#222222')),
      ),
    )
        : ListView.builder(
        controller: _scrollController,
        itemCount: messages.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == messages.length && isLoading) {
            return Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Image.asset(
                  //   "assets/images/orient_logo.png",
                  //   height: 36,
                  //   width: 36,
                  // ),
                  const SizedBox(
                    width: 6,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: const LoadingIndicator(
                          indicatorType: Indicator.ballPulse,
                          colors: [Colors.grey],
                          strokeWidth: 8,
                        ),
                      )),
                ],
              ),
            );
          }
          final message = messages[index];
          return Column(
            children: [
              Container(
                // color: Colors.red,
                margin: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 0),
                alignment: message['role'] == 'user'
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: message['role'] == 'user'
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message['role'] == 'bot')
                      // Image.asset(
                      //   "assets/images/orient_logo.png",
                      //   height: 36,
                      //   width: 36,
                      // ),
                    if (message['role'] == 'bot')
                      const SizedBox(
                        width: 6,
                      ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                            color: message['role'] == 'user'
                                ? HexColor('#E9E9EB')
                                : HexColor('#F9F9F9'),
                            // : Colors.amber,
                            borderRadius: message['role'] == 'user'
                                ? BorderRadius.circular(8)
                                : BorderRadius.circular(8),
                            border: message['role'] == 'user'
                                ? Border.all(
                                width: 1, color: HexColor('#E9E9EB'))
                                : null),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SelectableText.rich(
                              TextSpan(
                                children: _processMessage(
                                    message['message'] ?? ''),
                              ),
                            ),
                            message['role'] == 'bot'
                                ? const SizedBox(
                              height: 16,
                            )
                                : const SizedBox(),
                            message['role'] == 'bot'
                                ? Row(
                              children: [
                                // GestureDetector(
                                //   child: Image.asset(
                                //     "assets/images/copy.png",
                                //     height: 24,
                                //     width: 24,
                                //     color: HexColor('#222222'),
                                //   ),
                                //   onTap: () {
                                //     _copyToClipboard(context,
                                //         message['message'] ?? '');
                                //   },
                                // ),
                                // const SizedBox(
                                //   width: 6,
                                // ),
                                // GestureDetector(
                                //   onTap: () {
                                //     final documents = json.decode(
                                //         message['documents'] ??
                                //             "[]");
                                //     showDialog(
                                //       context: context,
                                //       builder:
                                //           (BuildContext context) {
                                //         return Dialog(
                                //           shape:
                                //           RoundedRectangleBorder(
                                //             borderRadius:
                                //             BorderRadius
                                //                 .circular(8),
                                //           ),
                                //           child: SizedBox(
                                //             width: 612,
                                //             // width: MediaQuery.of(
                                //             //             context)
                                //             //         .size
                                //             //         .width *
                                //             //     0.4, // Set a fixed width
                                //             child: Padding(
                                //               padding:
                                //               const EdgeInsets
                                //                   .all(20),
                                //               child: Column(
                                //                 mainAxisSize:
                                //                 MainAxisSize
                                //                     .min,
                                //                 // Ensures the dialog takes up only as much space as needed
                                //                 children: [
                                //                   Padding(
                                //                     padding:
                                //                     const EdgeInsets
                                //                         .only(
                                //                         left:
                                //                         10,
                                //                         right:
                                //                         10,
                                //                         top: 12,
                                //                         bottom:
                                //                         24),
                                //                     child: Row(
                                //                       children: [
                                //                         Text(
                                //                           'Uploaded Documents',
                                //                           style: TextStyle(
                                //                               fontFamily:
                                //                               "Roboto",
                                //                               fontSize:
                                //                               16,
                                //                               fontWeight: FontWeight
                                //                                   .w500,
                                //                               color:
                                //                               HexColor('#222222')),
                                //                         ),
                                //                         const Spacer(),
                                //                         GestureDetector(
                                //                           onTap:
                                //                               () {
                                //                             Navigator.of(context)
                                //                                 .pop();
                                //                           },
                                //                           // child: Image
                                //                           //     .asset(
                                //                           //   "assets/images/close-circle.png",
                                //                           //   height:
                                //                           //   24,
                                //                           //   width:
                                //                           //   24,
                                //                           // ),
                                //                         )
                                //                       ],
                                //                     ),
                                //                   ),
                                //                   DottedLine(
                                //                     dashColor: HexColor(
                                //                         '#222222')
                                //                         .withOpacity(
                                //                         0.12),
                                //                   ),
                                //                   ConstrainedBox(
                                //                     constraints:
                                //                     BoxConstraints(
                                //                       maxHeight: MediaQuery.of(
                                //                           context)
                                //                           .size
                                //                           .height *
                                //                           0.4, // Set a max height
                                //                     ),
                                //                     child: ListView
                                //                         .builder(
                                //                       shrinkWrap:
                                //                       true,
                                //                       itemCount:
                                //                       documents
                                //                           .length,
                                //                       itemBuilder:
                                //                           (BuildContext
                                //                       context,
                                //                           int index) {
                                //                         final document =
                                //                         documents[
                                //                         index];
                                //                         return ExpansionTile(
                                //                           title:
                                //                           Text(
                                //                             'Source ${index + 1}',
                                //                             style:
                                //                             TextStyle(
                                //                               color:
                                //                               HexColor('#222222'),
                                //                               fontFamily:
                                //                               "Roboto",
                                //                               fontSize:
                                //                               14,
                                //                               fontWeight:
                                //                               FontWeight.w400,
                                //                             ),
                                //                           ),
                                //                           children: [
                                //                             Padding(
                                //                               padding: const EdgeInsets
                                //                                   .all(
                                //                                   16.0),
                                //                               child:
                                //                               Column(
                                //                                 crossAxisAlignment:
                                //                                 CrossAxisAlignment.start,
                                //                                 children: [
                                //                                   Text(
                                //                                     'Content:',
                                //                                     style: TextStyle(
                                //                                       fontWeight: FontWeight.bold,
                                //                                       color: HexColor('#222222'),
                                //                                     ),
                                //                                   ),
                                //                                   const SizedBox(height: 8),
                                //                                   Text(
                                //                                     document['excerpt'] ?? 'No content available',
                                //                                     style: TextStyle(
                                //                                       color: HexColor('#222222'),
                                //                                     ),
                                //                                   ),
                                //                                   const SizedBox(height: 16),
                                //                                   Text(
                                //                                     'Source:',
                                //                                     style: TextStyle(
                                //                                       fontWeight: FontWeight.bold,
                                //                                       color: HexColor('#222222'),
                                //                                     ),
                                //                                   ),
                                //                                   const SizedBox(height: 8),
                                //                                   GestureDetector(
                                //                                     onTap: () async {
                                //                                       // final url = document['document_name'];
                                //                                       // _launchInBrowser(url);
                                //                                     },
                                //                                     child: Text(
                                //                                       document['document_name'] ?? 'No source available',
                                //                                       style: TextStyle(
                                //                                         color: HexColor('#00A3E4'),
                                //                                         decoration: TextDecoration.underline,
                                //                                       ),
                                //                                     ),
                                //                                   ),
                                //                                 ],
                                //                               ),
                                //                             ),
                                //                           ],
                                //                         );
                                //                       },
                                //                     ),
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //         );
                                //       },
                                //     );
                                //   },
                                // //   child: Image.asset(
                                // //     "assets/images/info_circle.png",
                                // //     height: 24,
                                // //     width: 24,
                                // //     color: HexColor('#222222'),
                                // //   ),
                                // // ),
                                // // const SizedBox(
                                // //   width: 12,
                                // // ),
                                // // GestureDetector(
                                // //   onTap: () {
                                // //     // var speech =
                                // //     //     message['message'] ?? '';
                                // //     // _readColorName(speech);
                                // //   },
                                // //   child: Image.asset(
                                // //     "assets/images/speak.png",
                                // //     height: 24,
                                // //     width: 24,
                                // //     color: HexColor('#222222'),
                                // //   ),
                                // )
                              ],
                            )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (message['showRegenerate'] == true)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "There was an error in generating a response.",
                      style: TextStyle(
                          color: HexColor('#222222'),
                          fontFamily: "Roboto",
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Call sendMessage with the previous message to regenerate
                        sendMessage(message['originalMessage']);
                      },
                      child: Container(
                        // height: 20,
                          width: MediaQuery.of(context).size.width * 0.1,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              color: HexColor('#00A3E4'),
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Regenerate',
                                style: TextStyle(
                                    color: HexColor('#FFFFFF'),
                                    fontFamily: "Roboto",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              // Image.asset(
                              //   "assets/images/repeate_music.png",
                              //   height: 20,
                              //   width: 20,
                              // )
                            ],
                          )),
                    ),
                  ],
                ),
            ],
          );
        },
      // ),
    );
  }

  Widget _inputField() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 56,
      child: TextFormField(
        controller: _controller,
        cursorColor: Colors.black54,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: (){
                if (_controller.text.trim().isNotEmpty) {
                  sendMessage(_controller.text.trim());
                }
              },
              icon: Icon(Icons.send, color: HexColor('#222222'))),
          hintStyle: TextStyle(
              fontFamily: "Roboto",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: HexColor('#222222').withOpacity(0.4)),
          hintText: 'Enter your message here',
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor('#F3F3F3')),
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor('#F3F3F3')),
              borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: HexColor('#F3F3F3'),
          hoverColor: HexColor('#F3F3F3'),
        ),
        onFieldSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            sendMessage(value.trim());
          }
        },
      ),
    );
  }

  List<TextSpan> _processMessage(String message) {
    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    // Find all matches of the email in the message
    final matches = emailRegex.allMatches(message);

    for (final match in matches) {
      final email = match.group(0) ?? '';

      // Add text before the match (if any)
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: message.substring(lastMatchEnd, match.start),
          style: TextStyle(
              color: HexColor('#222222'),
              fontFamily: "Roboto",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5),
        ));
      }

      // Add the clickable email
      spans.add(TextSpan(
        text: email,
        style: TextStyle(
            color: HexColor('#222222'),
            fontFamily: "Roboto",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.underline,
            height: 1.5),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            print('Clicked email: $email');
            // String? result = await showDialog<String>(
            //   context: context,
            //   builder: (context) {
            //     return EmailDialog(toEmail: email);
            //   },
            // );
            // if (result != null) {
            //   setState(() {
            //     emailSentStatus = result; // Update the status here
            //   });
            // }
          },
      ));

      // Update the end position of the last match
      lastMatchEnd = match.end;
    }

    // Add the remaining text after the last match
    if (lastMatchEnd < message.length) {
      spans.add(TextSpan(
        text: message.substring(lastMatchEnd),
        style: TextStyle(
            color: HexColor('#222222'),
            fontFamily: "Roboto",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5),
      ));
    }

    return spans;
  }

  Future<void> sendMessage(String message) async {
    // First, add the user's message to the UI
    setState(() {
      isLoading = true;
      messages.add({'role': 'user', 'message': message});
    });

    // Then, clear the text field
    _controller.clear();

    final url = Uri.parse(
        'https://i6ky2vvv41.execute-api.ap-south-1.amazonaws.com/dev/invoke');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "queryStringParameters": {"query": message},
        }),
      );

      final responseData = json.decode(response.body);
      final responseBody = json.decode(responseData['body']);

      print(responseBody);

      if (response.statusCode == 200) {
        setState(() {
          messages.add({
            'role': 'bot',
            'message': responseBody['answer'],
            'documents': json.encode(responseBody['citations']),
            'showRegenerate': false, // Hide regenerate button
            'originalMessage': message,
          });
          isLoading = false;
        });
        _refreshOverlay();
      } else {
        setState(() {
          messages.add({
            'role': 'bot',
            'message': 'Error: Unable to get response from the server.',
            'showRegenerate': true, // Show regenerate button
            'originalMessage': message,
          });
          isLoading = false;
          Future.delayed(Duration(milliseconds: 100), () {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          });
        });
        _refreshOverlay();
      }
    } catch (error) {
      setState(() {
        messages.add({
          'role': 'bot',
          'message': 'Error: Something went wrong. Please try again later.',
          'showRegenerate': true, // Show regenerate button
        });
        isLoading = false;
        Future.delayed(Duration(milliseconds: 100), () {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      });
      _refreshOverlay();
    }
  }

}
