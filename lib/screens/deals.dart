// import 'dart:convert';
// import 'dart:ui';

import 'dart:convert';
// import 'dart:io';

import 'package:buget_tracker_app/model/deal_model.dart';
import 'package:buget_tracker_app/model/sentiment_model.dart';
import 'package:buget_tracker_app/responsive.dart';
import 'package:buget_tracker_app/services/theme_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:html' as webFile;
// import 'package:file_picker_web/file_picker_web.dart' as webPicker;

// import 'dart.io';

class DealScreen extends StatelessWidget {
  // final List<Deal> dealList;
  // const DealScreen({Key? key, required this.dealList}) : super(key: key);
  const DealScreen({Key? key}) : super(key: key);

  writeContent(String text) async {
    if (kIsWeb) {
      // loop the object and concatenate with \n in it to produce a string
      // have one result string

      var blob = webFile.Blob(['test\n65 5 20'], 'text/plain', 'native');

      var anchorElement = webFile.AnchorElement(
        href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
      )
        ..setAttribute('download', 'contents.txt')
        ..click();
    }
    if (kIsWeb) {
      var blob = webFile.Blob(['SAVE savefile.txt'], 'text/plain', 'native');

      var anchorElement = webFile.AnchorElement(
        href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
      )
        ..setAttribute('download', 'command.txt')
        ..click();
    }
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    List<Deal> dealList = arguments['dealList'];
    String dealItem = arguments['item'];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Deals for ' + dealItem),
        actions: [
          // Text("test"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: TextButton(
                  child: Text(
                    'Export',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    writeContent("Test");
                  }
                  // icon: const Icon(Icons.attach_money),
                  ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 10,),
                    Responsive(
                      mobile: mobileListBuilder(
                          MediaQuery.of(context).size.height, dealList),
                      tablet: mobileListBuilder(450, dealList),
                      desktop: desktopBuilder(dealList),
                    ),
                  ]),
              // child: ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: dealList.length,
              //     physics: const ClampingScrollPhysics(),
              //     itemBuilder: (context, index) {
              //       return DealCard(
              //         deal: dealList[index],
              //       );
              //     }),
            ),
          ),
        ),
      ),
    );
  }

  Widget mobileListBuilder(double height, dealList) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: dealList.length,
        itemBuilder: (context, index) {
          return DealCard(deal: dealList[index]);
        },
      ),
    );
  }

  Widget desktopBuilder(dealList) {
    return GridView.builder(
        shrinkWrap: true,
        // physics: ScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          // mainAxisExtent: 1000,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: dealList.length,
        itemBuilder: (context, index) {
          return SingleChildScrollView(child: DealCard(deal: dealList[index]));
        });
  }
}

class DealCard extends StatelessWidget {
  final Deal deal;
  DealCard({Key? key, required this.deal}) : super(key: key);

  fetchData1(query) async {
    final res = await http.get(
        Uri.parse(
            "https://projectmicroservices-7uy7oyn5ia-uc.a.run.app/sentiment/$query"),
        // Uri.parse("http://192.168.0.13:5000/sentiment/$query"),
        headers: {"Access-Control-Allow-Origin": "*"});
    if (res.statusCode == 200) {
      // List<Deal> retList = [];
      // title, description, price, value, discount_amount, url, image_url
      var jsonReturn = json.decode(res.body);
      print(jsonReturn);
      Sentiment sentiment = Sentiment.fromJson(jsonReturn);
      return sentiment;
      // return jsonDecode(response.body);
    } else {
      // Dialog(
      //   child: Text('Could not find sentiment'),
      // );
      throw Exception('failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    // DateTime timestamp = DateTime.parse(deal.expiresAt);
    // print(timestamp);
    var themeStyle = true;
    context.read<ThemeService>().darkTheme == true
        ? themeStyle = true
        : themeStyle = false;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width / 1.25,
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurpleAccent.withOpacity(0.5),
                  offset: const Offset(0, 25),
                  blurRadius: 50,
                )
              ],
            ),
            child: Image.network(
              deal.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Header(themeStyle, 'Title: '),
                  Spacer(),
                  Container(
                    // padding: EdgeInsets.only(right: 10),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    child: TextButton(
                        onPressed: () async {
                          var sentiment = await fetchData1(deal.title);
                          await showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  SentimentBottomSheet(sentiment: sentiment));
                        },
                        child: Text("Show Sentiment")),
                  ),
                ],
              ),
              // Header(themeStyle, 'Title: '),
              Text(
                deal.title,
                style: TextStyle(fontSize: 18),
              ),
              Header(themeStyle, 'Description: '),
              ReadMoreText(
                deal.description,
                style: themeStyle == true
                    ? TextStyle(color: Colors.white)
                    : TextStyle(color: Colors.black),
                trimLines: 2,
                moreStyle: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
                lessStyle: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              Header(themeStyle, 'Value: '),
              Text(
                deal.value.toString(),
              ),
              Header(themeStyle, 'Discount Amount: '),
              Text(
                deal.discountAmount.toString(),
              ),
              Header(themeStyle, 'Price: '),
              Text(
                deal.price.toString(),
              ),
              Header(themeStyle, 'Expires: '),
              Text(
                // timestamp.toString(),
                deal.expiresAt,
              ),
              Header(themeStyle, 'URL: '),
              Text(
                deal.url,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

// title, description, price, value, discount_amount, url, image_url

Widget Header(themeStyle, label) {
  return Text(
    label,
    style: themeStyle == true
        ? const TextStyle(
            color: Color.fromARGB(255, 204, 186, 235),
            fontSize: 18,
            fontWeight: FontWeight.bold)
        : const TextStyle(
            color: Color.fromARGB(255, 101, 28, 226),
            fontSize: 18,
            fontWeight: FontWeight.bold),
  );
}

class SentimentBottomSheet extends StatefulWidget {
  const SentimentBottomSheet({Key? key, required this.sentiment})
      : super(key: key);
  final Sentiment sentiment;

  @override
  State<SentimentBottomSheet> createState() => _SentimentBottomSheetState();
}

class _SentimentBottomSheetState extends State<SentimentBottomSheet> {
  // String? comment = '';
  // TextEditingController commentsTEC = TextEditingController();
  // bool anonymous = false;

  @override
  Widget build(BuildContext context) {
    double positiveSent = widget.sentiment.compound * 100;

    if (positiveSent == 50) {}
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sentiment Analysis",
                      style: TextStyle(fontSize: 48),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SentimentContainer('Negative', Colors.red[300]),
                    SentimentContainer(
                        widget.sentiment.negative.toString(), Colors.red[300])
                    // Text("Negative: "),
                    // Spacer(),
                    // Text(widget.sentiment.negative.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SentimentContainer('Neutral', Colors.blueGrey[600]),
                    SentimentContainer(widget.sentiment.neutral.toString(),
                        Colors.blueGrey[600])
                    // Text("Neutral: "),
                    // Spacer(),
                    // Text(widget.sentiment.neutral.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SentimentContainer('Positive', Colors.greenAccent),
                    SentimentContainer(widget.sentiment.positive.toString(),
                        Colors.greenAccent)
                    // Text("Positive: "),
                    // Spacer(),
                    // Text(widget.sentiment.positive.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SentimentContainer(
                        "Overall Sentiment is: " +
                            positiveSent.toString() +
                            '% positive!',
                        positiveSent > 50
                            ? Colors.greenAccent
                            : positiveSent < 50
                                ? Colors.red[300]
                                : Colors.blueGrey)
                    // Text("Overall Sentiment is: " +
                    //     positiveSent.toString() +
                    //     '% positive!'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget SentimentContainer(text, color) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(border: Border.all(), color: color),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: TextStyle(fontSize: 32)),
      ),
    ),
  );
}

// Widget CalcColor(sentimentScore) {
//   if (sentimentScore > 50) {
//     return Colors.blueGrey;
//   } else if (sentimentScore > 50) {
//     return Colors.greenAccent;
//   } else {
//     return Colors.red;
//   }
// }
