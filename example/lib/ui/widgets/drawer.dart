import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:flutter_vpn/state.dart';
import '../common/texts.dart';
import '../logs.dart';

bool checked = false;
int vpn = 0;

class drawer extends StatefulWidget {
  const drawer({Key? key}) : super(key: key);

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  late Widget widgett = advanced();
  Widget advanced() {
    return ListTile(
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 33.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.arrow_drop_down),
                    Text("Advanced         "),
                    SizedBox(
                      width: 60,
                    )
                  ],
                ),
                Text(
                  "Allow remote control apps",
                  style: TextStyle(color: Color.fromARGB(122, 13, 5, 5)),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        //  Navigator.pop(context)
        setState(() {
          widgett = remote();
        });
      },
    );
  }

  Widget remote() {
    log("value is");
    print(checked);
    return ListTile(
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Stack(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "Allow remote control apps                                     "),
                      Text(
                        "External apps may not                                              ",
                        style: TextStyle(color: Color.fromARGB(122, 13, 5, 5)),
                      ),
                      Text(
                        "toggle tunnels (recommended)                         ",
                        maxLines: null,
                        style: TextStyle(color: Color.fromARGB(122, 13, 5, 5)),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width / 2 + 10,
                  child: Checkbox(
                      value: checked,
                      onChanged: (v) {
                        log("here");
                        print(v);
                        Navigator.pop(context);
                        setState(() {
                          checked = v!;
                        });
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          checked = !checked;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Color.fromARGB(178, 19, 65, 67),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Opacity(
            opacity: 0.6,
            child: CircleAvatar(
              radius: 60,
              child: Image.asset("assets/icon/logo.png"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text(
                "BNEGuard for Android                                       ",
                style: TextStyle(color: Colors.black),
              ),
            ),
            onTap: () {
              // Navigator.pop(context);
            },
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Column(
                children: [
                  Text("Export tunnels                                      "),
                  Text(
                    "Tunnels will be saved to downloads folder",
                    style: TextStyle(color: Color.fromARGB(122, 13, 5, 5)),
                  ),
                ],
              ),
            ),
            onTap: () {
              // FlutterVpn.disconnect();
              loadingView();
              export();
              Navigator.pop(context);
            },
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Column(
                children: [
                  Text("View application logs                         "),
                  Text(
                      "Logs may assist with debugging                           ",
                      style: TextStyle(color: Color.fromARGB(122, 13, 5, 5))),
                ],
              ),
            ),
            onTap: () {
              // FlutterVpn.connectIkev2EAP(
              //   server: "vpn.nessom.ir",
              //   username: "behzad",
              //   password: "1234@qwerB",
              // );
              Get.to(Logs());
            },
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
              onTap: () {
                setState(() {
                  widgett = remote();
                });
              },
              child: widgett),
          SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
            ),
          )
        ],
      ),
    );
  }

  loadingView() {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            color: Color.fromARGB(178, 19, 65, 67),
          ),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text('Exporting tunnels')),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  export() async {
    await Future.delayed(Duration(seconds: 2)).then((v) {
      print("3 seconds done");

      Navigator.pop(context);
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('vpn')) {
      setState(() {
        vpn = preferences.getInt('vpn')!;
      });
    }
    List<File> files = [];

    for (int i = 1; i <= vpn; i++) {
      log(vpn.toString());
      log("runinngggg");
      String tunnel =
          '[Interface]\nPrivateKey =${preferences.getString('${i}privateKey')}\nAddress = ${preferences.getString('${i}address')}\nDNS =${preferences.getString('${i}dnsServer')}\n\n[Peer]\nPublicKey = ${preferences.getString('${i}peerPublicKey')}\nAllowedIPs =${preferences.getString('${i}peerAllowedIp')}\nEndpoint =${preferences.getString('${i}peerEndpoint')}';
      Directory directory = Directory('/storage/emulated/0/Download');
      log(directory.path);
      final File file =
          File('${directory.path}/${preferences.getString('${i}name')}.txt');
      await file.writeAsString(tunnel);
      files.add(file);

      // final sourceDir = Directory("/storage/emulated/0/Download");

      // final zipFile = File("Tunnels");

      // ZipFile.createFromDirectory(
      //     sourceDir: sourceDir, zipFile: zipFile, recurseSubDirs: true);

      // try {
      //   ZipFile.createFromFiles(
      //       sourceDir: sourceDir, files: files, zipFile: zipFile);
      // } catch (e) {
      //   print(e);
      // }
    }
    Navigator.pop(context);
    if (vpn <= 0) {
      _showError(context, 'No tunnels to export');
    } else {
      _showSuccess(context, 'Tunnels exported to downloads folder');
    }
  }

  _showError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Texts.semiBold(error, color: Colors.white),
      backgroundColor: Colors.red[400],
    ));
  }

  _showSuccess(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Texts.semiBold(
        error,
        color: Colors.white,
      ),
      backgroundColor: Colors.green[500],
    ));
  }
}
