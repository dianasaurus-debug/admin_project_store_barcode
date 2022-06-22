import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ghulam_app/utils/constants.dart';
import 'package:ghulam_app/widgets/custom_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadAlert extends StatefulWidget {
  final String url;
  final String path;

  DownloadAlert({Key? key, required this.url, required this.path})
      : super(key: key);

  @override
  _DownloadAlertState createState() => _DownloadAlertState();
}

class _DownloadAlertState extends State<DownloadAlert> {
  Dio dio = new Dio();
  int received = 0;
  String progress = '0';
  int total = 0;
  // ignore: prefer_typing_uninitialized_variables
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'));
  }

  download() async {
    await _getToken();
    var headers = {
      'accept': 'application/json',
      'Authorization' : 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    };
    await dio.download(
      widget.url,
      widget.path,
      deleteOnError: true,
      options: Options(method: "GET", headers: headers),
      onReceiveProgress: (receivedBytes, totalBytes) {
        print(totalBytes);
        setState(() {
          received = receivedBytes;
          total = totalBytes;
          progress = (received / total * 100).toStringAsFixed(0);
        });

        //Check if download is complete and close the alert dialog
        if (receivedBytes == totalBytes) {
          Navigator.pop(context, '${formatBytes(total, 1)}');
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    download();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: CustomAlert(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Downloading...',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 20.0),
              Container(
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: LinearProgressIndicator(
                  value: double.parse(progress) / 100.0,
                  valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).colorScheme.secondary),
                  backgroundColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$progress %',
                    style: TextStyle(
                      fontSize: 13.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${formatBytes(received, 1)} '
                        'of ${formatBytes(total, 1)}',
                    style: TextStyle(
                      fontSize: 13.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}