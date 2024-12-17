import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_buddy/Page/camera_page.dart';
import 'package:plant_buddy/Page/community_page.dart';
import 'package:plant_buddy/Page/main_page.dart';
import 'package:plant_buddy/Page/profile_page.dart';
import 'package:plant_buddy/Page/search_page.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  runApp(MyApp(firstCamera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription firstCamera;

  const MyApp({Key? key, required this.firstCamera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashColor: Colors.transparent, // 터치 스플래시 효과 제거
        highlightColor: Colors.transparent, // 강조 효과 제거
      ),
      home: BottomNavigationBarExample(firstCamera: firstCamera),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  final CameraDescription firstCamera;

  const BottomNavigationBarExample({super.key, required this.firstCamera});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      MainPage(),
      SearchPage(),
      Container(),
      CommunityPage(),
      ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: SizedBox(), // 카메라 버튼 위치를 위해 빈 공간
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Social',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.green[800],
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              if (index != 2) {
                _onItemTapped(index);
              }
            },
          ),
          Positioned(
            bottom: 5, // 버튼을 경계선 안으로 배치
            left: MediaQuery.of(context).size.width / 2 - 25, // 중앙 정렬
            child: GestureDetector(
              onTap: () {
                Get.to(() => CameraPage(camera: widget.firstCamera));
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
