import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/utils/utils.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      onPressed: () async {

        String res = await FlutterBarcodeScanner.scanBarcode('#3D8BEF', 'Cancel', false, ScanMode.QR);
        // const res = 'geo:28.695873,-100.537109';

        if (res == '-1') return;

        final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);

        final scan = await scanListProvider.newScan(res);

        launchUrlScan(context, scan);

      },
      child: const Icon(Icons.filter_center_focus),
    );
  }
}