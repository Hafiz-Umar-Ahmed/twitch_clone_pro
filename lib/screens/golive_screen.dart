import 'dart:typed_data' as unit;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:twitch_clone_pro/utils/colors.dart';
import 'package:twitch_clone_pro/utils/utils.dart';
import 'package:twitch_clone_pro/widgets/custom_Button.dart';
import 'package:twitch_clone_pro/widgets/custom_textfield.dart';

class GoLiveScreen extends StatefulWidget {
  const GoLiveScreen({super.key});

  @override
  State<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  final TextEditingController _controller = TextEditingController();
  unit.Uint8List? image;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    unit.Uint8List? pickedImage = await imagePicker();
                    if (pickedImage != null) {
                      setState(() {
                        image = pickedImage;
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: image != null
                        ? SizedBox(height: 300, child: Image.memory(image!))
                        : DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              radius: Radius.circular(20),
                              dashPattern: [10, 10],
                              strokeWidth: 2,
                              color: buttonColor,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: buttonColor.withOpacity(0.2),
                              ),
                              height: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      color: buttonColor,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 15,
                                    ),
                                    Text(
                                      'Select your Thumbnail',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Title',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomTextField(customController: _controller),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 22, vertical: 10),
            child: custombutton(
              text: 'Go Live!',
              onTap: () {},
              color: buttonColor,
              textColor: backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
