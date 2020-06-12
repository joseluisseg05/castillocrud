import 'package:castillo_crud/data/database.dart';
import 'package:castillo_crud/model/model_game.dart';
import 'package:castillo_crud/pages/pages_detalle.dart';
import 'package:castillo_crud/util/util_img.dart';
import 'package:flutter/material.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  Image image;
  List<Game> images;
  Game game;
  GameDataProvider dataProvider;
  bool _allow = true;
  @override
  void didUpdateWidget(PageHome oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState((){});
  }

  @override
  void initState() {
    super.initState();
    images=[];
    setState(() {
      _data();
    });
  }

  
//}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Color(0xFF77b802),),
            onPressed: (){
              //GameDataProvider.db.deleteAllGame();
              _mostrarAlerta(context);
              setState(() { 
              });
            },
            
          )
        ],
        title: Row(
          children: [
            Text("Force"),
            Text("Game", style: TextStyle(color: Color(0xFF77b802)),)
          ],
        ),
        backgroundColor: Color(0xFF000000),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF77b802),
        child: Icon(Icons.add_circle_outline),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PageDetalle(false)));
        },
      ),
      body: Center(
        child: _data(),
      ),
    );
  }

  Widget _data(){
    return FutureBuilder<List<Game>>(
      future: GameDataProvider.db.getAllGames(),
      builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot){
        if(snapshot.hasData){
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index){
              Game item = snapshot.data[index];
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: _cardTipo2(item),
              );
            }
          );
        }else{ Center(child:CircularProgressIndicator()); }
      }
    );
  }

  Widget _cardTipo2(Game item) {
    final card = Container(  
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Hero(
          tag: item.nombre, 
          child: Material(
            child: InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PageDetalle(true,game:item)));
              },
              onLongPress: (){
                setState(() {
                  GameDataProvider.db.deleteGameWhithId(item.id);  
                });        
              },
              child: Container(            
                height: 250.0,
                width: 400.0,
                child: image = Utility.imageFromBase64String(item.imagen),
              ),
            ),
          )
        ),
        Container(
          child: Text(item.nombre.toString(),style: TextStyle(color: Colors.black),),
          padding: EdgeInsets.all(10.0),
        ),
       ]
     ),
   );
   return Container(
    child: ClipRRect(
      child: card,
      borderRadius: BorderRadius.circular(20.0),
    ),
    decoration:  BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10.0,
          spreadRadius: 2.0,
          offset: Offset(2.0, 10.0),
        ),
      ]
    ),
  );
 }

  void _mostrarAlerta(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: true, //puede tocar afuera del dialogo y cierra
      builder: (context){
        
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text("Atencion!!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,//adapta a lo que tiene el elemento
            children: <Widget>[
              Text("Usted realemte quiere eliminar toda la base de datos?"),
              
            ],
          ),

          actions: <Widget>[//botones o demas 
            FlatButton(//botones 
              onPressed: ()=>Navigator.of(context).pop(), //cierra
              child: Text("Cancelar")
            ),
            FlatButton(
              onPressed: (){
                setState(() {
                  GameDataProvider.db.deleteAllGame();
                  Navigator.of(context).pop();
                });}, 
              child: Text("Ok")
            ),
          ],
        );
      }
    );
  }

}