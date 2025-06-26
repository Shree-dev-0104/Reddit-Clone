import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/comman/loader.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../controller/community_controller.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    void navigateToRouteTools(BuildContext context, ) {
      Routemaster.of(context).push('/mod-tools/$name');
    }

    final user = ref.watch(userProvider);  

    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
            data: (community) {
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      floating: true,
                      snap: true,
                      expandedHeight: 150,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              community.banner,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(community.avatar),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'r/${community.name}',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                community.mods.contains(user?.uid) ?
                                
                                OutlinedButton(
                                  onPressed: () {
                                      navigateToRouteTools(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 25),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                  child: const Text('Mod Tools'),
                                ) : 
                                OutlinedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 25),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                  child:  Text(community.members.contains(user?.uid) ?  'Joined' : 'Join'),
                                ) 
 
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                              ),
                            ),
                            Text(
                              "${community.members.length} members",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: Text('Displaying posts: ${community.name}'),
              );
            },
            error: (error, stack) {
              return Center(
                child: Text(
                  'Error: ${error is Failure ? error.message : 'Something went wrong'}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            },
            loading: () => const Loader(),
          ),
    );
  }
}
