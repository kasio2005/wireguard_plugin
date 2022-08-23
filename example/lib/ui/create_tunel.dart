import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wireguard_plugin_example/ui/tunnel_details.dart';
import 'package:wireguard_plugin_example/ui/ui_constants.dart';
import 'package:wireguard_plugin_example/ui/wireguard_plugin.dart';

import 'common/buttons.dart';
import 'common/texts.dart';
import 'home_view.dart';

import 'dart:io' show Platform;

class CreateTunnel extends StatefulWidget {
  String? initName;
  String? initAddress;
  String? initPort;
  String? initDnsServer;
  String? initPrivateKey;
  String? initAllowedIp;
  String? initPublicKey;
  String? initEndpoint;
  String? selected;

  CreateTunnel(
      {this.initAddress,
      this.selected,
      this.initAllowedIp,
      this.initDnsServer,
      this.initEndpoint,
      this.initName,
      this.initPort,
      this.initPrivateKey,
      this.initPublicKey});
  @override
  createState() => _CreateTunnelState();
}

class _CreateTunnelState extends State<CreateTunnel> {
  late final _nameController = TextEditingController(
    text: widget.initName,
  );
  late final _addressController = TextEditingController(
    text: widget.initAddress,
  );
  late final _listenPortController = TextEditingController(
    text: widget.initPort,
  );
  late final _dnsServerController = TextEditingController(
    text: widget.initDnsServer,
  );
  late final _privateKeyController = TextEditingController(
    text: widget.initPrivateKey,
  );
  late final _peerAllowedIpController = TextEditingController(
    text: widget.initAllowedIp,
  );
  late final _peerPublicKeyController = TextEditingController(
    text: widget.initPublicKey,
  );
  late final _peerEndpointController = TextEditingController(
    text: widget.initEndpoint,
  );
  bool _scrolledToTop = true;
  int vpn = 1;
  bool isExist = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.offAll(HomeView());
        throw Null;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Get.offAll(HomeView());
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            "Creat tunnel",
            style: TextStyle(),
          ),
          backgroundColor: Color.fromARGB(178, 19, 65, 67),
          elevation: _scrolledToTop ? 0 : null,
        ),
        body: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            setState(() => _scrolledToTop = notification.metrics.pixels == 0);
            return true;
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: AppPadding.allNormal,
                  child: Column(
                    children: [
                      _divider('Tunnel'),
                      _input(
                        hint: 'Tunnel name',
                        enabled: true,
                        controller: _nameController,
                        onChanged: (v) => setState(() => null),
                      ),
                      const Vertical.small(),
                      _input(
                        hint: 'Address',
                        enabled: true,
                        controller: _addressController,
                        onChanged: (v) => setState(() => null),
                      ),
                      const Vertical.small(),
                      _input(
                        hint: 'DNS server',
                        enabled: true,
                        controller: _dnsServerController,
                        onChanged: (v) => setState(() => null),
                      ),
                      const Vertical.small(),
                      _input(
                        hint: 'Private key',
                        enabled: true,
                        controller: _privateKeyController,
                        onChanged: (v) => setState(() => null),
                      ),
                      _divider('Peer'),
                      _input(
                        hint: 'Peer allowed IP',
                        enabled: true,
                        controller: _peerAllowedIpController,
                        onChanged: (v) => setState(() => null),
                      ),
                      const Vertical.small(),
                      _input(
                        hint: 'Peer public key',
                        enabled: true,
                        controller: _peerPublicKeyController,
                        onChanged: (v) => setState(() => null),
                      ),
                      const Vertical.small(),
                      _input(
                        hint: 'Peer endpoint',
                        enabled: true,
                        controller: _peerEndpointController,
                        onChanged: (v) => setState(() => null),
                      ),
                      Padding(
                        padding: AppPadding.top(60),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: AppPadding.allNormal,
                  child: Buttons(
                    buttonColor: Color.fromARGB(178, 19, 65, 67),
                    text: 'Save Tunnel',
                    onPressed: () => _onActionButtonPressed(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onActionButtonPressed(BuildContext context) async {
    if (_nameController.text.isEmpty) {
      _showError(context, 'Enter the tunnel name');
      return;
    }
    if (_addressController.text.isEmpty) {
      _showError(context, 'Enter the address');
      return;
    }

    if (_dnsServerController.text.isEmpty) {
      _showError(context, 'Enter the dns server');
      return;
    }
    if (_privateKeyController.text.isEmpty) {
      _showError(context, 'Enter the private key');
      return;
    }
    if (_peerAllowedIpController.text.isEmpty) {
      _showError(context, 'Enter the peer allowed IP');
      return;
    }
    if (_peerPublicKeyController.text.isEmpty) {
      _showError(context, 'Enter the public key');
      return;
    }
    if (_peerEndpointController.text.isEmpty) {
      _showError(context, 'Enter the peer endpoint');
      return;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('vpn')) {
      log('have vpn');
      setState(() {
        vpn = preferences.getInt('vpn')!;
      });
      log(vpn.toString());
    }
    for (int i = 1; i <= vpn; i++) {
      if (preferences.getString('${i}name') == _nameController.text) {
        setState(() {
          isExist = true;
        });
      }
    }
    log(isExist.toString());
    if (!isExist) {
      log("tunel not exist");
      log(vpn.toString());
      if (preferences.containsKey('vpn')) {
        setState(() {
          vpn = preferences.getInt('vpn')! + 1;
        });
      }
      preferences.setInt('vpn', vpn);

      log(vpn.toString());
      preferences.setString('${vpn}name', _nameController.text);

      preferences.setString('${vpn}address', _addressController.text);
      preferences.setString('${vpn}dnsServer', _dnsServerController.text);
      preferences.setString('${vpn}listenPort', _listenPortController.text);
      preferences.setString(
          '${vpn}peerAllowedIp', _peerAllowedIpController.text);
      preferences.setString('${vpn}peerEndpoint', _peerEndpointController.text);
      preferences.setString('${vpn}privateKey', _privateKeyController.text);
      preferences.setString(
          '${vpn}peerPublicKey', _peerPublicKeyController.text);

      Get.offAll(HomeView());
    } else {
      setState(() {
        isExist = false;
      });
      alert();
    }
  }

  alert() {
    AlertDialog alert = AlertDialog(
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Ok",
              style: TextStyle(fontFamily: 'Montserrat'),
            ))
      ],
      content: new Row(
        children: [
          //  CircularProgressIndicator(),
          Container(
              //margin: EdgeInsets.only(left: 7),
              child: Builder(builder: (context) {
            return FittedBox(
                child: Text(
              "Tunnel already exists.",
              maxLines: 2,
              style: TextStyle(fontFamily: 'Montserrat'),
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

  _showError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Texts.semiBold(error, color: Colors.white),
      backgroundColor: Colors.red[400],
    ));
  }

  Widget _input({
    required String hint,
    required ValueChanged<String> onChanged,
    bool enabled = true,
    required TextEditingController controller,
  }) {
    return Container(
      padding: AppPadding.horizontalSmall,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[100],
        border: Border.fromBorderSide(
          BorderSide(
            color: enabled ? Colors.black12 : Colors.black.withOpacity(0.05),
            width: 1.0,
          ),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          const Vertical.micro(),
          Row(
            children: [
              Texts(
                hint,
                textSize: AppSize.fontSmall,
                color: Colors.black38,
                height: 1.5,
              ),
            ],
          ),
          TextField(
            enabled: enabled,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontFamily: 'Montserrat'),
              border: InputBorder.none,
              isDense: true,
            ),
            // style: GoogleFonts.openSans(
            //   textStyle: TextStyle(fontWeight: FontWeight.w600),
            //   height: 1.0,
            // ),
            controller: controller,
            onChanged: onChanged,
          ),
          const Vertical.micro(),
        ],
      ),
    );
  }

  Widget _divider(String title) {
    return Padding(
      padding: AppPadding.verticalNormal,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: AppPadding.rightNormal,
              child: Container(
                height: 0.5,
                color: Colors.black.withOpacity(0.08),
              ),
            ),
          ),
          Texts.smallVery(
            title.toUpperCase(),
            color: Colors.black45,
          ),
          Expanded(
            child: Padding(
              padding: AppPadding.leftNormal,
              child: Container(
                height: 0.5,
                color: Colors.black.withOpacity(0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
