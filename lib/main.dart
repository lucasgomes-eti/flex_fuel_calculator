import 'package:flexfuelcalculator/keyboard.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flex Fuel Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum BaseCalcutionType { FUEL_VOl, DISTANCE, AMOUNT }

class _MyHomePageState extends State<MyHomePage> {
  String _keyboard = '0';
  BaseCalcutionType _baseCalcutionType = BaseCalcutionType.AMOUNT;
  bool _isFuelVolSelected = false,
      _isDistanceSelected = false,
      _isAmountSelected = true;

  double ethPricePerFuelVol = 3, gasPricePerFuelVol = 4;
  double ethDistancePerFuelVol = 10, gasDistancePerFuelVol = 15;

  double _ethFuelVol = 0, _ethDistance = 0, _ethAmount = 0;
  double _gasFuelVol = 0, _gasDistance = 0, _gasAmount = 0;

  double _calcFuelVol = 0, _calcDistance = 0, _calcAmount = 0;

  var restTextStyle = TextStyle(fontSize: 36, color: Colors.grey);
  var selectedTextStyle = TextStyle(fontSize: 48, color: Colors.lightBlue);

  TextEditingController ethPricePerFuelVolController,
      ethDistancePerFuelVolController,
      gasPricePerFuelVolController,
      gasDistancePerFuelVolController;

  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((onValue) {
      prefs = onValue;
      initPreferenceVariables(prefs);
    });
  }

  void saveConfig() async {
    void save(SharedPreferences prefs) async {
      await prefs.setDouble('ethPricePerFuelVol',
          double.parse(ethPricePerFuelVolController.text));

      await prefs.setDouble('gasPricePerFuelVol',
          double.parse(gasPricePerFuelVolController.text));

      await prefs.setDouble('ethDistancePerFuelVol',
          double.parse(ethDistancePerFuelVolController.text));

      await prefs.setDouble('gasDistancePerFuelVol',
          double.parse(gasDistancePerFuelVolController.text));
      initPreferenceVariables(prefs);
      initTextControllers();
      switch (_baseCalcutionType) {
        case BaseCalcutionType.FUEL_VOl:
          calculateWithFuelVol();
          break;
        case BaseCalcutionType.DISTANCE:
          calculateWithDistance();
          break;
        case BaseCalcutionType.AMOUNT:
          calculateWithAmount();
          break;
        default:
          break;
      }
      Navigator.of(context).pop();
    }

    if (prefs != null) {
      save(prefs);
    } else {
      prefs = await SharedPreferences.getInstance();
      save(prefs);
    }
  }

  @override
  void dispose() {
    ethPricePerFuelVolController.dispose();
    ethDistancePerFuelVolController.dispose();
    gasPricePerFuelVolController.dispose();
    gasDistancePerFuelVolController.dispose();
    prefs = null;
    super.dispose();
  }

  void initPreferenceVariables(SharedPreferences prefs) {
    var prefEthPricePerFuelVol = prefs.getDouble('ethPricePerFuelVol');
    ethPricePerFuelVol = prefEthPricePerFuelVol != null
        ? prefEthPricePerFuelVol
        : ethPricePerFuelVol;

    var prefEthDistancePerFuelVol = prefs.getDouble('ethDistancePerFuelVol');
    ethDistancePerFuelVol = prefEthDistancePerFuelVol != null
        ? prefEthDistancePerFuelVol
        : ethDistancePerFuelVol;

    var prefGasPricePerFuelVol = prefs.getDouble('gasPricePerFuelVol');
    gasPricePerFuelVol = prefGasPricePerFuelVol != null
        ? prefGasPricePerFuelVol
        : gasPricePerFuelVol;

    var prefGasDistancePerFuelVol = prefs.getDouble('gasDistancePerFuelVol');
    gasDistancePerFuelVol = prefGasDistancePerFuelVol != null
        ? prefGasDistancePerFuelVol
        : gasDistancePerFuelVol;
  }

  void initTextControllers() {
    ethPricePerFuelVolController =
        TextEditingController(text: ethPricePerFuelVol.toStringAsFixed(2));
    ethDistancePerFuelVolController =
        TextEditingController(text: ethDistancePerFuelVol.toStringAsFixed(2));
    gasPricePerFuelVolController =
        TextEditingController(text: gasPricePerFuelVol.toStringAsFixed(2));
    gasDistancePerFuelVolController =
        TextEditingController(text: gasDistancePerFuelVol.toStringAsFixed(2));
  }

  void onConfig() {
    initTextControllers();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Configurações'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: ethPricePerFuelVolController,
                    keyboardType: TextInputType.number,
                    decoration:
                        InputDecoration(labelText: 'Preço por litro de etanol'),
                  ),
                  TextField(
                    controller: ethDistancePerFuelVolController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Distância por litro de etanol'),
                  ),
                  TextField(
                    controller: gasPricePerFuelVolController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Preço por litro de gasolina'),
                  ),
                  TextField(
                    controller: gasDistancePerFuelVolController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Distância por litro de gasolina'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
              FlatButton(
                onPressed: saveConfig,
                child: Text('Salvar'),
              ),
            ],
          );
        });
  }

  void _incrementKeybord(String value) {
    setState(() {
      _keyboard = _keyboard == '0' ? '' : _keyboard;
      _keyboard += value;
      setBaseCalculators();
    });
  }

  void setBaseCalculators() {
    switch (_baseCalcutionType) {
      case BaseCalcutionType.FUEL_VOl:
        _calcFuelVol = double.parse(_keyboard);
        _calcDistance = 0;
        _calcAmount = 0;
        calculateWithFuelVol();
        break;
      case BaseCalcutionType.DISTANCE:
        _calcFuelVol = 0;
        _calcDistance = double.parse(_keyboard);
        _calcAmount = 0;
        calculateWithDistance();
        break;
      case BaseCalcutionType.AMOUNT:
        _calcFuelVol = 0;
        _calcDistance = 0;
        _calcAmount = double.parse(_keyboard);
        calculateWithAmount();
        break;
      default:
        break;
    }
  }

  void calculateWithFuelVol() {
    setState(() {
      _ethFuelVol = _calcFuelVol;
      _ethDistance = _ethFuelVol * ethDistancePerFuelVol;
      _ethAmount = _ethFuelVol * ethPricePerFuelVol;

      _gasFuelVol = _calcFuelVol;
      _gasDistance = _gasFuelVol * gasDistancePerFuelVol;
      _gasAmount = _gasFuelVol * gasPricePerFuelVol;
    });
  }

  void calculateWithDistance() {
    setState(() {
      _ethFuelVol = _calcDistance / ethDistancePerFuelVol;
      _ethDistance = _calcDistance;
      _ethAmount = _ethFuelVol * ethPricePerFuelVol;

      _gasFuelVol = _calcDistance / gasDistancePerFuelVol;
      _gasDistance = _calcDistance;
      _gasAmount = _gasFuelVol * gasPricePerFuelVol;
    });
  }

  void calculateWithAmount() {
    setState(() {
      _ethFuelVol = _calcAmount / ethPricePerFuelVol;
      _ethDistance = _ethFuelVol * ethDistancePerFuelVol;
      _ethAmount = _calcAmount;

      _gasFuelVol = _calcAmount / gasPricePerFuelVol;
      _gasDistance = _gasFuelVol * gasDistancePerFuelVol;
      _gasAmount = _calcAmount;
    });
  }

  void _clearOne() {
    setState(() {
      _keyboard = _keyboard.length > 1
          ? _keyboard.substring(0, _keyboard.length - 1)
          : '0';
      setBaseCalculators();
    });
  }

  void _clearAll() {
    setState(() {
      _keyboard = '0';
      setBaseCalculators();
    });
  }

  void _setBaseCalculationType(BaseCalcutionType baseCalcutionType) {
    setState(() {
      _baseCalcutionType = baseCalcutionType;
      _isFuelVolSelected = baseCalcutionType == BaseCalcutionType.FUEL_VOl;
      _isDistanceSelected = baseCalcutionType == BaseCalcutionType.DISTANCE;
      _isAmountSelected = baseCalcutionType == BaseCalcutionType.AMOUNT;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: Platform.isIOS ? 20 + 16 : 16),
            Row(
              // etanol vs galosina
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: 8),
                Flexible(
                  child: Column(children: <Widget>[
                    SizedBox(height: 16),
                    Text(
                      'Etanol',
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${_ethFuelVol.toStringAsFixed(2)} L',
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    Text('${_ethDistance.toStringAsFixed(2)} km',
                        style: Theme.of(context).textTheme.subhead),
                    Text('R\$ ${_ethAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.subhead),
                    SizedBox(height: 16)
                  ]),
                ),
                SizedBox(
                  child: VerticalDivider(),
                  height: 80,
                ),
                Flexible(
                  child: Column(children: <Widget>[
                    SizedBox(height: 16),
                    Text('Gasolina', style: Theme.of(context).textTheme.title),
                    SizedBox(height: 8),
                    Text('${_gasFuelVol.toStringAsFixed(2)} L',
                        style: Theme.of(context).textTheme.subhead),
                    Text('${_gasDistance.toStringAsFixed(2)} km',
                        style: Theme.of(context).textTheme.subhead),
                    Text('R\$ ${_gasAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.subhead),
                    SizedBox(height: 16)
                  ]),
                ),
                SizedBox(width: 8)
              ],
            ),
            Divider(),
            InkWell(
              onTap: () {
                _clearAll();
                _setBaseCalculationType(BaseCalcutionType.FUEL_VOl);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Litros',
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(width: 16),
                    Flexible(
                      child: Text(_isFuelVolSelected ? _keyboard : '0',
                          style: _isFuelVolSelected
                              ? selectedTextStyle
                              : restTextStyle),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _clearAll();
                _setBaseCalculationType(BaseCalcutionType.DISTANCE);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Distância', style: Theme.of(context).textTheme.title),
                    SizedBox(width: 16),
                    Flexible(
                      child: Text(_isDistanceSelected ? _keyboard : '0',
                          style: _isDistanceSelected
                              ? selectedTextStyle
                              : restTextStyle),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _clearAll();
                _setBaseCalculationType(BaseCalcutionType.AMOUNT);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Valor', style: Theme.of(context).textTheme.title),
                    SizedBox(width: 16),
                    Flexible(
                      child: Text(_isAmountSelected ? _keyboard : '0',
                          style: _isAmountSelected
                              ? selectedTextStyle
                              : restTextStyle),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 396,
              child: Keyboard(
                onKeyboardTapped: _incrementKeybord,
                onErase: _clearOne,
                onEraseAll: _clearAll,
                onConfig: onConfig,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
