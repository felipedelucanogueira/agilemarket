import 'package:barcode_scan/barcode_scan.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

var random = Random.secure();

final produtos = <Map<String, dynamic>>[
  {"codigo": "7899716311295", "nome_produto": "Pelicula iphone 7", "valor": 65.00},
  {"codigo": "7894900330014", "nome_produto": "Aquarius fresh", "valor": 3.50},
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
        centerTitle: false,
        backgroundColor: Colors.white,
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
                text: "Pagamentos",
              )
            ]),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: <Widget>[Scan_Product(), payment_metthod()],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10, top: 20, bottom: 10),
                child:
                    Text("CARRINHO - ${meusprodutos.length} de $MAX_PRODUTO"),
              ),
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
            child: Image.asset("assets/qrcode.png"),
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

Widget payment_metthod() {
  return Container();
}

double get _calcularSubtotal {
  return meusprodutos.fold(0, (valoranterior, produto) {
    return valoranterior + produto["valor"];
  });
}
