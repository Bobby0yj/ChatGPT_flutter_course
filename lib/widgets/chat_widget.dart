import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt_course/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    Key? key,
    required this.msg,
    required this.chatIndex,
    this.shouldAnimate = false,
  }) : super(key: key);

  final String msg;
  final int chatIndex;
  final bool shouldAnimate;

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget>
    with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  bool isMicAnimating = false;
  late AnimationController micAnimationController;
  late Animation<double> micAnimation;
  TextEditingController textEditingController = TextEditingController();
  bool isEditing = false;
  Future<void> initializeTts() async {
    await flutterTts.setLanguage('en-US');
  }

  Future<void> speakText(String text) async {
    if (isSpeaking) {
      await flutterTts.stop();
      setState(() {
        isSpeaking = false;
        isMicAnimating = false;
      });
    } else {
      await flutterTts.speak(text);
      setState(() {
        isSpeaking = true;
        isMicAnimating = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.msg;
    initializeTts();
    micAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    micAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: micAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    micAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: widget.chatIndex == 0
              ? Color.fromARGB(255, 37, 37, 37)
              : const Color.fromARGB(255, 255, 253, 253),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    widget.chatIndex == 0
                        ? AssetsManager.userImage
                        : AssetsManager.botImage,
                    height: 30,
                    width: 30,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: widget.chatIndex == 0
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              isEditing = true;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(12),
                            child: isEditing
                                ? TextField(
                                    controller: textEditingController,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  )
                                : Text(
                                    widget.msg,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                          ),
                        )
                      : widget.shouldAnimate
                          ? GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  child: DefaultTextStyle(
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 15, 62, 27),
                                      fontSize: 16,
                                    ),
                                    child: AnimatedTextKit(
                                      isRepeatingAnimation: false,
                                      repeatForever: false,
                                      displayFullTextOnTap: true,
                                      totalRepeatCount: 1,
                                      animatedTexts: [
                                        TyperAnimatedText(
                                          widget.msg.trim(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {},
                              child: SelectableText(
                                widget.msg.trim().toString(),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 217, 38, 38),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                ),
                widget.chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              speakText(widget.msg.trim());
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              transform: Matrix4.identity()
                                ..scale(
                                    isMicAnimating ? micAnimation.value : 1.0),
                              child: Icon(
                                isSpeaking ? Icons.mic : Icons.mic_off,
                                color: isSpeaking
                                    ? Color.fromARGB(255, 5, 80, 4)
                                    : const Color.fromARGB(255, 97, 97, 97),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
