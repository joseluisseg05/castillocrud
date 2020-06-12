/*
#esta clase es para el manejo de los datos
#se implementan String para el mejor manejo de ellos 
la validacion de cada tipo vendra del frontend
#el id es el unico int por la sumatoria al momento de agregar uno nuevo
 */

class Game{
  int id;
  String nombre;
  String descripcion;
  String costo;
  String moneda;
  String imagen;
  int logic;

  Game({this.id, this.nombre, this.descripcion, this.costo, this.moneda, this.imagen, this.logic});

  Map<String, dynamic> toMap()=>{
    "id"         :id,
    "nombre"     :nombre,
    "descripcion":descripcion,
    "costo"      :costo,
    "moneda"     :moneda,
    "imagen"     :imagen,
    "logic"      :logic,
  };

  factory Game.fromMap(Map<String, dynamic> json) => new Game(
    id:          json["id"],
    nombre:      json["nombre"],
    descripcion: json["descripcion"],
    costo:       json["costo"],
    moneda:      json["moneda"],
    imagen:      json["imagen"],
    logic:       json["logic"] 

  );
}