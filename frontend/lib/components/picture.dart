import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/models/picture.dart';
import 'package:frontend/utils/http_stream_downloader.dart';
import 'package:frontend/views/picture.dart';
import 'package:http/http.dart' as http;

import '../repositories/api.dart';

class Picture extends StatefulWidget {
  const Picture({required this.data, Key? key}) : super(key: key);

  final PictureData data;
  @override
  State<Picture> createState() => _PictureState();
}

class _PictureState extends State<Picture> {
  late HttpStreamDownloader downloader;

  void viewImage(BuildContext context, List<int>? image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PictureView(
            data: widget.data,
            image: image,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    var httpClient = http.Client();
    var request = http.Request(
      'GET',
      Uri.parse('${ApiDatasource.baseUrl}/pictures/download/${widget.data.path}'),
    );
    request.headers.addAll(ApiDatasource.instance.headers!);
    var response = httpClient.send(request);

    downloader = HttpStreamDownloader(response);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: downloader.download(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(color: Colors.red);
        }
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return InkWell(
          onTap: () {
            viewImage(context, snapshot.data);
          },
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.memory(
                Uint8List.fromList(snapshot.data!),
              ),
            ),
          ),
        );
      },
    );
  }
}
