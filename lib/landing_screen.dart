import 'dart:convert';

import 'package:desktop_app/cart_screen.dart';
import 'package:desktop_app/response_add_to_cart.dart';
import 'package:desktop_app/response_cart_model.dart';
import 'package:desktop_app/response_model_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ApiConstants.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing_screen';

  const LandingScreen({required Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  TextEditingController editingController = TextEditingController();
  List<Products> mainlist = <Products>[];
  List<Products> tempList = <Products>[];
  List<CartLines> cartItemsList = <CartLines>[];
  bool isLoading = false;
  int qty = 1;
  String? noData = "No products available!";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {
      await _fetchCartDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
          iconTheme: IconThemeData(color: const Color(0xffffffff)),
          centerTitle: true,
          title: InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => LandingScreen(
                          key: null,
                        )),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text(
              'IBO',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 20.0),
              child: Stack(
                children: <Widget>[
                  IconButton(
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).pushNamed(CartScreen.id);
                        });
                      }),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '${cartItemsList.length == 0 ? 0 : cartItemsList.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
          backgroundColor: const Color(0xffff0000),
        ),
        drawer: Drawer(
          backgroundColor: const Color(0xffffffff),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: const Color(0xffff0000)),
                accountName: Text(
                  "IBO user",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  "user@ibo.com",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentAccountPicture: FlutterLogo(),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                ),
                title: const Text('Page 1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.train,
                ),
                title: const Text('Page 2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : _searchContent()),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              showInSnackBar("Connect device for scan");
            });
          },
          backgroundColor: const Color(0xffffffff),
          child: Icon(
            Icons.qr_code,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _searchContent() {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 30.0, right: 30, top: 20, bottom: 20),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.search,
                color: editingController.text.length > 0
                    ? Colors.lightBlueAccent
                    : Colors.grey,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Stack(
                    alignment: const Alignment(1.0, 1.0),
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(hintText: 'Search'),
                        onChanged: (text) {
                          setState(() {
                            if (text.length > 8 ||
                                text.length > 10 ||
                                text.length > 12 ||
                                text.length > 13) {
                              _fetchDogsBreed(text.toString());
                            }
                            print(text);
                          });
                        },
                        controller: editingController,
                      ),
                      editingController.text.length > 0
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  editingController.clear();
                                  mainlist.clear();
                                  tempList.clear();
                                });
                              })
                          : Container(
                              height: 0.0,
                            )
                    ]),
              ),
            ],
          ),
        ),
        mainlist.length != 0
            ? Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: mainlist.length,
                  itemBuilder: (context, index) {
                    var img =
                        mainlist[index].media?.primaryImageUrl?.toString();
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Card(
                        color: Colors.blue.shade100,
                        child: ListTile(
                            onTap: () async {
                              double? c;
                              mainlist[index]
                                  .prices
                                  ?.forEach((PricesRupee price) {
                                if (price.type == "PRICE_INCL_TAX") {
                                  double? a =
                                      price.price?.centAmount?.toDouble();
                                  double? b = price.price?.fraction?.toDouble();
                                  c = (a! / b!);
                                  print(c.toString());
                                }
                              });

                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return CustomDialogBox(
                                      price: c,
                                      title: mainlist[index]
                                          .displayName
                                          .toString(),
                                      descriptions:
                                          mainlist[index].esin.toString(),
                                      text: "Add to cart",
                                      offerId:
                                          mainlist[index].offerId.toString(),
                                      img: img!,
                                    );
                                  });
                            },
                            tileColor: Colors.white,
                            contentPadding: const EdgeInsets.all(20),
                            leading: Image.network(img!),
                            title: Text(mainlist[index].displayName.toString()),
                            subtitle: Text(mainlist[index].esin.toString()),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                            )),
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: Text("$noData"),
              )
      ],
    );
  }

  _fetchDogsBreed(String? searchTerm) async {
    setState(() {
      isLoading = true;
    });
    tempList = <Products>[];
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-channel-id': ApiConstants.CHHANEL_NAME,
      'x-app-version': '3.8'
    };
    var url = Uri.https('api.ibo.com', 's/catalog/api/v2/search-results', {
      'search_term': '$searchTerm',
      'post_code': '560001',
      'c_id': 'nvwg1si7'
    });
    final response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      // final jsonResponse = jsonDecode(response.body);
      final jsonResponse = json.decode(response.body);
      // Map<String, dynamic> userMap = jsonResponse['products'];
      // userMap;
      // var user = ResponseModelProducts.fromJson(jsonResponse['products']);
      // user;

      try {
        Iterable l = jsonResponse['products'];
        List<Products> posts =
            List<Products>.from(l.map((model) => Products.fromJson(model)));
        tempList.addAll(posts);
        posts;
      } catch (e) {
        tempList.clear();
      }

      //var data = json.decode(res.body);
      //  var rest = data["articles"] as List;
      //         print(rest);
      //         list = rest.map<Article>((json) => Article.fromJson(json)).toList();
      //       }
      //     print("List Size: ${list.length}");

      //   jsonResponse['products'].forEach((breed,subbreed){
      //   dogsBreedList.addAll(jsonResponse);
      // });
      tempList;
    } else {
      setState(() {
        showInSnackBar("$noData");
        isLoading = false;
      });
      throw Exception("Failed to load Dogs Breeds.");
    }
    setState(() {
      mainlist = tempList;
      isLoading = false;
    });
  }

  _fetchCartDetails() async {
    // https://api.ibo.com/s/checkout/api/v2/cart?cartId=WwRCyyvD4JMrNTVENLc33SQZCNkf2xeg

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-channel-id': ApiConstants.CHHANEL_NAME,
      'x-app-version': '3.8'
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
    } else {
      throw Exception("Failed to load Dogs Breeds.");
    }
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

// Widget _buildPopupDialog(BuildContext context,int? index,String title,String esin,String img) {
//   return AlertDialog(
//     title:  Text(title.toString()),
//     content:Column(
//     //  mainAxisAlignment: MainAxisAlignment.center,
//      // crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//               height: 300,
//               width: 300,
//               child: Image.network(img!)),
//         ),
//         Card(
//           elevation: 1.0,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: <Widget>[
//                 _decrementButton(),
//                 Text(
//                   '$qty',
//                   style: TextStyle(fontSize: 18.0),
//                 ),
//                 _incrementButton(),
//               ],
//             ),
//           ),
//         ),
//
//
//       ],
//     ),
//     actions: <Widget>[
//    ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.shopping_cart), label: Text('Add to Cart')),
//    ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.cancel), label: Text('Cancel'))
//     ],
//   );
// }

}

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text, offerId;
  final String img;
  final double? price;

  const CustomDialogBox(
      {required this.title,
      required this.price,
      required this.descriptions,
      required this.offerId,
      required this.text,
      required this.img})
      : super();

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  int qty = 1;
  TextEditingController editingController = TextEditingController();
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
double? finalPrice=0.0;
  @override
  void initState() {
    editingController.text = qty.toString();
    double? p=widget.price;
    double? myInteger = (qty*p!);
    finalPrice=(myInteger) as double?;
    super.initState();
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

  _addToCart(int qty, String offerId) async {
    setState(() {
      isLoading = true;
    });

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-channel-id': ApiConstants.CHHANEL_NAME,
      'x-app-version': '3.8'
    };
    var match = {
      "cart_lines": [
        {"offer_id": "$offerId", "quantity": 1}
      ],
      "post_code": "582101"
    };
    //{cart_lines: [{offer_id: "1000159379", quantity: 1}], post_code: "582101"}
    // jsonEncode(<String, String>{
    //       'cart_lines': '[{offer_id: "${offerId}", quantity: ${qty}], post_code: "560001"',
    //     });
    var url = Uri.https('api.ibo.com', 's/checkout/api/v2/cart',
        {'cartId': ApiConstants.CART_ID});
    final response = await http.post(url,
        headers: requestHeaders,
        body: json.encode(match),
        encoding: Encoding.getByName("utf-8"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      // final jsonResponse = jsonDecode(response.body);
      final jsonResponse = json.decode(response.body);
      try {
        Iterable l = jsonResponse['alerts'];
        List<Alerts> posts =
            List<Alerts>.from(l.map((model) => Alerts.fromJson(model)));
        if (posts.length == 0) {
          showInSnackBar("Item added successfully");
          setState(() {
            Navigator.pop(context);
          });
        } else {
          showInSnackBar("${posts[0].alertType}");
          setState(() {
            Navigator.pop(context);
          });
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
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception("Add to cart not possible");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 10),
                          blurRadius: 10),
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 300,
                              width: 300,
                              child: Image.network(widget.img)),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.title,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.descriptions,
                                style: TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "₹${widget.price}",
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "₹$finalPrice",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.grey,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Card(
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _decrementButton(),
                              Container(
                                padding: const EdgeInsets.all(8),
                                width: 100,
                                child: Center(
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    cursorHeight: 25,
                                    cursorRadius: Radius.circular(10),
                                    maxLines: 1,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration:
                                        InputDecoration(hintText: 'qty'),
                                    onChanged: (text) {
                                      setState(() {
                                        if (text.length == 0) {
                                          qty = 1;
                                        } else {
                                          var myInt = int.parse(text);
                                          qty = myInt;
                                          print(text);
                                        }
                                        double? p=widget.price;
                                        double? myInteger = (qty*p!);
                                        finalPrice=(myInteger) as double?;
                                      });
                                    },
                                    controller: editingController,
                                  ),
                                ),
                              ),
                              _incrementButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              elevation: 1.0,
                              child: Container(
                                height: 55,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton.icon(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.cancel),
                                      label: Text('Cancel')),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 1.0,
                              child: Container(
                                height: 55,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton.icon(
                                      onPressed: () async {
                                        await _addToCart(qty, widget.offerId);
                                      },
                                      icon: Icon(Icons.shopping_cart),
                                      label: Text('${widget.text}')),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          );
  }

  Widget _decrementButton() {
    return FloatingActionButton(
        onPressed: () {
          setState(() {
            if(qty==0){
              qty+1;
              editingController.text = qty.toString();
              double? p=widget.price;
              double? myInteger = (qty*p!);
              finalPrice=(myInteger) as double?;
            }else{
              qty--;
              editingController.text = qty.toString();
              double? p=widget.price;
              double? myInteger = (qty*p!);
              finalPrice=(myInteger) as double?;
            }

          });
        },
        child: Icon(Icons.remove, color: Colors.black87),
        backgroundColor: Colors.white);
  }

  Widget _incrementButton() {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Colors.black87),
      backgroundColor: Colors.white,
      onPressed: () {
        setState(() {
          qty++;
          editingController.text = qty.toString();
          double? p=widget.price;
          double? myInteger = (qty*p!);
          finalPrice=(myInteger) as double?;
        });
      },
    );
  }
}
