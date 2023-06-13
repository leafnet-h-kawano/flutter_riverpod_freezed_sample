// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:test_flavor/entity/user_entity.dart';

// class UserStateNotifier extends StateNotifier<AsyncValue<UserEntity>> {
//   UserStateNotifier() : super(const AsyncValue.loading());

//   void setEmail(String email) {
//     // state = state.copyWith(email: email);
//     state = AsyncValue.data(state.value!.copyWith(email: email));
//   }

//   void increment() {
//     // state = state.copyWith(id: state.id + 1);
//     state = state.value != null
//         ? AsyncValue.data(state.value!.copyWith(id: state.value!.id + 1))
//         : state;
//   }

//   // //画像ファイルを保存
//   // saveNowImg(File imageFile) async {
//   //   final photoDomain = PhotoDomain();
//   //   await photoDomain.saveNowImageAndPath(imageFile);
//   // }
// }

// final userStateNotifierProvider =
//     StateNotifierProvider<UserStateNotifier, AsyncValue<UserEntity>>((ref) {
//   return UserStateNotifier();
// });

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_flavor/entity/state/item_info_state.dart';
import 'package:test_flavor/entity/state/user_info_state.dart';
import 'package:test_flavor/providers/state/user_info_state_notifier.dart';

class GetUserNotifier extends StateNotifier<AsyncValue<void>> {
  GetUserNotifier(this.ref) : super(const AsyncValue.data(null));
  final Ref ref;
  // //プロバイダー呼び出し時に初期データ取得(ステートをリセットする必要がある場合は使用しない)
  // : super(AsyncValue.loading()){
  // fetchDataAndUpdateUser()
  // };

  Future<void> fetchDataAndUpdateUser() async {
    state = const AsyncValue.loading();

    try {
      // final data = await fetchData();
      // state = AsyncValue.data(UserInfoState(id: 99, name: 'fetchde_name'));

      await Future.delayed(const Duration(seconds: 1));
      await Dio()
          .get('https://api.example.com/data')
          .then((value) {})
          .onError((e, stackTrace) {
        if (e is DioException) {
          if (e.response != null) {
            // エラーステータスが存在する場合
            final statusCode = e.response!.statusCode;
            print('Error Status Code: $statusCode');
            // エラーレスポンスの内容も取得可能
            final errorData = e.response!.data;
            print('Error Response: $errorData');
            throw statusCode!;
          } else {
            // ネットワーク接続エラーやタイムアウトなどの場合
            print('Network Error: $e');
            throw 900;
          }
        } else {
          // DioError以外の例外の場合
          print('Unexpected Error: $e');
          throw 901;
        }
      });

      ref
          .watch(userStateNotifierProvider.notifier)
          .setUser(id: 999, name: 'geted_name', email: 'mail_name');
      state = const AsyncValue.data(null);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}

final getUserNotifierProvider =
    StateNotifierProvider<GetUserNotifier, AsyncValue<void>>((ref) {
  return GetUserNotifier(ref);
});
