
import 'package:castillo_crud/data/database.dart';
import 'package:castillo_crud/model/model_game.dart';
import 'package:castillo_crud/pages/pages_home.dart';
import 'package:castillo_crud/util/util_img.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:async';
import 'dart:io';

class PageDetalle2 extends StatefulWidget {
  final bool editar;
  final Game game;

  PageDetalle2(this.editar,{this.game}):assert(editar == true || game == null);

  @override
  _PageDetalle2State createState() => _PageDetalle2State();
}

class _PageDetalle2State extends State<PageDetalle2> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController descripController = TextEditingController();
  TextEditingController costoController = TextEditingController();

  String imgString64;
  Future<File> imageFile;
  Image image;

  Game gameF;

  File foto;
  
  String valueDrop;
  List<String> items = <String>["Peso   MX", "Euro    €", "Dolar   \$", "Libra   ‎£"];

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.editar == true){
      //foto.path=widget.game.imagen;
      valueDrop=widget.game.moneda;
      nombreController.text = widget.game.nombre;
      descripController.text = widget.game.descripcion;
      costoController.text = widget.game.costo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      appBar: AppBar(
        title: Row( 
          children: [
            Text(widget.editar?"Edit ":"Add ", style: TextStyle(color: Color(0xFF77b802)),),
            Text("Force"),
            Text("Game", style: TextStyle(color: Color(0xFF77b802)),)
          ],
        ),
        backgroundColor: Color(0xFF000000),
      ),
      body: ListView(
        children: [
          Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    child:Container(
                      height: 250.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF77b802), width: 2.0),
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          image: AssetImage(foto?.path ?? "images/select.png"), 
                          fit: BoxFit.cover,
                        ),
                      ),
                    //child: image =  Utility.imageFromBase64String(widget.game.imagen),
                  ), 
                    onTap: _selectFoto, 
                  ),
                  textForm(nombreController, "Game", "Name game", Icons.games, 
                          widget.editar ? widget.game.nombre : "Name Game", 
                          TextInputType.text, 1),
                  textForm(descripController, "Descripción", "Descripción game", Icons.description, 
                          widget.editar ? widget.game.descripcion : "Descripción Game", 
                          TextInputType.multiline, 6),
                  _crearDrop(),
                  textForm(costoController, "Costo", "Costo game", Icons.attach_money, 
                          widget.editar ? widget.game.costo : "Costo Game", 
                          TextInputType.number, 1),
                  SizedBox(height: 30.0,),
                  RaisedButton(
                    color: Color(0xFF77b802),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text('Guargar',
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white
                      ),
                    ),   
                    onPressed: ()async {
                      if (!_key.currentState.validate()){
                        Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data'))
                        );
                      }else if (widget.editar == true) {
                        setState(() {
                          GameDataProvider.db.updateGame(new Game(
                          nombre: nombreController.text,
                          descripcion: descripController.text,
                          costo: costoController.text,
                          moneda: valueDrop,
                          imagen: imgString64,
                          logic: 1,//si esta
                          id: widget.game.id ));
                          
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context)=>PageHome())
                          );
                        });
                        
                      } else {
                        await GameDataProvider.db.addGame(new Game(
                          nombre: nombreController.text,
                          descripcion: descripController.text,
                          costo: costoController.text,
                          moneda: valueDrop,
                          imagen: imgString64,
                          logic: 1,//si esta                        
                        ));
                        setState(() {});
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context)=>PageHome())
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ] 
      ),
    );
  }


  _imgGame(){
    if(widget.editar==true){
      /*if(foto!=null){
        return Container(
          height: 250.0,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF77b802), width: 2.0),
            borderRadius: BorderRadius.circular(20.0),
            image: DecorationImage(
              image: AssetImage(foto?.path ?? "images/select.png"), 
              //image = Utility.imageFromBase64String(widget.game.imagen),
              fit: BoxFit.cover,
            ),
          ),
        ); 
      }*/
      return Container(
        height: 250.0,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF77b802), width: 2.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: image =  Utility.imageFromBase64String(widget.game.imagen),
      );
    }else{
      return Container(
        height: 250.0,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF77b802), width: 2.0),
          borderRadius: BorderRadius.circular(20.0),
          image: DecorationImage(
            image: AssetImage(foto?.path ?? "images/select.png"), 
            //image = Utility.imageFromBase64String(widget.game.imagen),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    
  }
   
   _selectFoto()async {
    imgString64="";
    foto=await ImagePicker.pickImage(source: ImageSource.gallery);
    imgString64 = Utility.base64String(foto.readAsBytesSync());
    if(foto != null){}
    setState(() {});
  }


  textForm(TextEditingController t, String label, String hint,
    IconData iconData, String initialValue, TextInputType tipo, int lineas) {
      return Container(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
          validator: (value){ if (value.isEmpty) {return 'Ingresar un Valor';} },
          keyboardType: tipo,
          maxLines: lineas,
          style: TextStyle(color: Color(0xFFFFFFFF)),
          controller: t,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0,color: Color(0xFF77b802))
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0,color: Color(0xFF77b802))
            ),
            prefixIcon: Icon(iconData, color: Color(0xFF77b802),),            
            hintText: hint,
            hintStyle: TextStyle(color: Color(0xFF77b802)),
            labelText: label,
            labelStyle: TextStyle(color: Color(0xFF77b802)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
          ),
        ),
      );
    }
  
  pickImageFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      imgString64 = Utility.base64String(imgFile.readAsBytesSync());
    });
  }

  List<DropdownMenuItem<String>>getOpciones(){//obtener el los items del drop
    List<DropdownMenuItem<String>> lista = new List();
    items.forEach((moneda) { 
      lista.add(DropdownMenuItem(
        child: Text(moneda, style: TextStyle(color: Color(0xFF000000)),),
        value: moneda,
      ));
    });
    return lista;
  }

  Widget _crearDrop() {
    return Row(
      children: <Widget>[
        Icon(Icons.select_all,color: Color(0xFF77b802),),
        SizedBox(width: 30.0),
        DropdownButton(
          dropdownColor: Color(0xFF2b2b2b),
          underline: Container(
            height: 2.0,
            color: Color(0xFF77b802),
          ),
          iconEnabledColor: Color(0xFF77b802),
          value: valueDrop,
          items: items.map<DropdownMenuItem<String>>((String value){
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Color(0xFFFFFFFF))),
            );
          }).toList(), 
          onChanged: (opt){
            setState(() {
              valueDrop = opt;
            });
          },
        ),
        SizedBox(width: 50.0),
      ],
    );
  }
  


}