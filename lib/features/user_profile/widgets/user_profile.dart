import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/view/edit_profile_view.dart';
import 'package:twitter_clone/features/user_profile/widgets/follow_count.dart';
import 'package:twitter_clone/models/models.dart';
import 'package:twitter_clone/theme/pallete.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;

  const UserProfile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailProvider).value;
    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: user.bannerPic.isEmpty
                            ? Container(
                                color: Pallete.greyColor,
                              )
                            : Image.network(
                                user.bannerPic,
                                fit: BoxFit.fitWidth,
                              ),
                      ),
                      Positioned(
                        left: 5,
                        bottom: 3,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                          radius: 35.0,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.only(
                          right: 15,
                          bottom: 5,
                        ),
                        child: OutlinedButton(
                          onPressed: () {
                            if (currentUser.uid == user.uid) {
                              Navigator.push(context, EditProfileView.route());
                            } else {
                              ref
                                  .read(userProfileControllerProvider.notifier)
                                  .followUser(
                                    user: user,
                                    context: context,
                                    currentUser: currentUser,
                                  );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: const BorderSide(
                                color: Pallete.whiteColor,
                                width: 1.5,
                              ),
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                          ),
                          child: Text(
                            currentUser.uid == user.uid
                                ? 'Edit Profile'
                                : currentUser.following.contains(user.uid)
                                    ? 'Unfollow'
                                    : 'Follow',
                            style: const TextStyle(
                              color: Pallete.whiteColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (user.isTwitterBlue)
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: SvgPicture.asset(
                                  AssetsConstants.verifiedIcon,
                                ),
                              ),
                          ],
                        ),
                        Text(
                          '@${user.name}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Pallete.greyColor,
                          ),
                        ),
                        Text(
                          user.bio,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 13),
                        Row(
                          children: [
                            FollowCount(
                              count: user.following.length,
                              text: 'Following',
                            ),
                            const SizedBox(width: 15.0),
                            FollowCount(
                              count: user.followers.length,
                              text: 'Followers',
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Divider(
                          color: Pallete.whiteColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: ref.watch(getUserTweetsProvider(user.uid)).when(
                  data: (tweets) {
                    // return ref.watch(getLatestTweetProvider).when(
                    //       data: (data) {
                    //         final latestTweet = Tweet.fromMap(data.payload);
                    //         bool isTweetAlreadyPresent = false;
                    //
                    //         for (final tweetModel in tweets) {
                    //           if (tweetModel.id == latestTweet.id) {
                    //             isTweetAlreadyPresent = true;
                    //             break;
                    //           }
                    //         }
                    //
                    //         if (!isTweetAlreadyPresent) {
                    //           if (data.events.contains(
                    //               'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create')) {
                    //             // print(data.events[0]);
                    //             tweets.insert(0, Tweet.fromMap(data.payload));
                    //           } else if (data.events.contains(
                    //             'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update',
                    //           )) {
                    //             // get id of original tweet
                    //             final startingPoint =
                    //                 data.events[0].lastIndexOf('documents.');
                    //             final endPoint =
                    //                 data.events[0].lastIndexOf('.update');
                    //             final tweetId = data.events[0]
                    //                 .substring(startingPoint + 10, endPoint);
                    //
                    //             var tweet = tweets
                    //                 .where((element) => element.id == tweetId)
                    //                 .first;
                    //
                    //             final tweetIndex = tweets.indexOf(tweet);
                    //             tweets.removeWhere(
                    //                 (element) => element.id == tweetId);
                    //
                    //             tweet = Tweet.fromMap(data.payload);
                    //             tweets.insert(tweetIndex, tweet);
                    //           }
                    //         }
                    //
                    //         return Expanded(
                    //           child: ListView.builder(
                    //             itemCount: tweets.length,
                    //             itemBuilder: (BuildContext context, int index) {
                    //               final tweet = tweets[index];
                    //               return TweetCard(tweet: tweet);
                    //             },
                    //           ),
                    //         );
                    //       },
                    //       error: (error, stackTrace) => ErrorText(
                    //         error: error.toString(),
                    //       ),
                    //       loading: () {
                    //         return Expanded(
                    //           child: ListView.builder(
                    //             itemCount: tweets.length,
                    //             itemBuilder: (BuildContext context, int index) {
                    //               final tweet = tweets[index];
                    //               return TweetCard(tweet: tweet);
                    //             },
                    //           ),
                    //         );
                    //       },
                    //     );
                    //
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tweet = tweets[index];
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                  error: (error, st) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          );
  }
}
