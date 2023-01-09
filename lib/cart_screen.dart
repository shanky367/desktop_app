import 'dart:convert';

import 'package:desktop_app/ApiConstants.dart';
import 'package:desktop_app/preview.dart';
import 'package:desktop_app/response_add_to_cart.dart';
import 'package:desktop_app/response_cart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';


class CartScreen extends StatefulWidget {
  static const String id = 'cart_screen';

  const CartScreen({required Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CartLines> cartItemsList = <CartLines>[];
  bool isLoading = false;


  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {
      await callapi();
    });

    super.initState();
  }

  Future<void> callapi() async {
    var a = await _fetchCartDetails();
  }

  _fetchCartDetails() async {
    setState(() {
      isLoading = true;
    });

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-channel-id': 'APP',
      'x-app-version': '3.8',
      'x-user-journey-id': '72a6d143-9775-4621-88b0-39e51ab4e9b2'
    };
    var url = Uri.https('api.ibo.com', 's/checkout/api/v2/cart',
        {'cartId': ApiConstants.CART_ID});
    final response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      // final jsonResponse = jsonDecode(response.body);
      final jsonResponse = json.decode(response.body);
      try {
        Iterable l = jsonResponse['cart_lines'];
        List<CartLines> posts =
            List<CartLines>.from(l.map((model) => CartLines.fromJson(model)));
        setState(() {
          cartItemsList.addAll(posts);
        });
      } catch (e) {
        cartItemsList.clear();
      }
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception("Failed to load Dogs Breeds.");
    }
    setState(() {
      isLoading = false;
    });
  }

  _removeCartItem(String cartLineId) async {
    setState(() {
      isLoading = false;
    });
//https://api.ibo.com/s/checkout/api/v2/cart/XCE2NkMJIpojx3G02aLz1COid347Ns07/cart-lines/44030349___NDQwMzAzNDk=
    Map<String, String> requestHeaders = {
      // 'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-channel-id': ApiConstants.JOURNEY_ID,
      'x-app-version': '3.8',
      'x-user-journey-id': ApiConstants.JOURNEY_ID
    };

    // {Accept: application/json, x-channel-id: APP, x-app-version: 3.8, content-type: application/x-www-form-urlencoded; charset=utf-8}
    // var url =Uri.parse('https://api.ibo.com/s/checkout/api/v2/cart/XCE2NkMJIpojx3G02aLz1COid347Ns07/cart-lines/$cartLineId/');
    // var url =Uri.parse('https://api.ibo.com/s/checkout/api/v2/');
    // var url = Uri.https('api.ibo.com', 's/checkout/api/v2/');
    // var url = Uri.https('api.ibo.com', 's/checkout/api/v2/cart/XCE2NkMJIpojx3G02aLz1COid347Ns07/cart-lines/$cartLineId');
    //  final response = await http.delete(url, headers: requestHeaders,body: {
    //    'cart':'XCE2NkMJIpojx3G02aLz1COid347Ns07',
    //    'cart-lines/':'$cartLineId',
    //
    //  });

    final http.Response response = await http.delete(
      Uri.parse(
          'https://api.ibo.com/s/checkout/api/v2/cart/${ApiConstants.CART_ID}/cart-lines/$cartLineId'),
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      // final jsonResponse = jsonDecode(response.body);
      final jsonResponse = json.decode(response.body);
      try {
        Iterable l = jsonResponse['alerts'];
        List<Alerts> posts =
            List<Alerts>.from(l.map((model) => Alerts.fromJson(model)));
        if (posts.length == 0) {
          showInSnackBar("Item deleted successfully");
          setState(() {
            Navigator.pop(context);
          });
        } else {
          showInSnackBar("${posts[0].alertType}");
        }
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        throw Exception("Add to cart not possible");
      }
      setState(() {
        isLoading = false;
      });
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showInSnackBar("${response.statusCode}");
      throw Exception("Failed to load Dogs Breeds.");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: const Color(0xffffffff),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Color(0xffffffff)),
              centerTitle: true,
              title: const Text(
                'Cart',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffffffff)),
              ),
              backgroundColor: const Color(0xffff0000),
            ),
            body: isLoading
                ? Center(child: const CircularProgressIndicator())
                : _searchContent(),
          ));
  }

  Widget _searchContent() {
    return cartItemsList.length != 0
        ? Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cartItemsList.length,
                  itemBuilder: (context, index) {
                    var img =
                        cartItemsList[index].items?.primaryImageUrl?.toString();
                    double? c = 0.0;
                    if (cartItemsList[index].prices?.length != 0) {
                      cartItemsList[index].prices?.forEach((PricesRU price) {
                        if (price.type == "PRICE_INCL_TAX") {
                          double? a = price.price?.centAmount?.toDouble();
                          double? b = price.price?.fraction?.toDouble();
                          c = (a! / b!);
                          print(c.toString());
                        }
                      });
                    }

                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Card(
                        color: Colors.blue.shade100,
                        child: ListTile(
                            onTap: () {
                              showInSnackBar(
                                  "${cartItemsList[index].items?.displayName}");
                            },
                            tileColor: Colors.white,
                            contentPadding: const EdgeInsets.all(20),
                            leading: Image.network(img!),
                            title: Text(
                                '${cartItemsList[index].items?.displayName}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "₹$c",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                Container(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    _removeCartItem(cartItemsList[index]
                                        .cartLineId
                                        .toString());
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      const ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        title: Text("MRP value",style: TextStyle(fontSize: 20,color: Colors.black),),
                        trailing:Text("1000",style: TextStyle(fontSize: 20,color: Colors.grey),) ,
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        title: Text("Discount on MRP",style: TextStyle(fontSize: 20,color: Colors.black),),
                        trailing:Text("500",style: TextStyle(fontSize: 20,color: Colors.grey),) ,
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        title: Text("IBO price",style: TextStyle(fontSize: 20,color: Colors.black),),
                        trailing:Text("1200",style: TextStyle(fontSize: 20,color: Colors.grey),) ,
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        title: Text("Additional discount",style: TextStyle(fontSize: 20,color: Colors.black),),
                        trailing:Text("200",style: TextStyle(fontSize: 20,color: Colors.grey),) ,
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        title: Text("Total to pay",style: TextStyle(fontSize: 28,color: Colors.black),),
                        trailing:Text("3500",style: TextStyle(fontSize: 28,color: Colors.grey),) ,
                      ),
                      Container(height: 20,),
                      Card(
                        child: InkWell(
                          onTap:(){
                            setState(() {
                              Navigator.of(context).pushNamed(PdfPreview11.id);
                            });
                          },
                          child: Container(
                              color: Colors.red,
                              height: 55,
                              child: const Center(
                                  child: Text("Print",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)))),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        : const Center(
            child: Text("No items added in cart"),
          );
  }

  void showInSnackBar(String value) {
    final snackBar = SnackBar(
      content: Text(value),
      backgroundColor: (Colors.black),
      // action: SnackBarAction(
      //   label: 'dismiss',
      //   onPressed: () {
      //   },
      // ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(value)));
  }

}
