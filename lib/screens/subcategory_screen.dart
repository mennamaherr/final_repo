import 'package:flutter/material.dart';
import 'package:onservice/models/cardinfo_model.dart';
import 'package:onservice/widgets/selectD&T_widget.dart';
import 'package:onservice/widgets/serviceCard_widget.dart';

class SubCategoryScreen extends StatelessWidget {
  SubCategoryScreen({super.key});
  final List<CardinfoModel> cardlist = [
    CardinfoModel(
        cost: '150 EGP',
        image: 'assets/Landscaping_Service/Lawn_Mowing.jpeg',
        rate: '4.9',
        service: 'Lawn Mowing'),
    CardinfoModel(
        cost: '200 EGP',
        image: 'assets/Landscaping_Service/Garden_Cleaning.jpeg',
        rate: '4.7',
        service: 'Garden Cleaning'),
    CardinfoModel(
        cost: '250 EGP',
        image: 'assets/Landscaping_Service/Planting.jpeg',
        rate: '4.8',
        service: 'Planting Flowers'),
    CardinfoModel(
        cost: '300 EGP',
        image: 'assets/Landscaping_Service/Tree_Trimming.jpeg',
        rate: '4.6',
        service: 'Tree Trimming'),
    CardinfoModel(
        cost: '180 EGP',
        image: 'assets/Landscaping_Service/Sod_Installation.jpeg',
        rate: '4.8',
        service: 'Sod Installation'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Landscaping Services',
            style: TextStyle(fontSize: 24, fontFamily: 'Inter'),
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Divider(
              thickness: 1,
              color: Color(0xffEFEFEF),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cardlist.length,
                itemBuilder: (BuildContext context, int index) {
                  return servicesCard_widget(
                      mycard: cardlist[index],
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return ModelBottomSheet(
                                image: cardlist[index].image,
                                name: cardlist[index].service,
                              );
                            });
                      });
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class ServicesCardWidget extends StatelessWidget {
  final CardinfoModel mycard;
  final VoidCallback onTap;

  const ServicesCardWidget(
      {super.key, required this.mycard, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Image.asset(
          mycard.image ?? 'assets/default_image.jpeg',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(mycard.service ?? 'Service'),
        subtitle: Text('${mycard.cost} - ${mycard.rate}'),
        onTap: onTap,
      ),
    );
  }
}
