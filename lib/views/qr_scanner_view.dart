import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kou_navigation_project/core/open_url.dart';
import 'package:kou_navigation_project/theme/light_theme.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerView extends StatefulWidget {
  const QRCodeScannerView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeScannerViewState();
}

class _QRCodeScannerViewState extends State<QRCodeScannerView> {
  final _lightColor = LightColor();
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String appBarTitleText = "QR KOD OKUYUCU";
  bool isFlashOpen = false;
  bool alertState = true;

  void changeFlashState() {
    isFlashOpen = !isFlashOpen;
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    refreshingCamera();
  }

  void refreshingCamera() {
    var counter = 1;
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (counter == 0) {
        refreshCamera();
        timer.cancel();
      }
      counter--;
    });
  }

  void refreshCamera() async {
    await controller?.pauseCamera();
    await controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          textAlign: TextAlign.center,
          maxLines: 2,
          appBarTitleText,
          style: TextStyle(
            fontSize: (MediaQuery.of(context).size.width - 50) /
                (appBarTitleText.length + 10),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildQrView(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await controller?.toggleFlash();
          changeFlashState();
          setState(() {});
        },
        child: FutureBuilder(
          builder: (context, snapshot) {
            return isFlashOpen
                ? Icon(
                    Icons.flash_off,
                    color: Colors.white,
                  )
                : Icon(Icons.flash_on, color: Colors.white);
          },
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 20,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      if (result != null) {
        if (alertState) {
          showDialogs();
        }
      }
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void showDialogs() {
    alertState = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () async {
          alertState = true;
          return true;
        },
        child: AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 0),
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          title: Center(child: Text("OKUNAN BAĞLANTI")),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          content: _content(),
          actions: [_alertDialogActions()],
        ),
      ),
    );
  }

  Builder _content() {
    return Builder(
      builder: (context) {
        var width = MediaQuery.of(context).size.width * 0.9;
        return Container(
          //height: height,
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              result!.code!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
              ),
            ),
          ),
        );
      },
    );
  }

  Row _alertDialogActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          child: Text("İptal Et"),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(_lightColor.cancelRed)),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            alertState = true;
          },
        ),
        SizedBox(
          width: 10,
        ),
        ElevatedButton(
          child: Text(
            "Bağlantıyı Aç",
            style: TextStyle(),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            alertState = true;
            OpenUrl.openMap(result!.code!);
          },
        ),
      ],
    );
  }
}
