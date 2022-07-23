import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:social_share/social_share.dart';

class Logs extends StatefulWidget {
  const Logs({Key? key}) : super(key: key);

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(178, 19, 65, 67),
        title: Text('Logs'),
        actions: <Widget>[
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Text(
                "01 03/22 08:51:01 INFO   :.main: *************** BNE Guard ***************02 03/22 08:51:01 INFO   :...locate_configFile: Specified configuration file: /u/user10/rsvpd1.conf03/22 08:51:01 INFO   :.main: Using log level 51103/22 08:51:01 INFO   :..settcpimage: Get TCP images rc - EDC8112I Operation not supported on socket.0303/22 08:51:01 INFO   :..settcpimage: Associate with TCP/IP image name = TCPCS03/22 08:51:02 INFO   :..reg_process: registering process with the system03/22 08:51:02 INFO   :..reg_process: attempt OS/390 registration03/22 08:51:02 INFO   :..reg_process: return from registration rc=0 04 03/22 08:51:06 TRACE  :...read_physical_netif: Home list entries returned = 703/22 08:51:06 INFO   :...read_physical_netif: index #0, interface VLINK1 has address 129.1.1.1, ifidx 003/22 08:51:06 INFO   :...read_physical_netif: index #1, interface TR1 has address 9.37.65.139, ifidx 103/22 08:51:06 INFO   :...read_physical_netif: index #2, interface LINK11 has address 9.67.100.1, ifidx 203/22 08:51:06 INFO   :...read_physical_netif: index #3, interface LINK12 has address 9.67.101.1, ifidx 303/22 08:51:06 INFO   :...read_physical_netif: index #4, interface CTCD0 has address 9.67.116.98, ifidx 403/22 08:51:06 INFO   :...read_physical_netif: index #5, interface CTCD2 has address 9.67.117.98, ifidx 503/22 08:51:06 INFO   :...read_physical_netif: index #6, interface LOOPBACK has address 127.0.0.1, ifidx 001 03/22 08:51:01 INFO   :.main: *************** BNE Guard ***************02 03/22 08:51:01 INFO   :...locate_configFile: Specified configuration file: /u/user10/rsvpd1.conf03/22 08:51:01 INFO   :.main: Using log level 51103/22 08:51:01 INFO   :..settcpimage: Get TCP images rc - EDC8112I Operation not supported on socket.0303/22 08:51:01 INFO   :..settcpimage: Associate with TCP/IP image name = TCPCS03/22 08:51:02 INFO   :..reg_process: registering process with the system03/22 08:51:02 INFO   :..reg_process: attempt OS/390 registration03/22 08:51:02 INFO   :..reg_process: return from registration rc=0 04 03/22 08:51:06 TRACE  :...read_physical_netif: Home list entries returned = 703/22 08:51:06 INFO   :...read_physical_netif: index #0, interface VLINK1 has address 129.1.1.1, ifidx 003/22 08:51:06 INFO   :...read_physical_netif: index #1, interface TR1 has address 9.37.65.139, ifidx 103/22 08:51:06 INFO   :...read_physical_netif: index #2, interface LINK11 has address 9.67.100.1, ifidx 203/22 08:51:06 INFO   :...read_physical_netif: index #3, interface LINK12 has address 9.67.101.1, ifidx 303/22 08:51:06 INFO   :...read_physical_netif: index #4, interface CTCD0 has address 9.67.116.98, ifidx 403/22 08:51:06 INFO   :...read_physical_netif: index #5, interface CTCD2 has address 9.67.117.98, ifidx 503/22 08:51:06 INFO   :...read_physical_netif: index #6, interface LOOPBACK has address 127.0.0.1, ifidx 0",
                maxLines: 100,
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width - 100,
            top: MediaQuery.of(context).size.height - 180,
            child: InkWell(
              onTap: () {
                SocialShare.shareOptions(
                    "01 03/22 08:51:01 INFO   :.main: *************** BNE Guard ***************02 03/22 08:51:01 INFO   :...locate_configFile: Specified configuration file: /u/user10/rsvpd1.conf03/22 08:51:01 INFO   :.main: Using log level 51103/22 08:51:01 INFO   :..settcpimage: Get TCP images rc - EDC8112I Operation not supported on socket.0303/22 08:51:01 INFO   :..settcpimage: Associate with TCP/IP image name = TCPCS03/22 08:51:02 INFO   :..reg_process: registering process with the system03/22 08:51:02 INFO   :..reg_process: attempt OS/390 registration03/22 08:51:02 INFO   :..reg_process: return from registration rc=0 04 03/22 08:51:06 TRACE  :...read_physical_netif: Home list entries returned = 703/22 08:51:06 INFO   :...read_physical_netif: index #0, interface VLINK1 has address 129.1.1.1, ifidx 003/22 08:51:06 INFO   :...read_physical_netif: index #1, interface TR1 has address 9.37.65.139, ifidx 103/22 08:51:06 INFO   :...read_physical_netif: index #2, interface LINK11 has address 9.67.100.1, ifidx 203/22 08:51:06 INFO   :...read_physical_netif: index #3, interface LINK12 has address 9.67.101.1, ifidx 303/22 08:51:06 INFO   :...read_physical_netif: index #4, interface CTCD0 has address 9.67.116.98, ifidx 403/22 08:51:06 INFO   :...read_physical_netif: index #5, interface CTCD2 has address 9.67.117.98, ifidx 503/22 08:51:06 INFO   :...read_physical_netif: index #6, interface LOOPBACK has address 127.0.0.1, ifidx 001 03/22 08:51:01 INFO   :.main: *************** BNE Guard ***************02 03/22 08:51:01 INFO   :...locate_configFile: Specified configuration file: /u/user10/rsvpd1.conf03/22 08:51:01 INFO   :.main: Using log level 51103/22 08:51:01 INFO   :..settcpimage: Get TCP images rc - EDC8112I Operation not supported on socket.0303/22 08:51:01 INFO   :..settcpimage: Associate with TCP/IP image name = TCPCS03/22 08:51:02 INFO   :..reg_process: registering process with the system03/22 08:51:02 INFO   :..reg_process: attempt OS/390 registration03/22 08:51:02 INFO   :..reg_process: return from registration rc=0 04 03/22 08:51:06 TRACE  :...read_physical_netif: Home list entries returned = 703/22 08:51:06 INFO   :...read_physical_netif: index #0, interface VLINK1 has address 129.1.1.1, ifidx 003/22 08:51:06 INFO   :...read_physical_netif: index #1, interface TR1 has address 9.37.65.139, ifidx 103/22 08:51:06 INFO   :...read_physical_netif: index #2, interface LINK11 has address 9.67.100.1, ifidx 203/22 08:51:06 INFO   :...read_physical_netif: index #3, interface LINK12 has address 9.67.101.1, ifidx 303/22 08:51:06 INFO   :...read_physical_netif: index #4, interface CTCD0 has address 9.67.116.98, ifidx 403/22 08:51:06 INFO   :...read_physical_netif: index #5, interface CTCD2 has address 9.67.117.98, ifidx 503/22 08:51:06 INFO   :...read_physical_netif: index #6, interface LOOPBACK has address 127.0.0.1, ifidx 0");
              },
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(178, 19, 65, 67),
                radius: 30,
                child: Ink(
                  child: Icon(
                    Icons.share,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
