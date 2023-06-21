import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_flavor/components/alert_dialog.dart';
import 'package:test_flavor/components/custom_app_bar.dart';
import 'package:test_flavor/navigators/home_navigator.dart';
import 'package:test_flavor/navigators/main_navigator.dart';
import 'package:test_flavor/pages/fifth.dart';
import 'package:test_flavor/pages/forth.dart';
import 'package:test_flavor/pages/second.dart';
import 'package:test_flavor/pages/third.dart';
import 'package:test_flavor/providers/repository/get_friend_notifier.dart';
import 'package:test_flavor/providers/repository/get_user_notifier.dart';
import 'package:test_flavor/providers/repository/update_user_notifier.dart';
import 'package:test_flavor/providers/state/user_info_state_notifier.dart';
import 'package:test_flavor/utils/loading_handler.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = LoadingHandler(context);
      overlay.background(
          ref.read(getUserNotifierProvider.notifier).fetchDataAndUpdateUser());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'home',
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Text(
                  'home',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.red,
                  ),
                ),
                ref.watch(getFriendNotifierProvider).when(
                    data: (data) {
                      final user = ref.watch(getFriendNotifierProvider);

                      return Column(children: [
                        // Text(user.name ?? ''),
                        Text('test'),
                      ]);
                    },
                    loading: () => CircularProgressIndicator(),
                    error: (error, stackTrace) {
                      // WidgetsBinding.instance.addPostFrameCallback((_) {
                      //   showDialog(
                      //       context: context,
                      //       builder: (_) =>
                      //           NetworkErrorDialog(errorCode: error));
                      // });

                      return Text('データが取得できませんでした。');
                    }),
                ElevatedButton(
                    onPressed: () => ref
                        .watch(getUserNotifierProvider.notifier)
                        .fetchDataAndUpdateUser(),
                    child: const Text('setUserAsync')),
                ElevatedButton(
                    onPressed: () => ref
                        .watch(userStateNotifierProvider.notifier)
                        .setUser(name: '!!!!!'),
                    child: const Text('setUser')),
                ElevatedButton(
                    onPressed: () async =>
                        ref.invalidate(userStateNotifierProvider),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: const Text('refresh!')),
                ElevatedButton(
                    onPressed: () async => HomeNavigator.toSecond(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    child: const Text('second')),
                ElevatedButton(
                    onPressed: () async => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Third()),
                        ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightGreen),
                    ),
                    child: const Text('third')),
                ElevatedButton(
                    onPressed: () async => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Forth()),
                        ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.purple),
                    ),
                    child: const Text('forth')),
                ElevatedButton(
                    onPressed: () async => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Fifth()),
                        ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.purple),
                    ),
                    child: const Text('fifth')),
              ],
            ),
          ),
        ));
  }
}



// class LoadingOverlay extends StatelessWidget {
//   final bool isLoading;
//   final Widget child;

//   LoadingOverlay({required this.isLoading, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         child,
//         if (isLoading)
//           Container(
//             color: Colors.black54,
//             child: Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),
//       ],
//     );
//   }
// }