import 'dart:ui';

import 'package:buget_tracker_app/model/deal_model.dart';
import 'package:buget_tracker_app/responsive.dart';
import 'package:buget_tracker_app/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:intl/intl.dart';

class DealScreen extends StatelessWidget {
  // final List<Deal> dealList;
  // const DealScreen({Key? key, required this.dealList}) : super(key: key);
  const DealScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    List<Deal>dealList = arguments['dealList'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Deals'),
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
                      mobile:
                          mobileListBuilder(MediaQuery.of(context).size.height, dealList),
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
  const DealCard({Key? key, required this.deal}) : super(key: key);

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
              Header(themeStyle, 'Title: '),
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
