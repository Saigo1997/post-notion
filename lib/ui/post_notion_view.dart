import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './focus_controller_widget.dart';
import './settings_view.dart';
import '../domain/usecase/post_notion_usecase.dart';

enum ButtonState {
  send('送信'),
  sending('送信中...'),
  ok('OK!'),
  ng('NG...'),
  ;

  const ButtonState(this.displayName);
  final String displayName;
}

final buttonStateProvider = StateProvider((_) => ButtonState.send);
final textFieldControllerProvider = Provider((_) => TextEditingController());

class PostNotionView extends ConsumerStatefulWidget {
  const PostNotionView({Key? key}): super(key: key);

  @override
  ConsumerState<PostNotionView> createState() => _PostNotionState();
}

class _PostNotionState extends ConsumerState<PostNotionView> {
  final PostNotionUsecase _postNotionUsecase = PostNotionUsecaseImpl();

  void _onPressButton() {
    debugPrint('_onPressButton [${ref.watch(textFieldControllerProvider).text}]');
    ref.read(buttonStateProvider.notifier).state = ButtonState.sending;

    _postNotionUsecase.postToNotion(ref.watch(textFieldControllerProvider).text).then((result) {
      debugPrint('postToNotion result [$result]');
      if (result) {
        ref.read(textFieldControllerProvider).text = '';
        ref.read(buttonStateProvider.notifier).state = ButtonState.ok;
      } else {
        ref.read(buttonStateProvider.notifier).state = ButtonState.ng;
      }

      Timer(
        const Duration(seconds: 1, milliseconds: 500),
        () {
          ref.read(buttonStateProvider.notifier).state = ButtonState.send;
        },
      );
    });
  }

  void _moveToSetting() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SettingsView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FocusController(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Post Notion'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: _moveToSetting,
              icon: const Icon(Icons.settings),
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: ref.watch(textFieldControllerProvider),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  maxLines: 6,
                  autofocus: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: _onPressButton,
                      child: Text(ref.watch(buttonStateProvider).displayName),
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
