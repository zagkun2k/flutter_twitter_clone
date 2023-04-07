import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/theme/theme.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const EditProfileView(),
      );

  const EditProfileView({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  File? bannerFile;
  File? avatarFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(
      text: ref.read(currentUserDetailProvider).value?.name ?? '',
    );
    bioController = TextEditingController(
      text: ref.read(currentUserDetailProvider).value?.bio ?? '',
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    bioController.dispose();
  }

  void selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerFile = banner;
      });
    }
  }

  void selectAvatarImage() async {
    final avatar = await pickImage();
    if (avatar != null) {
      setState(() {
        avatarFile = avatar;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailProvider).value;
    final isLoading = ref.watch(userProfileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            padding: const EdgeInsets.only(top: 10, right: 15),
            child: RoundedSmallButton(
              onTap: () {
                ref
                    .read(userProfileControllerProvider.notifier)
                    .updateUserProfile(
                      userModel: user!.copyWith(
                        bio: bioController.text,
                        name: nameController.text,
                      ),
                      context: context,
                      bannerFile: bannerFile,
                      avatarFile: avatarFile,
                    );
              },
              label: 'Save',
              backgroundColor: Pallete.blueColor,
              textColor: Pallete.whiteColor,
            ),
          ),
        ],
      ),
      body: isLoading || user == null
          ? const Loader()
          : Column(
              children: [
                const SizedBox(height: 5),
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: selectBannerImage,
                        child: Container(
                          width: double.infinity,
                          height: 175,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: bannerFile != null
                              ? Image.file(
                                  bannerFile!,
                                  fit: BoxFit.fitWidth,
                                )
                              : user.bannerPic.isEmpty
                                  ? Container(
                                      color: Pallete.greyColor,
                                    )
                                  : Image.network(
                                      user.bannerPic,
                                      fit: BoxFit.fitWidth,
                                    ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        bottom: 3,
                        child: GestureDetector(
                          onTap: selectAvatarImage,
                          child: avatarFile != null
                              ? CircleAvatar(
                                  backgroundImage: FileImage(avatarFile!),
                                  radius: 35.0,
                                )
                              : CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(user.profilePic),
                                  radius: 35.0,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding: EdgeInsets.all(18),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(
                    hintText: 'Bio',
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLines: 3,
                ),
              ], //abc
            ),
    );
  }
}
