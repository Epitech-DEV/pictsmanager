import 'dart:async';
import 'dart:math';

import 'package:http/http.dart' as http;

class HttpStreamDownloader {
  final Future<http.StreamedResponse> response;
  List<int>? chunkData;

  HttpStreamDownloader(this.response);


 static int find(List<int> boundary, int start, List<int> content) {
    int strIndex = 0;
    int index = start;
    while (index < content.length) {
      if (content[index] == boundary[strIndex]) {
        strIndex++;
        if (strIndex == boundary.length) {
          return index - boundary.length + 1;
        }
      } else {
        strIndex = 0;
      }
      index++;
    }
    return -1;
  }

  // Return true if last chunk
  bool _parseChunk(List<int> chunk, List<List<int>> chunks) {
    int start = 0;
    int stop = find('\r\n'.codeUnits, start, chunk);
    if (stop == -1) {
      return true;
    }
    while (start < chunk.length || stop <= start) {
      String hexLen = String.fromCharCodes(chunk.sublist(start, stop));
      int? len = int.tryParse(hexLen, radix: 16);
      if (len == null) {
        throw Exception('Missing encoded length before chunk');
      }
      if (len == 0) {
        return true;
      }
      start = stop + 2;
      chunks.add(chunk.sublist(start, start + len));
      
      start = start + len + 2;
      stop = find('\r\n'.codeUnits, start, chunk);
    }
    return stop <= start;
  }

  Future<List<int>> download() {
    if (chunkData != null) {
      return Future.value(chunkData!);
    }

    List<int> data = [];
    Completer<List<int>> completer = Completer();
    response.asStream().listen((http.StreamedResponse response) {
      response.stream.listen((chunk) {
        data.addAll(chunk);
      }, onDone: () {
        List<int> finalData = [];
        List<List<int>> chunks = [];
        _parseChunk(data, chunks);
        for (List<int> subchunk in chunks) {
          finalData.addAll(subchunk);
        }
        chunkData = finalData;
        completer.complete(finalData);
      }, onError: (error) {
        completer.completeError(error);
      });
     });
    return completer.future;
  }
}