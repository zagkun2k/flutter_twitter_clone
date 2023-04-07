import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';
import 'package:twitter_clone/features/explore/view/explore_view.dart';
import 'package:twitter_clone/features/explore/widgets/search_tile.dart';
import 'package:twitter_clone/features/notifications/view/notificaiton_view.dart';
import 'package:twitter_clone/features/tweet/views/create_tweet_view.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/view/user_profile_view.dart';
import 'package:twitter_clone/theme/pallete.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailProvider).value;
    if (currentUser == null) {
      return const Loader();
    }

    return SafeArea(
      child: Drawer(
        backgroundColor: Pallete.backgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: const Icon(
                Icons.person,
                size: 30,
              ),
              title: const Text(
                'My Profile',
                style: TextStyle(
                  // fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  UserProfileView.route(currentUser),
                );
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: SvgPicture.asset(
                AssetsConstants.twitterLogo,
                color: Pallete.whiteColor,
                height: 25,
              ),
              title: const Text(
                'Payment Blue',
                style: TextStyle(
                  // fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
              ),
              onTap: () {
                ref
                    .read(userProfileControllerProvider.notifier)
                    .updateUserProfile(
                      userModel: currentUser.copyWith(
                        isTwitterBlue: true,
                      ),
                      context: context,
                      bannerFile: null,
                      avatarFile: null,
                    );
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(
                Icons.post_add,
                size: 30,
              ),
              title: const Text(
                'Add Post',
                style: TextStyle(
                  // fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CreateTweetScreen.route(),
                );
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: SvgPicture.asset(
                AssetsConstants.searchIcon,
                color: Pallete.whiteColor,
                height: 25,
              ),
              title: const Text(
                'Search User',
                style: TextStyle(
                  // fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  ExploreView.route(),
                );
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: SvgPicture.asset(
                AssetsConstants.notifOutlinedIcon,
                color: Pallete.whiteColor,
                height: 25,
              ),
              title: const Text(
                'Notifications',
                style: TextStyle(
                  // fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  NotificationView.route(),
                );
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(
                Icons.settings,
                size: 30,
              ),
              title: const Text(
                'Settings',
                style: TextStyle(
                  // fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
              ),
              onTap: () {},
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  // fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
              ),
              onTap: () {
                // Navigator.push(
                //   context,
                //   LoginView.route(),
                // );
                ref.read(authControllerProvider.notifier).logOut(context);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
