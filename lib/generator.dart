import 'dart:developer' as dev;
import 'dart:io';

import 'package:csv_generator/countryNumbers.dart';

class Generator {
  int rowCount;
  String file;
  String mobileColName;
  CountryNumber countryNumber;
  bool hasPrefix;

  int maxBatch = 10000; // 10k

  var buffer = <String>[];


  static generate(int rowCount, String mobileColName, String filePath, CountryNumber countryNumber, bool hasPrefix) async {
    dev.log("Generating $rowCount rows into file $filePath");
    var gen = Generator(rowCount, mobileColName, filePath, countryNumber, hasPrefix);
    return gen.saveFile();
  }

  Generator(this.rowCount, this.mobileColName, this.file, this.countryNumber, this.hasPrefix);

  saveFile() async {
    var file = File(this.file);
    if (await file.exists()) {
      await file.delete();
    }
    await file.create();
    await file.writeAsString("$mobileColName\n", mode: FileMode.append);

    int lastPerc = 0;

    for (var i = 0; i < rowCount; i++) {
      await addRow(file);
      int perc = ((i / rowCount) * 100).toInt();
      if (perc != lastPerc) {
        lastPerc = perc;
        dev.log('Processed $perc% ($i/$rowCount)');
      }
    }
    await writeBuffer(file);
  }

  addRow(File file) async {
    var n = countryNumber.generate(hasPrefix);
    buffer.add(n);

    if (buffer.length > maxBatch) {
      dev.log('Reached batch size - writing down');
      await writeBuffer(file);
    }
  }

  writeBuffer(File file) async {
    dev.log('Writing buffer');
    await file.writeAsString(buffer.join('\n'), mode: FileMode.append);
    buffer.clear();
  }

}