import 'package:flutter/material.dart';
import 'package:flutter_speedtest/flutter_speedtest.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _speedtest = FlutterSpeedtest(
    baseUrl:
        'https://velocimetro-amr.virtua.com.br.prod.hosts.ooklaserver.net:8080',
    pathDownload: '/download',
    pathUpload: '/upload',
    pathResponseTime: '/ping',
  );

  double _progressDownload = 0;
  double _progressUpload = 0;

  int _ping = 0;
  int _jitter = 0;
  String _pingError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("Infinity Speed Teste"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Download: ${_progressDownload.toStringAsPrecision(3)} Mb/s',
            style: const TextStyle(
              color: Colors.green,
              fontSize: 35,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'upload: ${_progressUpload.toStringAsPrecision(3)} Mb/s',
            style: const TextStyle(
              color: Colors.green,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Ping: $_ping',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 35,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Jitter: $_jitter',
            style: const TextStyle(
                color: Colors.blue, fontSize: 25, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          _ping > 50
              ? Text(
                  'Alta Latencia',
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                )
              : Text(
                  "Latencia dentro do normal",
                  style: const TextStyle(
                      color: Colors.green,
                      fontSize: 30,
                      fontWeight: FontWeight.w500),
                ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              _speedtest.getDataspeedtest(
                downloadOnProgress: ((percent, transferRate) {
                  setState(() {
                    _progressDownload = transferRate;
                  });
                }),
                uploadOnProgress: ((percent, transferRate) {
                  setState(() {
                    _progressUpload = transferRate;
                  });
                }),
                progressResponse: ((responseTime, jitter) {
                  setState(() {
                    _ping = responseTime;
                    print(_ping);
                    _jitter = jitter;
                  });
                }),
                onError: ((errorMessage) {
                  setState(() {
                    _pingError = errorMessage;
                  });
                  print(errorMessage);
                }),
                onDone: () => debugPrint('Host Indisponivel'),
              );
            },
            child: const Text(
              'Iniciar Teste',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      )),
    );
  }
}
