import 'dart:io';


import 'package:agile_market/ui/payment_add_pag.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:credit_card/credit_card_form.dart';
import 'package:credit_card/credit_card_model.dart';
import 'package:credit_card/credit_card_widget.dart';
import 'package:credit_card/flutter_credit_card.dart';
import 'dart:math';

import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

var random = Random.secure();

final produtos = <Map<String, dynamic>>[
  {
    "codigo": "7899716311295",
    "nome_produto": "Pelicula iphone 7",
    "valor": 65.00
  },
  {"codigo": "7894900330014", "nome_produto": "Aquarius fresh", "valor": 3.50},
  {
    "codigo": "7894900010015",
    "nome_produto": "Coca-cola Lata 350ml",
    "valor": 2.50
  },
  {"codigo": "190198407498", "nome_produto": "Iphone 7", "valor": 2000},
  {
    "codigo": "7896806700076",
    "nome_produto": "Talco Barla 140g",
    "valor": 7.03
  }, {
    "codigo": "7891000061190",
    "nome_produto": "Nescau 200g",
    "valor": 5.00
  },{
    "codigo": "7891048038055",
    "nome_produto": "Chá Dr.Oetker 10g",
    "valor": 5.00
  },
];

const MAX_PRODUTO = 10;
List<Map<String, dynamic>> meusprodutos = <Map<String, dynamic>>[];

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  String barcode = "";
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    this.tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
        centerTitle: false,
        backgroundColor: Colors.white, //teste
        title: Text(
          'Checkout',
          style: TextStyle(color: Colors.blue),
        ),

        bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Colors.blue,
            indicator: BubbleTabIndicator(
                indicatorHeight: 36.0,
                indicatorColor: Colors.blue,
                tabBarIndicatorSize: TabBarIndicatorSize.tab),
            controller: tabController,
            tabs: <Widget>[
              Tab(
                text: "Produtos",
              ),
              Tab(
                text: "Metodo de Pagamento",
              )
            ]),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Felipe de Luca"),
              accountEmail: Text("felipedelucanogueira@gmail.com"),
              currentAccountPicture: Container(
                height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        'https://graph.facebook.com/2656653767762160/picture'),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Cadastro de Cartão",
              ),
              leading: Icon(Icons.credit_card),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Payment()));
              },
            ),
            ListTile(
              title: Text("Fale Conosco"),
              leading: Icon(Icons.phone_in_talk),
              onTap: () {
                FlutterOpenWhatsapp.sendSingleMessage("5599982002450",
                    "Olá Agile Market estou com Problema ao usar o app");
              },
            ),
            ListTile(
              title: Text("LogOut"),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                exit(0);
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: <Widget>[Scan_Product(), payment_method()],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Container(
          height: 56,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: RaisedButton(
              onPressed: meusprodutos.isNotEmpty ? _confirmarCompra : null,
              child: Text("Confirmar Compra"),
              color: Colors.blue,
              textColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future barcodeScanning() async {
    final barcode = await BarcodeScanner.scan();
    final produto = produtos.firstWhere((produto) {
      return produto["codigo"] == barcode;
    }, orElse: () => null);
    if (produto != null) {
      meusprodutos.add(produto);
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Produto nao Encontrado"),
            content: Text("Produto nao Cadastrado no Sistema"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget Product_List(
      int id, bool isDefault, String nome_prod, String valor, String codigo) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      height: 116,
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              nome_prod,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Text(
              valor,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              codigo,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }

  Widget Scan_Product() {
    return Container(
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 10, top: 15, bottom: 15),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.blue,
                      ),
                      Text(
                        "  CARRINHO - ${meusprodutos.length} de $MAX_PRODUTO",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            ],
          ),
          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: meusprodutos.length,
                itemBuilder: (context, index) {
                  final produto = meusprodutos[index];
                  return Dismissible(
                    // Each Dismissible must contain a Key. Keys allow Flutter to
                    // uniquely identify widgets.
                    key: Key(UniqueKey().toString()),
                    direction: DismissDirection.endToStart,
                    // Provide a function that tells the app
                    // what to do after an item has been swiped away.
                    onDismissed: (direction) {
                      // Remove the item from the data source.
                      setState(() {
                        meusprodutos.removeAt(index);
                      });
                      // Then show a snackbar.
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("${produto["nome_produto"]} Apagado")));
                    },
                    // Show a red background as the item is swiped away.
                    background: Container(
                      color: Colors.red,
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          )),
                    ),
                    child: Product_List(
                      1,
                      true,
                      produto["nome_produto"],
                      " R\$\ ${produto["valor"].toStringAsFixed(2)}",
                      "Codigo de Barras : ${produto["codigo"]}",
                    ),
                  );
                }),
          ),
          Container(
            child: new RaisedButton(
                onPressed:
                    meusprodutos.length < MAX_PRODUTO ? barcodeScanning : null,
                color: Colors.blue,
                child: new Text(
                  "Escanear Produto",
                  style: TextStyle(color: Colors.white),
                )),
            padding: const EdgeInsets.all(8.0),
          ),
          subtotalWidget()
        ],
      ),
    );
  }

  _confirmarCompra() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Compra Confirmada"),
          content: Container(
            height: 250,
            width: 250,
            child: Image.asset('assets/qrcode.png'),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget payment_method() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: CreditCardWidget(
              cardNumber: '4512 3245 3654 8779',
              expiryDate: '06/20',
              cardHolderName: 'Daniel Soares',
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              cardBgColor: Colors.black,
              height: 175,
              textStyle: TextStyle(color: Colors.yellowAccent),
              width: MediaQuery.of(context).size.width,
              animationDuration: Duration(milliseconds: 1000),
            ),
          ),
          CreditCardWidget(
            cardNumber: "5234 3753 6524 3834",
            expiryDate: "02/21",
            cardHolderName: "Felipe de Luca",
            cvvCode: cvvCode,
            showBackView: isCvvFocused,
            cardBgColor: Colors.black,
            height: 175,
            textStyle: TextStyle(color: Colors.yellowAccent),
            width: MediaQuery.of(context).size.width,
            animationDuration: Duration(milliseconds: 1000),
          ),
        ],
      ),
    );
  }

  //context ate aqui
}

Widget subtotalWidget() {
  return Container(
    padding: EdgeInsets.all(15.0),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Subtotal"),
            Text("R\$\ ${_calcularSubtotal.toStringAsFixed(2)}")
          ],
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Divider(
            color: Colors.blue,
            height: 5,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Total"),
            Text("R\$\ ${_calcularSubtotal.toStringAsFixed(2)}")
          ],
        ),
      ],
    ),
  );
}

double get _calcularSubtotal {
  return meusprodutos.fold(0, (valoranterior, produto) {
    return valoranterior + produto["valor"];
  });
}

//comentario
