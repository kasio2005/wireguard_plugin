import 'dart:developer';
import 'dart:io';

import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/sockets/src/socket_notifier.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wireguard_plugin_example/ui/tunnel_details.dart';
import 'package:wireguard_plugin_example/ui/widgets/drawer.dart';
import 'package:wireguard_plugin_example/ui/wireguard_plugin.dart';

import 'create_tunel.dart';
import 'model/tunnel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // static const platform = const MethodChannel('tark.pro/wireguard-flutter');
  TextEditingController _nameController = TextEditingController();
  List name = [];
  List address = [];
  List dns = [];
  List allowed = [];
  List endpoint = [];
  List privatekey = [];
  List publickey = [];
  @override
  void initState() {
    print("init state");
    // TODO: implement initState
    isConnected();

    super.initState();
  }

  int index = 0;
  String? _name;
  String? _address;
  String? _dnsServer;
  String? _peerAllowedIp;
  String? _peerEndpoint;
  String? _privateKey;
  String? _peerPublicKey;
  String _selectedTunelName = 'no';
  bool _connected = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String text = 'Connecting';
  int vpn = 0;

  Future<void> isConnected() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("checking status");
    // await WireguardPlugin.requestPermission();
    // await WireguardPlugin.initialize();
    // WireguardPlugin.tunnelState.isEmpty.then((value) {
    //   print(value);
    //   setState(() {
    //     _connected = false;
    //   });
    // });
    setState(() {
      text = 'Connecting';
    });
    if (await CheckVpnConnection.isVpnActive()) {
      log("the vpn is connected");
      setState(() {
        text = "Disconnecting";
        _connected = true;
      });
    }
    log("check num");
    if (preferences.containsKey('selectedTunelName')) {
      log(preferences.getString('selectedTunelName')!);
      if (preferences.getString('selectedTunelName') != 'no')
        setState(() {
          //  _connected = true;
          _selectedTunelName = preferences.getString('selectedTunelName')!;
        });
    } else {
      preferences.setString('selectedTunelName', 'no');
    }
    log(_selectedTunelName);
    log(_connected.toString());
    if (preferences.containsKey('vpn')) {
      setState(() {
        vpn = preferences.getInt('vpn')!;
      });
    }
    log(vpn.toString());
    checkVpn(vpn);
  }

  Future<void> checkVpn(vpn) async {
    log("checking vpn");
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (vpn != 0) {
      for (int i = 1; i < vpn + 1; i++)
        setState(() {
          name.add(preferences.getString('${i}name'));
          address.add(preferences.getString('${i}address'));
          dns.add(preferences.getString('${i}dnsServer'));

          allowed.add(preferences.getString('${i}peerAllowedIp'));
          endpoint.add(preferences.getString('${i}peerEndpoint'));
          privatekey.add(preferences.getString('${i}privateKey'));
          publickey.add(preferences.getString('${i}peerPublicKey'));
          _selectedTunelName = preferences.getString('selectedTunelName')!;
        });
    }
    log(name.toString());
    log(dns.toString());
    log(_selectedTunelName);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
        throw Null;
      },
      child: SafeArea(
        child: Scaffold(
          endDrawer: Drawer(
            child: drawer(),
          ),
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(178, 19, 65, 67),
            title: Text('BNEGuard'),
            actions: <Widget>[
              InkWell(
                  onTap: () {
                    print("pressed");
                    _scaffoldKey.currentState!.openEndDrawer();
                  },
                  child: Icon(Icons.more_vert)),
              SizedBox(
                width: 10,
              )
            ],
          ),
          body: Stack(
            children: [
              Center(
                child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(22, 138, 77, 0.028)),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: vpn > 0
                        ? Center(
                            child: ListView.builder(
                                itemCount: vpn,
                                itemBuilder: (BuildContext context, int index) {
                                  log('list is this time');
                                  return Card(
                                    elevation: 3,
                                    child: SizedBox(
                                      height: 70,
                                      width: MediaQuery.of(context).size.width -
                                          100,
                                      child: GestureDetector(
                                        onLongPress: () async {
                                          delete(index);
                                        },
                                        onTap: () async {
                                          await WireguardPlugin
                                              .requestPermission();
                                          await WireguardPlugin.initialize();
                                          Get.to(TunnelDetails(
                                            fromHome: true,
                                            selected: _selectedTunelName,
                                            initName: name.elementAt(index),
                                            initAddress:
                                                address.elementAt(index),
                                            initPort: '51820',
                                            initDnsServer: dns.elementAt(index),
                                            initPrivateKey:
                                                privatekey.elementAt(index),
                                            initAllowedIp:
                                                allowed.elementAt(index),
                                            initPublicKey:
                                                publickey.elementAt(index),
                                            initEndpoint:
                                                endpoint.elementAt(index),
                                          ));
                                        },
                                        child: Ink(
                                          color:
                                              Color.fromARGB(178, 19, 65, 67),
                                          child: ListTile(
                                              selectedColor: Colors.lightGreen,
                                              title:
                                                  Text(name.elementAt(index)),
                                              subtitle: Text(
                                                  address.elementAt(index)),
                                              trailing: SizedBox(
                                                width: 40,
                                                height: 30,
                                                child: FlutterSwitch(
                                                    activeColor: Color.fromARGB(
                                                        186, 176, 203, 207),
                                                    inactiveColor: Colors.white,
                                                    toggleColor: Colors.grey,
                                                    width: 40,
                                                    height: 30,
                                                    padding: 4.0,
                                                    toggleSize: 15.0,
                                                    borderRadius: 10.0,
                                                    onToggle: (val) async {
                                                      if (!(_connected &&
                                                          _selectedTunelName !=
                                                              name.elementAt(
                                                                  index))) {
                                                        setState(() {
                                                          _connected =
                                                              !_connected;
                                                        });
                                                        log("before");
                                                        log(_selectedTunelName);
                                                        log(text);
                                                        log(_connected
                                                            .toString());
                                                        SharedPreferences
                                                            sharedPreferences =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        if (!_connected) {
                                                          setState(() {
                                                            sharedPreferences
                                                                .setString(
                                                                    'selectedTunelName',
                                                                    'no');
                                                            _selectedTunelName =
                                                                'no';
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _selectedTunelName =
                                                                name.elementAt(
                                                                    index);
                                                            sharedPreferences
                                                                .setString(
                                                                    'selectedTunelName',
                                                                    name.elementAt(
                                                                        index));
                                                          });
                                                        }
                                                        loadingView();

                                                        await WireguardPlugin
                                                            .setState(
                                                                isConnected:
                                                                    _connected,
                                                                tunnel: Tunnel(
                                                                  name: name
                                                                      .elementAt(
                                                                          index),
                                                                  address: address
                                                                      .elementAt(
                                                                          index),
                                                                  dnsServer: dns
                                                                      .elementAt(
                                                                          index),
                                                                  listenPort:
                                                                      '51820',
                                                                  peerAllowedIp:
                                                                      allowed.elementAt(
                                                                          index),
                                                                  peerEndpoint:
                                                                      endpoint.elementAt(
                                                                          index),
                                                                  peerPublicKey:
                                                                      publickey
                                                                          .elementAt(
                                                                              index),
                                                                  privateKey: privatekey
                                                                      .elementAt(
                                                                          index),
                                                                ));
                                                        Navigator.pop(context);
                                                        // Phoenix.rebirth(context);
                                                        log("after");
                                                        log(_selectedTunelName);
                                                      } else {
                                                        alert();
                                                      }
                                                    },
                                                    value: _connected
                                                        ? _selectedTunelName ==
                                                                name.elementAt(
                                                                    index)
                                                            ? true
                                                            : false
                                                        : false),
                                              )),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : Center(
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Opacity(
                                      opacity: 0.3,
                                      child: Container(
                                        child: Image.asset(
                                          'assets/icon/homepage.png',
                                          height: 300,
                                          width: 500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                            "Add tunnel using below button")),
                                  ],
                                ),
                              ],
                            ),
                          )),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height - 200,
                left: MediaQuery.of(context).size.width - 80,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(149, 6, 52, 41)),
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 28.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        filePicker();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.file_copy,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            "IMPORT FROM FILE OR ARCHIVE",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        log("Scanning Qr code..");
                                        scanQRCode();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.qr_code,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            "SCAN FROM QR CODE",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        createFromScratch();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            "CREATE FROM SCRATCH",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(178, 19, 65, 67),
                    radius: 30,
                    child: Ink(
                      child: Icon(
                        Icons.add,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   height: 100,
              //   width: MediaQuery.of(context).size.width,
              //   child: Row(
              //     children: [
              //       Text("BNE Guard"),
              //       Spacer(),
              //       Icon(Icons.more_horiz)
              //     ],
              //   ),
              // )
              // Positioned(
              //     top: MediaQuery.of(context).size.height / 2,
              //     child: Container(child: Text("Add tunnel using below button"))),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> scanQRCode() async {
    Navigator.pop(context);

    try {
      final qrcode = await FlutterBarcodeScanner.scanBarcode(
        '#00B9F1',
        'Cancel',
        true,
        ScanMode.QR,
      );
      if (!mounted) return;
      log(qrcode);
      extractContent(qrcode);
    } catch (error) {
      _showError(context, "unable to scan or File format not correct");
    }
  }

  loadingView() async {
    bool connected = await CheckVpnConnection.isVpnActive();
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            color: Color.fromARGB(178, 19, 65, 67),
          ),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text(connected ? "Disconnecting" : 'Connecting')),
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

  alert() {
    AlertDialog alert = AlertDialog(
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok"))
      ],
      content: new Row(
        children: [
          //  CircularProgressIndicator(),
          Container(
              //margin: EdgeInsets.only(left: 7),
              child: Builder(builder: (context) {
            return FittedBox(
                child: Text(
              "Disconnect existing tunnel.",
              maxLines: 2,
              style: TextStyle(),
            ));
          })),
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

  delete(vpn) {
    log(vpn.toString());
    AlertDialog alert = AlertDialog(
      actions: [
        FlatButton(
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();

              preferences.remove('${vpn + 1}name');
              // preferences.remove('selectedTunelName');
              preferences.remove('${vpn + 1}address');
              preferences.remove('${vpn + 1}dnsServer');
              preferences.remove('${vpn + 1}listenPort');
              preferences.remove('${vpn + 1}peerAllowedIp');
              preferences.remove('${vpn + 1}peerEndpoint');
              preferences.remove('${vpn + 1}privateKey');
              preferences.remove('${vpn + 1}peerPublicKey');

              isConnected();
              if (preferences.containsKey('vpn')) {
                preferences.setInt('vpn', preferences.getInt('vpn')! - 1);
              }

              Navigator.pop(context);
              Get.to(HomeView());
            },
            child: Text("Delete")),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"))
      ],
      content: new Row(
        children: [
          //  CircularProgressIndicator(),
          Container(
              //margin: EdgeInsets.only(left: 7),
              child: Builder(builder: (context) {
            return FittedBox(
                child: Text(
              "Delete this tunnel?",
              maxLines: 2,
              style: TextStyle(),
            ));
          })),
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

  Future<void> filePicker() async {
    Navigator.pop(context);
    try {
      var result = await FilePicker.platform.pickFiles();
      print(result!.files.single.path!);

      final file = File(result.files.single.path!);
      final contents = await file.readAsString();

      extractContent(contents);
    } catch (e) {
      _showError(context, "Failed to export tunnel");
    }
  }

  Future<void> extractContent(String contents) async {
    String words = contents.replaceAll(r' ', ',');
    words = words.replaceAll(r'\n', ',');
    String newStr = '';
    for (int i = 0; i < words.length; i++) {
      var c = words[i];
      if (words[i] == '\n') {
        c = ',';
      }
      if (words[i] != ' ') {
        newStr += c.trim();
      }
    }
    print(newStr.split(','));
    List newList = newStr.split(',');
    _displayDialog(context, newList[6], newList[9], newList[3], newList[21],
        newList[18], newList[26]);
  }

  _displayDialog(
      BuildContext context,
      String initAddress,
      String initDnsServer,
      String initPrivateKey,
      String initAllowedIp,
      String initPublicKey,
      String initEndpoint) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter the name for tunnel.'),
            content: TextField(
              controller: _nameController,
              textInputAction: TextInputAction.go,
              //keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(178, 19, 65, 67))),
                hintText: "Enter name here",
                focusColor: Color.fromARGB(178, 19, 65, 67),
                enabledBorder: OutlineInputBorder(
                  //borderRadius: BorderRadius.circular(25.0),

                  borderSide: BorderSide(
                    color: Color.fromARGB(178, 19, 65, 67),
                    width: 2.0,
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _nameController.text.isNotEmpty
                      ? startTunel(
                          _nameController.text,
                          initAddress,
                          initDnsServer,
                          initPrivateKey,
                          initAllowedIp,
                          initPublicKey,
                          initEndpoint)
                      : _showError(context, "Please enter tunel name");
                },
              ),
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> startTunel(
      String name,
      String initAddress,
      String initDnsServer,
      String initPrivateKey,
      String initAllowedIp,
      String initPublicKey,
      String initEndpoint) async {
    log("requesting permission");
    await WireguardPlugin.requestPermission();
    log("initializing");
    await WireguardPlugin.initialize();
    log("going to tunnel details");
    Get.to(TunnelDetails(
      fromHome: false,
      selected: 'no',
      initName: name,
      initAddress: initAddress,
      initPort: "51820",
      initDnsServer: initDnsServer,
      initPrivateKey: initPrivateKey,
      initAllowedIp: initAllowedIp,
      initPublicKey: initPublicKey,
      initEndpoint: initEndpoint,
    ));
  }

  Future<void> createFromScratch() async {
    Navigator.pop(context);

    Get.to(CreateTunnel());
  }

  _showError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(error),
      backgroundColor: Colors.red[400],
    ));
  }
}
