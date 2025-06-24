import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/comman/loader.dart';
import 'package:routemaster/routemaster.dart';

import '../../../model/community_model.dart';
import '../../community/controller/community_controller.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});


  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Create Community'),
            onTap: () {
              navigateToCreateCommunity(context);
            },
          ),
          ref.watch(userCommunityProvider).when(
                data: (communities) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: (context, index) {
                        final community = communities[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          title: Text('r/${community.name}'),
                          onTap: () {
                            navigateToCommunity(context, community);
                          },
                        );
                      }, 
                    ),
                  );
                },
                error: (error, stackTrace) => Center(child: Text(error.toString())),
                loading: () => const Loader(),
              ),
        ],
      )),
    );
  }
}
