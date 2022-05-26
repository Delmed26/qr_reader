import 'package:flutter/material.dart';
import 'package:qr_reader/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  
  List<ScanModel> scans = [];

  String tipoSeleccionado = 'http';

  Future<ScanModel> newScan(String value) async {
    final scan = ScanModel(valor: value);

    final id = await DBProvider.db.newScan(scan);

    scan.id = id;

    if (tipoSeleccionado == scan.tipo) {
      scans.add(scan);
      notifyListeners();
    }

    return scan;
  }

  loadScans() async {
    final scans = await DBProvider.db.getScans();

    this.scans = [...?scans];
    notifyListeners();
  }

  loadScansByType(String tipo) async {
    final scans = await DBProvider.db.getScansByType(tipo);

    this.scans = [...?scans];
    tipoSeleccionado = tipo;
    notifyListeners();
  }

  deleteAll() async {
    await DBProvider.db.deleteScans();

    scans = [];
    notifyListeners();
  }

  deleteById(int? id) async {
    await DBProvider.db.deleteScan(id!);
  }

}