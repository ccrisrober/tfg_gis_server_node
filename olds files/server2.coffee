sys = require("sys")
net = require("net")
fs = require("fs")
dir = "./maps/"

###*
To read all files in "maps" directory

var fs = require('fs');
var dir='./tmpl/';
var data={};

fs.readdir(dir,function(err,files){
if (err) throw err;
var c=0;
files.forEach(function(file){
c++;
fs.readFile(dir+file,'utf-8',function(err,html){
if (err) throw err;
data[file]=html;
if (0===--c) {
console.log(data);  //socket.emit('init', {data: data});
}
});
});
});
###
sockets = []
positions = {}
maps = []
battles = {}
keys = {}
ObjectUser = require("./ObjectUser.js")
Map = require("./Map.js")
KeyObject = require("./KeyObject.js")
keys["Red"] = new KeyObject(1, 5 * 64, 5 * 64, "Red")
keys["Blue"] = new KeyObject(2, 6 * 64, 5 * 64, "Blue")
keys["Yellow"] = new KeyObject(3, 7 * 64, 5 * 64, "Yellow")
keys["Green"] = new KeyObject(4, 8 * 64, 5 * 64, "Green")
console.log keys
# ID
# WIDTH
# HEIGHT
maps.push new Map(1, "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1," + "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1," + "1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 4, 0, 0, 0, 1," + "1, 1, 0, 0, 0, 0, 0, 0, 0, 5, 5, 7, 5, 5, 5, 5, 1, 1, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 1," + "1, 1, 0, 0, 4, 6, 5, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 4, 0, 5, 5, 5, 0, 8, 8, 8, 0, 0, 1," + "1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 4, 0, 0, 0, 1, 1, 0, 5, 5, 5, 0, 0, 0, 8, 8, 8, 4, 0, 1," + "1, 0, 1, 0, 0, 0, 0, 4, 0, 0, 1, 1, 1, 1, 4, 0, 0, 0, 1, 0, 5, 0, 4, 4, 0, 0, 8, 8, 8, 1, 4, 1," + "4, 0, 1, 0, 0, 0, 0, 4, 4, 0, 1, 1, 1, 1, 1, 1, 4, 0, 1, 0, 5, 0, 4, 4, 4, 0, 8, 8, 8, 1, 1, 1," + "1, 0, 1, 0, 0, 4, 4, 4, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 5, 4, 4, 4, 0, 0, 0, 0, 1, 1, 1, 1," + "1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1," + "1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 4, 0, 0, 0, 1," + "1, 1, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 1, 1, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5," + "1, 1, 0, 0, 4, 0, 5, 5, 5, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 4, 0, 5, 5, 5, 0, 1, 1, 1, 0, 0, 1," + "1, 1, 1, 0, 5, 5, 5, 0, 0, 0, 1, 1, 1, 4, 0, 0, 0, 1, 1, 0, 5, 5, 5, 0, 0, 0, 1, 1, 1, 4, 0, 1," + "1, 0, 1, 0, 5, 0, 4, 4, 0, 0, 1, 1, 1, 1, 4, 0, 0, 0, 1, 0, 5, 0, 4, 4, 0, 0, 1, 1, 1, 1, 4, 1," + "4, 0, 1, 0, 5, 0, 4, 4, 4, 0, 1, 1, 1, 1, 1, 1, 4, 0, 1, 0, 5, 0, 4, 4, 4, 0, 1, 1, 1, 1, 1, 1," + "1, 1, 1, 1, 1, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 1," + "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1," + "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1," + "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1," + "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1," + "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1," + "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1," + "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1," + "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,", 32, 25, [ # KEYS
  keys["Red"]
  keys["Blue"]
  keys["Green"]
  keys["Yellow"]
])

#sys.puts("maps:" + JSON.stringify(maps));
svr = net.createServer((sock) ->
  
  #sock.write('Hello ' + sock.remoteAddress + ':' + sock.remotePort + '\n');
  
  # Creo objeto asociado al identificador del socket y lo guardo
  
  # Guardo el socket en la lista de clientes
  
  # Le envío inicialmente el mapa actual!!
  
  # Avisamos al resto de clientes la posición del nuevo cliente
  # client writes message
  
  # Parseamos los datos recibidos
  # Retornamos para evitar que lo mande a todos
  #break;
  
  #case "die":
  #                {
  #                    sendRandomDieValue();
  #                    break;
  #                }
  # Retornamos para evitar que lo mande a todos
  #break;
  
  # Erase socket user position
  # broad cast
  # Si es el mismo cliente, no le reenviamos el mensaje
  # broad cast
  # Si es el mismo cliente, no le reenviamos el mensaje
  # client disconnects
  replaceAll = (text, busca, reemplaza) ->
    text = text.toString().replace(busca, reemplaza)  until text.toString().indexOf(busca) is -1
    text
  
  # ***************************************************************
  #                     ACCIONES DEL SERVIDOR
  # ***************************************************************
  sendMap = (num_map) ->
    
    # Generamos posición aleatoria
    a = []
    s = replaceAll(maps[0].getMapFields(), ", ", "")
    sys.puts s
    i = 0
    len = s.length

    while i < len
      a.push i  if s[i] is "5"
      i++
    
    # Busco la posición
    value = a[randomValue(0, a.length)]
    xx = parseInt(value / maps[num_map].getWidth())
    yy = parseInt(value % maps[num_map].getHeight())
    sys.log xx + "   " + yy
    positions[sock.remotePort].setPosX 5 * 64 #(Math.floor(Math.random() * maps[0].getWidth()*/) % 64) * 64);
    positions[sock.remotePort].setPosY 5 * 64 #(Math.floor(Math.random() * maps[0].getHeight()) % 64) * 64);
    ret = JSON.stringify(
      Action: "sendMap"
      Map: maps[num_map]
      X: positions[sock.remotePort].getPosX()
      Y: positions[sock.remotePort].getPosY()
      Id: sock.remotePort
      Objects: JSONAllObject()
      Users: positions
    )
    sock.write ret
    return
  sendPosition = (client_id) ->
    sock.write JSON.stringify(positions[client_id])
    return
  newConnectionWarningUser = (client_id) ->
    sys.puts "Enviando nueva conexión a clientes"
    len = sockets.length
    prueba = positions[client_id]
    prueba["Action"] = "new"
    i = 0 # broad cast

    while i < len
      # Si es el mismo cliente, no le reenviamos el mensaje
      sockets[i].write JSON.stringify(prueba)  if sockets[i]  if sockets[i] isnt sock
      i++
    return
  sendFightToAnotherClient = (emisor_id, receiver_id) ->
    retOthers = JSON.stringify(
      Action: "hide"
      Ids: [
        emisor_id
        receiver_id
      ]
    )
    
    # Save Die roll value from emisor_id
    positions[emisor_id].setRollDie randomValue(1, 6)
    i = 0
    len = sockets.length

    while i < len
      if sockets[i].remotePort is receiver_id
        ret =
          Action: "fight"
          Id_enemy: emisor_id

        positions[receiver_id].setRollDie randomValue(1, 6)
        sockets[i].write JSON.stringify(ret)
      
      # Al resto de sockets les aviso que esconda los dos usuarios en combate
      else sockets[i].write retOthers  if sockets[i].remotePort isnt emisor_id
      i++
    return
  sendDiePlayerAndWinnerToShow = (emisor_id, receiver_id) ->
    
    # And the winner is ...
    winner = -1
    if positions[emisor_id].getRollDie() > positions[receiver_id].getRollDie()
      winner = emisor_id
    else winner = receiver_id  if positions[receiver_id].getRollDie() > positions[emisor_id].getRollDie()
    ret =
      Action: "finishBattle"
      ValueClient: positions[emisor_id].getRollDie()
      ValueEnemy: positions[receiver_id].getRollDie()
      Winner: winner

    sock.write JSON.stringify(ret)
    return
  
  #function sendRandomDieValue() { //client_id) {
  #        var value = randomValue(1, 6);
  #
  #        positions[sock.client_id].setRollDie(value);      // Añadimos el valor a positions, para evitar hackeos desde el cliente
  #
  #        var ret = {
  #            "Action": "dieValue",
  #            "Value": value
  #        };
  #
  #        sock.write(JSON.stringify(ret));
  #    };
  randomValue = (min, max) ->
    rand = min + Math.floor(Math.random() * max)
    rand
  JSONAllObject = ->
    ret = []
    ret.push
      Id: "yellow"
      X: 32 * 10
      Y: 32 * 1

    ret
  sendRemoveObj = (id_obj) ->
    ret =
      Action: "remObj"
      Key: id_obj

    JSON.stringify ret
  sendFreeObj = (id_obj, id_client) ->
    ret =
      Action: "freeObj"
      Key:
        Id: id_obj
        X: positions[id_client].getPosX()
        Y: positions[id_client].getPosY()

    JSON.stringify ret
  getRemoveObj = (id_obj, id_client) ->
  sys.puts "Connected: " + sock.remoteAddress + ":" + sock.remotePort
  positions[sock.remotePort] = new ObjectUser(sock.remotePort, 0, 0)
  sockets.push sock
  sendMap 0
  newConnectionWarningUser sock.remotePort
  sock.on "data", (data) ->
    sys.puts JSON.stringify(positions)
    sys.puts "RECIBO: " + data
    if data isnt "\n"
      data = data.toString("utf8")
      d = data
      try
        d = JSON.parse(data)
      catch Exception
        sys.puts "Error parseo"
      switch d.Action
        when "move"
          positions[sock.remotePort].setPosition d.Pos.X, d.Pos.Y
          break
        when "position"
          sendPosition sock.remotePort
          break
        when "fight"
          sendFightToAnotherClient sock.remotePort, d.Id_enemy
          return
        when "finishBattle"
          sendDiePlayerAndWinnerToShow sock.remotePort, d.Id_enemy
          return
        when "exit"
          sys.puts "exit command received: " + sock.remoteAddress + ":" + sock.remotePort + "\n"
          ret =
            Action: "exit"
            Id: sock.remotePort

          sys.puts "ACTUAL: " + sockets.length
          idx = sockets.indexOf(sock)
          sys.puts "Desconectado " + idx
          sys.puts sockets
          if idx isnt -1
            console.log positions[sock.remotePort]
            delete positions[sock.remotePort]

            console.log positions
            sockets.splice idx, 1
            sys.puts "Borrado " + idx
          sys.puts "ACTUAL: " + sockets.length
          console.log data
          len = sockets.length
          i = 0

          while i < len
            sockets[i].write JSON.stringify(ret)  if sockets[i]  if sockets[i] isnt sock
            i++
          return
      console.log data
      len = sockets.length
      i = 0

      while i < len
        sockets[i].write data  if sockets[i]  if sockets[i] isnt sock
        i++
    return

  sock.on "end", ->
    sys.puts "Disconnected end: " + sock.remotePort + "\n"
    return

  sock.on "error", (exc) ->
    sys.puts "Disconnected: " + sock.remotePort + "\n"
    sys.log "ignoring exception: " + exc
    return

  return
)
svraddr = "127.0.0.1"
svrport = 8081
svr.listen svrport, svraddr
sys.puts "Server Created at " + svraddr + ":" + svrport + "\n"