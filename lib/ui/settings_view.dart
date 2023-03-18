import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './focus_controller_widget.dart';
import '../domain/usecase/access_key_usecase.dart';

final tokenTextFieldControllerProvider = Provider((_) => TextEditingController());
final databaseIdTextFieldControllerProvider = Provider((_) => TextEditingController());

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({Key? key}): super(key: key);

  @override
  ConsumerState<SettingsView> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<SettingsView> {
  final AccessKeyUsecase accessKeyUsecase = AccessKeyUsecaseImpl();

  _SettingsState() {
    accessKeyUsecase.load().then((accessKeyModel) {
      ref.read(tokenTextFieldControllerProvider).text = accessKeyModel.token;
      ref.read(databaseIdTextFieldControllerProvider).text = accessKeyModel.databaseId;
    });
  }

  void _storeSetting() {
    final secretToken = ref.read(tokenTextFieldControllerProvider).text;
    final databaseId = ref.read(databaseIdTextFieldControllerProvider).text;
    debugPrint('secretToken: $secretToken');
    debugPrint('databaseId: $databaseId');
    accessKeyUsecase.store(secretToken, databaseId).then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusController(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('設定'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: ref.watch(tokenTextFieldControllerProvider),
                  decoration: InputDecoration(
                    labelText: 'secret token',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  maxLines: 1,
                  autofocus: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TextField(
                  controller: ref.watch(databaseIdTextFieldControllerProvider),
                    decoration: InputDecoration(
                      labelText: 'database id',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    maxLines: 1,
                    autofocus: true,
                  ),
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
                      onPressed: _storeSetting,
                      child: const Text('設定'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
