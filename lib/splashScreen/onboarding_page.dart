import 'package:e_chat/login_page/login_page.dart';
import 'package:e_chat/utilities/text_theme.dart';
import 'package:e_chat/utilities/commonColors.dart';
import 'package:e_chat/utilities/commonWidget.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;
  final introData = <Data>[
    Data(
      caption: "Connect with multiple members in group chats.",
      title: "Group Chatting",
      image: "assets/images/onboarding_image1.png",
    ),
    Data(
      caption: "Instantly connect via video and voice calls.",
      title: "Video and Voice Calls",
      image: "assets/images/onboarding_image2.png",
    ),
    Data(
      caption: "Ensure privacy with encrypted messages.",
      title: "Message Encryption",
      image: "assets/images/onboarding_image3.png",
    ),
    Data(
      caption: "Access chats on any device seamlessly.",
      title: "Cross-Platform Compatibility",
      image: "assets/images/onboarding_Image4.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.onboardingBgDark
          : AppColors.onboardingBg,

      body: Stack(
        children: [
          Positioned(
            top: -150,
            left: -150,
            child: Container(
              width: 700,
              height: 700,
              decoration: BoxDecoration(
                color: cs.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: cs.secondary.withOpacity(0.2),
                  width: 60,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 80),
                  SizedBox(
                    height: 360,
                    width: 345,
                    child: PageView(
                      controller: _controller,
                      onPageChanged: (value) {
                        setState(() {
                          currentIndex = value;
                        });
                      },
                      children: introData.map((e) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(e.image, width: 289.27, height: 140),
                            SizedBox(height: 60),
                            Text(
                              e.title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color:  cs.primary ,
                                  ),

                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12),
                            Text(
                              e.caption,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: cs.primary,
                                  ),

                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 100),
                  Spacer(),
                  CWidget.commonELBTNG(
                    color: cs.surface,
                    context,
                    onTap: () {
                      print("hi");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginPage();
                          },
                        ),
                      );
                    },
                    text: "Get started",
                    width: 360,
                    fontSize: 24,
                  ),




                  SizedBox(height: 70),




                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,

                            child: InkWell(
                              onTap: () {
                                _controller.jumpToPage(introData.length - 1);
                              },
                              child: Text(
                                "Skip",
                                style:Theme.of(context).textTheme.titleMedium?.copyWith(color: isDark? cs.primary:cs.secondary)
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Center(
                            child: Row(
                              children: List.generate(introData.length, (
                                index,
                              ) {
                                bool isActive = currentIndex == index;

                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  child: isActive
                                      ? Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isDark?AppColors.onboardingNextBtn.withOpacity(0.3):AppColors.primary.withOpacity(0.3),
                                          ),
                                          child: Container(
                                            width: 12,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isDark?AppColors.primary:cs.secondary,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isDark?AppColors.onboardingNextBtn: AppColors.primary,
                                          ),
                                        ),
                                );
                              }),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Align(
                            alignment: AlignmentGeometry.centerRight,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),

                              onTap: () {
                                if (currentIndex == introData.length - 1) {
                                  print("Navigate to next screen");
                                } else {
                                  _controller.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                }
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.onboardingNextBtn,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    "Next",
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.onboardingNextBtnText)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
