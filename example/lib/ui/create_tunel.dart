import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wireguard_plugin_example/ui/tunnel_details.dart';
import 'package:wireguard_plugin_example/ui/ui_constants.dart';
import 'package:wireguard_plugin_example/ui/wireguard_plugin.dart';

import 'common/buttons.dart';
import 'common/texts.dart';
import 'home_view.dart';

class CreateTunnel extends StatefulWidget {
  @override
  createState() => _CreateTunnelState();
}

class _CreateTunnelState extends State<CreateTunnel> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _listenPortController = TextEditingController();
  final _dnsServerController = TextEditingController();
  final _privateKeyController = TextEditingController();
  final _peerAllowedIpController = TextEditingController();
  final _peerPublicKeyController = TextEditingController();
  final _peerEndpointController = TextEditingController();
  bool _scrolledToTop = true;

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
        Get.to(HomeView());
        throw Null;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Get.to(HomeView());
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
                    text: 'Connect',
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

    WireguardPlugin.requestPermission();
    WireguardPlugin.initialize();
    Get.to(TunnelDetails(
      selected: _nameController.text,
      fromHome: false,
      initName: _nameController.text,
      initAddress: _addressController.text,
      initPort: "51820",
      initDnsServer: _dnsServerController.text,
      initPrivateKey: _privateKeyController.text,
      initAllowedIp: _peerAllowedIpController.text,
      initPublicKey: _peerPublicKeyController.text,
      initEndpoint: _peerEndpointController.text,
    ));
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
