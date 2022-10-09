import 'package:ReelDownloader/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_reels_downloader/flutter_reels_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ReelDownloader reelDownloader = ReelDownloader(); // create instance of FlutterInsta class
  TextEditingController reelController = TextEditingController();

  ReelDownloader reelDownLoader = ReelDownloader();

  bool pressed = false;
  bool downloading = false;


  @override
  void initState() {
    super.initState();
    initializeDownloader();
    downloadReels();
  }

  void initializeDownloader() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
        debug: false // optional: set false to disable printing logs to console
        );
  }

  void downloadReels() async {
    var s = await reelDownloader.downloadReels(""); //URL
    print(s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reels Downloader Example'),
        centerTitle: true,
      ),
      body: reelPage(),
    );
  }


//Reel Downloader page
  Widget reelPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/lottie.json',
          repeat: true,
          width: 200,
          height: 200,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(50, 30, 50, 0),
          child: TextField(
            controller: reelController,
          ),
        ),
        SizedBox(height: 15,),
        ElevatedButton(
          onPressed: () {
            setState(() {
              downloading = true; //set to true to show Progress indicator
            });
            download();
          },
          child: Text("Download"),
        ),
        downloading
            ? Center(
                //if downloading is true show Progress Indicator
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: SpinKitWave(
                    color: Colors.blue,
                  ),
                ),
              )
            : Container()
      ],
    );
  }

//Download reel video on button clickl
  void download() async {
    var myvideourl = await reelDownloader.downloadReels(reelController.text);

    await FlutterDownloader.enqueue(
      url: '$myvideourl',
      savedDir: '/sdcard/Download',
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    ).whenComplete(() {
      setState(() {
        downloading = false; // set to false to stop Progress indicator
      });
    });
  }
}
