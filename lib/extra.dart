import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'helper/all.dart';

class TimerListView extends StatefulWidget {
  @override
  _TimerListViewState createState() => _TimerListViewState();
}

class _TimerListViewState extends State<TimerListView> {
  final List<int> _timers = List.generate(100, (index) => 100);
  final List<bool> _visibleItems = List.generate(100, (index) => false);
  Timer? _globalTimer;
  final dio = Dio();
  SharedPreferences? prefs;

  List<dynamic> homeList = [];
  RxBool isEmpty = false.obs;

  @override
  void initState() {
    super.initState();
    _globalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        for (int i = 0; i < _timers.length; i++) {
          if (_visibleItems[i] && _timers[i] > 0) {
            _timers[i]--;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _globalTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List with Timers'),
      ),
      body: ListView.builder(
        itemCount: _timers.length,
        itemBuilder: (context, index) {
          return VisibilityDetector(
            key: Key('item-asasd$index'),
            onVisibilityChanged: (VisibilityInfo info) {
              setState(() {
                print('info.visibleFraction----------------->>>>>>${info.visibleFraction}');
                _visibleItems[index] = info.visibleFraction > 0;
              });
            },
            child: ListTile(
              title: Text('Item $index'),
              trailing: Text('${_timers[index]} sec'),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: TimerListView()));
}
