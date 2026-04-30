import 'package:e_chat/add_friend/add_friend.dart';
import 'package:e_chat/home_page/navigationdata.dart';
import 'package:e_chat/utilities/commonColors.dart';
import 'package:flutter/material.dart';

class ChatsHomePage extends StatefulWidget {
  const ChatsHomePage({super.key});

  @override
  State<ChatsHomePage> createState() => _ChatsHomePageState();
}

class _ChatsHomePageState extends State<ChatsHomePage> {
  int currentIndex = 0;
  String image = "assets/icons/cross_Icon.png";

  bool isOpened = true;

  final List<Widget> screens = [
    Center(child: chatData()),
    Center(child: Text("Groups Screen")),
    Center(child: Text("Profile Screen")),
    Center(child: Text("More Screen")),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 90),
            child: screens[currentIndex],
          ),

          topSection(),
        ],
      ),

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          showSelectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          showUnselectedLabels: false,
          items: NavigationData.getNavItems(context),
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
        ),
      ),
    );
  }

  Widget topSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Image.asset(
          "assets/images/chat_home_bg_lisght.png",
          width: double.infinity,
          height: 140,
          fit: BoxFit.cover,
        ),
        SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/main_e_chat_dark.png",
                  width: 100,
                  height: 40,
                ),
                const Spacer(),
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 10),
                    PopupMenuButton(

                      constraints: const BoxConstraints.tightFor(width: 330),

                      onOpened: () {
                        setState(() {
                          isOpened = !isOpened;
                        });
                      },
                      onCanceled: () {
                        setState(() {
                          isOpened = !isOpened;
                        });
                      },
                      icon: Image.asset(isOpened ? "assets/icons/plus_icon.png" : "assets/icons/cross_Icon.png",width: isOpened ?  18 : 30,),
                      offset: Offset(0, 50),

                      itemBuilder: (context) {
                        return <PopupMenuEntry<dynamic>>[
                          PopupMenuItem(

                            onTap: () {

                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddFriend(),));

                            },

                            child: Row(
                              children: [
                               Image.asset("assets/icons/addFreind_dark_icon.png", width: 24,height: 24,),
                                
                                
                                SizedBox(width: 16),

                                Text(
                                  "Add Friend",
                                  style: TextStyle(color: isDark?AppColors.backgroundLight:AppColors.backgroundDark,fontWeight: FontWeight.w500,fontSize: 18),
                                ),

                              ],
                            ),
                          ),

                          PopupMenuItem(
                            child: Row(
                              children: [
                                Image.asset("assets/icons/group_icon_inactive.png", width: 24,height: 24,),
                                SizedBox(width: 16),
                                Text(
                                  "Create Group",
                                  style: TextStyle(color: isDark?AppColors.backgroundLight:AppColors.backgroundDark,fontWeight: FontWeight.w500,fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
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

  static Widget chatData() {
    List<UserData> userdata = [
      UserData(
        name: "David Wayne",
        dateTime: "10:25",
        image: "assets/userImages/david_pic.png",
        msg: "Thanks a bunch! Have a great day! 😊",
        pendingMessageCount: "5",
      ),
      UserData(
        name: "Edward Davidson",
        dateTime: "22:20  09/05",
        image: "assets/userImages/Edward.png",
        msg: "Great, thanks so much! 💫",
        pendingMessageCount: "12",
      ),
      UserData(
        name: "Angela Kelly",
        dateTime: "10:45  08/05",
        image: "assets/userImages/angela.png",
        msg: "Appreciate it! See you soon! 🚀",
        pendingMessageCount: "1",
      ),
      UserData(
        name: "Jean Dare",
        dateTime: "20:10  05/05",
        image: "assets/userImages/Jean.png",
        msg: "Your order has been successfully delivered",
        pendingMessageCount: "",
      ),
      UserData(
        name: "Cayla Rath",
        dateTime: "11:20  05/05",
        image: "assets/userImages/Cayla.png",
        msg: "See you soon!",
        pendingMessageCount: "",
      ),
      UserData(
        name: "Cayla Rath",
        dateTime: "19:35  02/05",
        image: "assets/userImages/Erin.png",
        msg: "I'm ready to drop off your delivery. 👍",
        pendingMessageCount: "",
      ),
      UserData(
        name: "Cayla Rath",
        dateTime: "07:55  01/05",
        image: "assets/userImages/Rodolfo.png",
        msg: "Appreciate it! Hope you enjoy it!",
        pendingMessageCount: "",
      ),
    ];

    return ListView.builder(
      itemCount: userdata.length,

      itemBuilder: (context, index) {
        return userTile(user: userdata[index], context: context);
      },
    );
  }

  static Widget userTile({
    required UserData user,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: ClipOval(child: Image.asset(user.image!, width: 42, height: 42)),
      title: Text(
        user.name!,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: isDark
              ? AppColors.backgroundLight
              : AppColors.backgroundDark,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        user.msg!,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondaryDark,
          fontSize: 16,
        ),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            user.dateTime.toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryDark,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 10),
          user.pendingMessageCount.toString() != ""
              ? Container(
                  width: 16,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      user.pendingMessageCount.toString(),
                      style: TextStyle(
                        color: AppColors.backgroundLight,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class UserData {
  String? name;
  String? image;
  String? msg;
  String? dateTime;
  String? pendingMessageCount;

  UserData({
    required this.name,
    required this.msg,
    required this.dateTime,
    required this.image,
    required this.pendingMessageCount,
  });
}
