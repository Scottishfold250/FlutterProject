import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/ProductModel.dart';


class FirstScreenApp extends StatefulWidget {
  @override
  _FirstScreenAppState createState() => _FirstScreenAppState();
}


class _FirstScreenAppState extends State<FirstScreenApp> {
  Future<List<ProductsModel>>? loadedData;
  Future<List<ProductsModel>> _getElectronics() async {
    var url = "https://fakestoreapi.com/products";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // success
      List decodedResponse = json.decode(response.body);

      // var d=decodedResponse.map((data) => ProductsModel.fromJson(data)).toList();
      print(decodedResponse[1]);
      return decodedResponse
          .map((data) => ProductsModel.fromJson(data))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loadedData = _getElectronics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: () {},
              icon: const Icon(Icons.shopping_cart)),
          IconButton(onPressed: () {},
              icon: const Icon(Icons.view_list)),
        ],
      ),
      body: FutureBuilder<List<ProductsModel>>(

        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error " + snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  child: Card(
                    elevation: 10,
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Image.network(snapshot.data![index].image!,
                            height: 50,
                            width: 50,),
                            SizedBox(
                              height: 30,
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                    "Name : " + snapshot.data![index].title!,
                                    overflow: TextOverflow.ellipsis,
                                    ),
                                Text("Category : " +
                                    snapshot.data![index].category!),
                                Text("Price :  ${snapshot.data![index].price!} \$"),

                              ],
                            ),
                          ],
                        )),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        future: loadedData,
      ),
    );
  }
}