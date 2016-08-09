var sys = require('sys');
var net = require('net');

var fs = require("fs");

/*function readLines(input) {
  var remaining = '';

  input.on('data', function(data) {
    remaining += data;
    var index = remaining.indexOf('\n');
    var last  = 0;
    while (index > -1) {
      var line = remaining.substring(last, index);
      last = index + 1;
      index = remaining.indexOf('\n', last);
    }

    remaining = remaining.substring(last);
  return remaining;
  });

  input.on('end', function() {
  });
}

var ee = readLines(fs.createReadStream("./data.json"));
sys.puts(ee);*/
/**
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
 **/
var sockets = [];

var positions = {};

var maps = [];

//var battles = {};

var keys = {};

var ObjectUser = require("./ObjectUser.js");
var Map = require("./Map.js");
var KeyObject = require("./KeyObject.js");

keys["Red"] = new KeyObject(1, 5*64, 5*64, "Red");
keys["Blue"] = new KeyObject(2, 6*64, 5*64, "Blue");
keys["Yellow"] = new KeyObject(3, 7*64, 5*64, "Yellow");
keys["Green"] = new KeyObject(4, 8*64, 5*64, "Green");

console.log(keys);


fs.readFile('data.json', 'utf8', function (err,data) {
    if (err) {
        return console.log(err);
    }
    data = JSON.parse(data);

    maps.push(new Map(
        1,                          // ID
        "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,"+
        "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,"+
        "1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 4, 0, 0, 0, 1,"+
        "1, 1, 0, 0, 0, 0, 0, 0, 0, 5, 5, 7, 5, 5, 5, 5, 1, 1, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 1,"+
        "1, 1, 0, 0, 4, 6, 5, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 4, 0, 5, 5, 5, 0, 8, 8, 8, 0, 0, 1,"+
        "1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 4, 0, 0, 0, 1, 1, 0, 5, 5, 5, 0, 0, 0, 8, 8, 8, 4, 0, 1,"+
        "1, 0, 1, 0, 0, 0, 0, 4, 0, 0, 1, 1, 1, 1, 4, 0, 0, 0, 1, 0, 5, 0, 4, 4, 0, 0, 8, 8, 8, 1, 4, 1,"+
        "4, 0, 1, 0, 0, 0, 0, 4, 4, 0, 1, 1, 1, 1, 1, 1, 4, 0, 1, 0, 5, 0, 4, 4, 4, 0, 8, 8, 8, 1, 1, 1,"+
        "1, 0, 1, 0, 0, 4, 4, 4, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 5, 4, 4, 4, 0, 0, 0, 0, 1, 1, 1, 1,"+
        "1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1,"+
        "1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 4, 0, 0, 0, 1,"+
        "1, 1, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 1, 1, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5,"+
        "1, 1, 0, 0, 4, 0, 5, 5, 5, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 4, 0, 5, 5, 5, 0, 1, 1, 1, 0, 0, 1,"+
        "1, 1, 1, 0, 5, 5, 5, 0, 0, 0, 1, 1, 1, 4, 0, 0, 0, 1, 1, 0, 5, 5, 5, 0, 0, 0, 1, 1, 1, 4, 0, 1,"+
        "1, 0, 1, 0, 5, 0, 4, 4, 0, 0, 1, 1, 1, 1, 4, 0, 0, 0, 1, 0, 5, 0, 4, 4, 0, 0, 1, 1, 1, 1, 4, 1,"+
        "4, 0, 1, 0, 5, 0, 4, 4, 4, 0, 1, 1, 1, 1, 1, 1, 4, 0, 1, 0, 5, 0, 4, 4, 4, 0, 1, 1, 1, 1, 1, 1,"+
        "1, 1, 1, 1, 1, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 1,"+
        "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,"+
        "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,"+
        "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,"+
        "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,"+
        "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,"+
        "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,"+
        "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,"+
        "1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,",
        32,                          // WIDTH
        25,                          // HEIGHT
        [keys["Red"], keys["Blue"], keys["Green"], keys["Yellow"]]               // KEYS
    ));

    //sys.puts("maps:" + JSON.stringify(maps));

    var svr = net.createServer(function (sock) {
        sys.puts('Connected: ' + sock.remoteAddress + ':' + sock.remotePort);
        //sock.write('Hello ' + sock.remoteAddress + ':' + sock.remotePort + '\n');

        // Creo objeto asociado al identificador del socket y lo guardo
        positions[sock.remotePort] = new ObjectUser(sock.remotePort, 0, 0);

        // Guardo el socket en la lista de clientes
        sockets.push(sock);

        // Le envío inicialmente el mapa actual!!
        sendMap(0);

        // Avisamos al resto de clientes la posición del nuevo cliente
        newConnectionWarningUser(sock.remotePort);


        sock.on('data', function (data) {  // client writes message
            sys.puts(JSON.stringify(positions));

            sys.puts("RECIBO: " + data);

            if (data !== "\n") {
                data = data.toString('utf8');
                // Parseamos los datos recibidos
                var d = data;
                try {
                    d = JSON.parse(data);
                } catch (Exception) {
                    sys.puts("Error parseo");
                }

                switch (d.Action) {
                    case "move":
                    {
                        positions[sock.remotePort].setPosition(d.Pos.X, d.Pos.Y);
                        break;
                    }
                    case "position":
                    {
                        sendPosition(sock.remotePort);
                        break;
                    }
                    case "fight":
                    {
                        sendFightToAnotherClient(sock.remotePort, d.Id_enemy);
                        return; // Retornamos para evitar que lo mande a todos
                        //break;
                    }
                    /*case "die":
                    {
                        sendRandomDieValue();
                        break;
                    }*/
                    case "finishBattle": {
                        sendDiePlayerAndWinnerToShow(sock.remotePort, d.Id_enemy);
                        return; // Retornamos para evitar que lo mande a todos
                        //break;
                    }
                    case "exit": {
                        sys.puts('exit command received: ' + sock.remoteAddress + ':' + sock.remotePort + '\n');
                        
                        var ret = {
                            "Action": "exit",
                            "Id": sock.remotePort
                        };

                        sys.puts("ACTUAL: " + sockets.length);
                        var idx = sockets.indexOf(sock);
                        sys.puts("Desconectado " + idx);
                        sys.puts(sockets);
                        if (idx !== -1) {
                            // Erase socket user position
                            console.log(positions[sock.remotePort]);
                            delete positions[sock.remotePort];
                            console.log(positions);

                            sockets.splice(idx, 1);
                            sys.puts("Borrado " + idx);
                        }
                        sys.puts("ACTUAL: " + sockets.length);

                        console.log(data);
                        var len = sockets.length;
                        for (var i = 0; i < len; i++) { // broad cast
                            if (sockets[i] !== sock) { // Si es el mismo cliente, no le reenviamos el mensaje
                                if (sockets[i]) {
                                    sockets[i].write(JSON.stringify(ret));
                                }
                            }
                        }

                        return;
                    }
                }
                console.log(data);
                var len = sockets.length;
                for (var i = 0; i < len; i++) { // broad cast
                    if (sockets[i] !== sock) { // Si es el mismo cliente, no le reenviamos el mensaje
                        if (sockets[i]) {
                            sockets[i].write(data);
                        }
                    }
                }
            }
        });

        sock.on('end', function () { // client disconnects
            sys.puts('Disconnected end: ' + sock.remotePort + '\n');
        });

        sock.on("error", function (exc) {
            sys.puts('Disconnected: ' + sock.remotePort + '\n');
            sys.log("ignoring exception: " + exc);
        });



    function replaceAll( text, busca, reemplaza ){
      while (text.toString().indexOf(busca) != -1)
          text = text.toString().replace(busca,reemplaza);
      return text;
    }



        // ***************************************************************
        //                     ACCIONES DEL SERVIDOR
        // ***************************************************************
        function sendMap(num_map) {

            // Generamos posición aleatoria
            var a = [];

            var s = replaceAll(maps[0].getMapFields(), ", ", '');
            sys.puts(s);
            for(var i = 0, len = s.length; i < len; i++) {
                if(s[i] == '5') {
                    a.push(i);
                }
            }


            // Busco la posición
            var value = a[randomValue(0, a.length)];
            var xx = parseInt(value/maps[num_map].getWidth());
            var yy = parseInt(value % maps[num_map].getHeight());
            sys.log(xx + "   " + yy);


            positions[sock.remotePort].setPosX(5 * 64);//(Math.floor(Math.random() * maps[0].getWidth()*/) % 64) * 64);
            positions[sock.remotePort].setPosY(5 * 64);//(Math.floor(Math.random() * maps[0].getHeight()) % 64) * 64);
            var ret = JSON.stringify({
                "Action": "sendMap",
                "Map": maps[num_map],
                "X": positions[sock.remotePort].getPosX(),
                "Y": positions[sock.remotePort].getPosY(),
                "Id": sock.remotePort,
                "Objects": JSONAllObject(),
                "Users": positions
            });
            sock.write(ret);
        };

        function sendPosition(client_id) {
            sock.write(JSON.stringify(positions[client_id]));
        };

        function newConnectionWarningUser(client_id) {
            sys.puts("Enviando nueva conexión a clientes");
            var len = sockets.length;

            var prueba = positions[client_id];
            prueba["Action"] = "new";

            for (var i = 0; i < len; i++) { // broad cast
                if (sockets[i] !== sock) { // Si es el mismo cliente, no le reenviamos el mensaje
                    if (sockets[i]) {
                        sockets[i].write(JSON.stringify(prueba));
                    }
                }
            }
        };

        function sendFightToAnotherClient(emisor_id, receiver_id) {
            var retOthers = JSON.stringify({
                "Action": "hide",
                "Ids": [emisor_id, receiver_id]
            });

            // Save Die roll value from emisor_id
            positions[emisor_id].setRollDie(randomValue(1, 6));

            for (var i = 0, len = sockets.length; i < len; i++) {
                if (sockets[i].remotePort === receiver_id) {
                    var ret = {
                        "Action": "fight",
                        "Id_enemy": emisor_id
                    };
                    positions[receiver_id].setRollDie(randomValue(1, 6));
                    sockets[i].write(JSON.stringify(ret));
                } else if (sockets[i].remotePort !== emisor_id) {
                    // Al resto de sockets les aviso que esconda los dos usuarios en combate
                    sockets[i].write(retOthers);
                }
            }
        };

        function sendDiePlayerAndWinnerToShow = function(emisor_id, receiver_id) {
          var ret, valueC, valueE, winner;
          winner = -1;
          valueC = -1;
          valueE = -1;
          if (!positions[emisor_id]) {
            winner = receiver_id;
            valueC = positions[receiver_id].getRollDie();
          } else if (!positions[receiver_id]) {
            winner = emisor_id;
            valueE = positions[emisor_id].getRollDie();
          } else if (positions[emisor_id].getRollDie() > positions[receiver_id].getRollDie()) {
            winner = emisor_id;
            valueE = positions[emisor_id].getRollDie();
            valueC = positions[receiver_id].getRollDie();
          } else if (positions[receiver_id].getRollDie() > positions[emisor_id].getRollDie()) {
            winner = receiver_id;
            valueE = positions[emisor_id].getRollDie();
            valueC = positions[receiver_id].getRollDie();
          }
          ret = JSON.stringify({
            Action: "finishBattle",
            ValueClient: valueC,
            ValueEnemy: valueE,
            Winner: winner
          });
          sock.write(ret);
        };

        /*function sendRandomDieValue() { //client_id) {
            var value = randomValue(1, 6);

            positions[sock.client_id].setRollDie(value);      // Añadimos el valor a positions, para evitar hackeos desde el cliente

            var ret = {
                "Action": "dieValue",
                "Value": value
            };

            sock.write(JSON.stringify(ret));
        };*/
        function randomValue(min, max) {
            var rand = min + Math.floor(Math.random() * max);
            return rand;
        };

        function JSONAllObject() {
            var ret = [];

            ret.push({
                "Id": "yellow",
                "X": 32 * 10,
                "Y": 32 * 1
            });

            return ret;
        };

        function sendRemoveObj(id_obj) {
            var ret = {
                "Action": "remObj",
                "Key": id_obj
            };
            return JSON.stringify(ret);
        };

        function sendFreeObj(id_obj, id_client) {
            var ret = {
                "Action": "freeObj",
                "Key": {
                    "Id": id_obj,
                    "X": positions[id_client].getPosX(),
                    "Y": positions[id_client].getPosY()
                }
            };

            return JSON.stringify(ret);
        };

        function getRemoveObj(id_obj, id_client) {

        };

    });

    var svraddr = '127.0.0.1';
    var svrport = 8081;

    svr.listen(svrport, svraddr);
    sys.puts('Server Created at ' + svraddr + ':' + svrport + '\n');

});