# Copyright (c) 2015, maldicion069 (Cristian Rodríguez) <ccrisrober@gmail.con>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.package com.example

# UPDATE `object_map` SET `admin`=null WHERE 1

sys = require("sys")
net = require("net")
util = require("util")
fs = require("fs")
clone = require('clone')
ObjectUser = require("./ObjectUser.js")
Map = require("./Map.js")
KeyObject = require("./KeyObject.js")
mysql = require("mysql")
async = require("async")
locks = require("locks")
sockets = {}
users_sockets = {} # Pair socket.remotePort - username
# positions = {}
maps = []

keys = {}

mutex_battles = locks.createMutex()

battles = {}

isGame = false;
if process.argv[2] is "S" or process.argv[2] == "s"
  isGame = true;

if isGame is true
  console.log("Game Mode")
else
  console.log("Test Mode")



pool   = mysql.createPool(
  host: "localhost"
  user: "root"
  password: ""
  database: "tfg_gis"
)

counter_battle = 0
incrementAndGet = () ->
  mutex.lock ->
  counter_battle++
  get_counter = counter_battle
  mutex.unlock()
  get_counter

pool.getConnection (err, connection) ->
  connection.query "UPDATE `users` SET `isAlive`=0;", (err, res) ->
    connection.query "SELECT o.color, o.id, om.posX, om.posY, om.admin FROM object_map om INNER JOIN object o ON o.id = om.id_obj WHERE om.id_map=1;", (err, rows, fields) ->
      # console.log "OK" if not err
      len = rows.length
      i = 0
      # console.log rows
      while i < len
        RealObjects[rows[i].id] = new KeyObject(rows[i].id, rows[i].posX, rows[i].posY, rows[i].color)
        i++

      connection.query "SELECT * FROM `map` WHERE `id`= 1;", (err, rows2, fields) ->
        # console.log "OK" if not err
        ks_0 = []

        len = rows.length
        i = 0

        while i < len
          # console.log rows[i]
          if RealObjects[rows[i].id] and rows[i].admin is `null`
            ks_0.push RealObjects[rows[i].id]
          i++

        console.log "KS: " + ks_0

        maps.push new Map(rows2[0].id, rows2[0].mapFields, rows2[0].width, rows2[0].height, ks_0)

      svr = net.createServer((sock) ->

        # ***************************************************************
        #                     SERVER ACTIONS
        # ***************************************************************
        sendMap = (num_map, user) ->
          map = clone maps[num_map]
          delete map.RealObjects


          connection.query 'SELECT `port`, `posX`, `posY` FROM `users` WHERE `isAlive`=1;', (err, rows) ->
            async.series
              one: (callback) ->
                users = {}
                async.each rows, ((row, callback2) ->
                  users[row.port] = {"Id": row.port, "PosX": row.posX, "PosY": row.posY}
                  callback2()
                ), (err2) ->
                  console.log users
                  callback(null, users)
              second: (callback) ->
                objects = []    # TODO: Enviamos los objetos que pertenecen a si mismo
                connection.query 'SELECT * FROM `object_map` WHERE `admin`="' + users_sockets[sock.remotePort] + '" AND `id_map`=1;', (err, rows) ->
                  console.log "OBJS:" + rows
                  console.log err
                  async.each rows, ((row, callback2) ->
                    objects.push {Id: row.id_obj, PosX: row.posX, PosY: row.posY}
                    callback2()
                  ), (err2) ->
                    console.log objects
                    callback(null, objects)
            , (err, results) ->
              ret = JSON.stringify(
                Action: "sendMap"
                Map: map
                X: user.getPosX()
                Y: user.getPosY()
                Id: sock.remotePort
                Users: results.one
                Objects: results.second
              )
              sock.write ret + "\n"
          return
        sendPosition = (client_id) ->
          connection.query 'SELECT `posX`, `posY` FROM `users` WHERE `port`=' + client_id + ';', (err, rows) ->
            if not err
              sock.write JSON.stringify(
                Action: "position"
                Id: client_id
                PosX: rows[0].posX
                PosY: rows[0].posY
              )
            return
        newConnectionWarningUser = (ou) ->
          sys.puts "Enviando nueva conexión a clientes"
          msg = ou
          msg["Action"] = "new"
          msg = JSON.stringify(msg)

          if isGame is true
            # broadcast
            for port of sockets
              sockets[port].write msg if sockets[port] if port isnt sock.remotePort

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
          connection.query "UPDATE `users` SET `rollDice`=" + randomValue(1, 6) + "; WHERE `port`=" + emisor_id + ";", (err, res) ->
            len = sockets.length

            for port in sockets
              if port is receiver_id
                ret = JSON.stringify(
                  Action: "fight"
                  Id_enemy: emisor_id
                )
                connection.query "UPDATE `users` SET `rollDice`=" + randomValue(1, 6) + "; WHERE `port`=" + receiver_id + ";", (err, res) ->
                  sockets[port].write ret
              else sockets[port].write retOthers if port isnt emisor_id
                sockets[port].write data  if sockets[port]  if sockets[port] isnt sock
            return

        randomValue = (min, max) ->
          rand = min + Math.floor(Math.random() * max)
          rand

        sock.on "data", (data) ->
          sys.puts "RECIBO: " + data
          if data isnt "\n"
            data = data.toString("utf8")
            d = data
            try
              d = JSON.parse(data)
            catch Exception
              sys.puts "Error parseo"
            switch d.Action
              when "initWName"
                insOrUpd = 1 # 0: ins, 1: upd
                posX = 320
                posY = 320
                async.series
                  zero: (callback) ->
                    connection.query 'SELECT `port`, `posX`, `posY` FROM `users` WHERE `username`="' + d.Name + '"', (err, res) ->
                      if res.length is 0 or err
                        insOrUpd = 0
                      else
                        posX = res[0].posX
                        posY = res[0].posY
                      callback(null, "zero")
                  one: (callback) ->
                    if insOrUpd is 0
                      connection.query "INSERT INTO `users` (`port`, `username`) VALUES ('" + sock.remotePort + "', '" + d.Name + "');", (err, res) ->
                        console.log "ERR: " + err
                      callback(null, new ObjectUser(sock.remotePort, posX, posY)) #.affectedRows)
                    else
                      # console.log "UPDATE!"
                      connection.query "UPDATE `users` SET `port`=" + sock.remotePort + ", `isAlive`=1 WHERE `username`='" + d.Name + "';", (err, res) ->
                        console.log "ERR: " + err
                      callback(null, new ObjectUser(sock.remotePort, posX, posY)) #.affectedRows)
                , (err, results) ->
                    if not err
                      users_sockets[sock.remotePort] = d.Name
                      sys.puts "Connected: " + sock.remoteAddress + ":" + sock.remotePort
                      sockets[sock.remotePort] = sock
                      sendMap 0, results.one
                      newConnectionWarningUser results.one
                      # http://nodejs.org/api/timers.html#timers_settimeout_callback_delay_arg
              when "move"
                if isGame is true
                  sock.write data
                connection.query "UPDATE `users` SET `port`=" + sock.remotePort + ",`posX`=" + d.Pos.X + ",`posY`=" + d.Pos.Y + " WHERE `port`=" + sock.remotePort + ";", (err) ->
                  if isGame is false
                    sock.write data
              when "position"
                sendPosition sock.remotePort
                return


              when "initFight"
                id_battle = incrementAndGet()
                id_enemy = d.Id_enemy
                fs = new FightStatus(id_battle, sock.remotePort, id_enemy)
                sockets[id_enemy].write "{\"Action\":\"sendInitFight\",\"Id_battle\":" + id_battle + "}"
                fs.setState "NeedACK"

                battles[id_battle] = fs

                return
              when "sendAckInitFight"
                id_battle = d.Id_battle
                fs = battles[id_battle]
                msg = "{\"Action\":\"okInitFight\",\"Id_battle\":" + id_battle + "}"
                sockets[fs.getIdEmisor()].write "{\"Action\":\"sendInitFight\",\"Id_battle\":" + id_battle + "}"
                sockets[fs.getIdReceiver()].write "{\"Action\":\"sendInitFight\",\"Id_battle\":" + id_battle + "}"

                fs.setState "OkInit"
                battles[id_battle] = fs

                return
              when "okInitFight"
                mutex_battles.lock ->
                  id_battle = d.Id_battle
                  fs = battles[id_battle]
                  fs.addPlayer()
                  battles[id_battle] = fs
                  this.semaphore++;
                  mutex_battles.unlock();
                  return

                if fs.getPlayers() is 2
                  fs.setState "Fight"
                  battles[id_battle] = fs

                  setTimeout (->
                    sendDiePlayerAndWinnerToShow fs.getIdEmisor() fs.getIdReceiver()
                  ), 1000

                return
              when "fight"
                sendFightToAnotherClient sock.remotePort, d.Id_enemy
                return
              when "finishBattle"
                sendDiePlayerAndWinnerToShow sock.remotePort, d.Id_enemy
                return
              when "getObj"
                data = `undefined`
                # Avisamos al mismo cliente si puede obtener el objeto
                console.log "USUARIO: " + JSON.stringify users_sockets[sock.remotePort]
                connection.query "UPDATE `object_map` SET `admin`='" + users_sockets[sock.remotePort] + "' WHERE `id`="+ d.Id_obj + " AND `id_map`=1;", (err) ->
                  if not err
                    console.log "Obtenido objeto"
                    sock.write JSON.stringify(
                      "Action": "getObjFromServer"
                      "Id": d.Id_obj
                      "OK": 1
                    )
                    d["Action"] = "remObj"
                    delete d.Id_user
                    data = JSON.stringify d
                    console.log "AL OBTENER OBJETO MANDAMOS : " + data
                    maps[0].removeKeyObject(d.Id_obj)

                    len = sockets.length
                    console.log "MANDAMOS " + data + " a " + len + " usuarios"

                    for port in sockets
                      sockets[port].write data  if sockets[port]  if sockets[port] isnt sock
                  else  # Si falla es porque otra persona lo puede haber cogido antes el objeto
                    console.log "Error obtener objeto"
                    sock.write JSON.stringify(
                      "Action": "getObjFromServer"
                      "Id": d.Id_obj
                      "OK": 0
                    )
                    #return
              when "freeObj"
                connection.query "UPDATE `object_map` SET `posX`=" + d.Obj.PosX + ",`posY`=" + d.Obj.PosY + ",`admin`=NULL WHERE `id`="+ d.Obj.Id_obj+" AND `id_map`=1;", (err) ->
                  if not err
                      obj = maps[0].addKeyObject d.Obj.Id_obj, d.Obj.PosX, d.Obj.PosY
                      data = JSON.stringify(
                        "Action": "addObj"
                        "Obj": obj
                      )
                      sock.write JSON.stringify(
                        "Action": "liberateObj"
                        "Id": d.Obj.Id_obj
                        "OK": 1
                      )
                    else
                      data = `undefined`
                      sock.write JSON.stringify(
                        "Action": "liberateObj"
                        "Id": d.Obj.Id_obj
                        "OK": 0
                      )
              when "exit"
                sys.puts "exit command received: " + sock.remoteAddress + ":" + sock.remotePort + "\n"
                if isGame is true
                  sock.write data
                ret = JSON.stringify(
                  Action: "exit"
                  Id: sock.remotePort
                )

                delete users_sockets[sock.remotePort]

                sys.puts "ACTUAL: " + sockets.length
                idx = sockets[sock.remotePort]
                sys.puts "Desconectado " + idx
                sys.puts sockets
                if idx isnt `undefined`
                  delete sockets[sock.remotePort]
                  sys.puts "Borrado " + idx
                sys.puts "ACTUAL: " + sockets.length

                if not isGame
                  sock.write data

                #for port in sockets
                #  sockets[port].write ret  if sockets[port]  if sockets[port] isnt sock

                connection.query "UPDATE `users` SET `isAlive`=0 WHERE `port`=" + sock.remotePort + ";", (err) ->
                return
            console.log("DATA => "  + data + sockets.length)
            if data isnt `undefined`
              for port of sockets
                sockets[port].write data  if sockets[port]  if sockets[port] isnt sock

          return

        sock.on "end", ->
          sys.puts "Disconnected end: " + sock.remotePort + "\n"
          return

        sock.on "error", (exc) ->
          # sys.puts "Disconnected: " + sock.remotePort + "\n"
          # sys.log "ignoring exception: " + exc
          return

        sendDiePlayerAndWinnerToShow = (emisor_id, receiver_id) ->
          ret = `undefined`
          valueC = `undefined`
          valueE = `undefined`
          winner = `undefined`
          winner = -1
          valueC = -1
          valueE = -1

          emisor_roll = `undefined`
          receiver_roll = `undefined`

          connection.query 'SELECT `port`, `rollDice` FROM `users` WHERE `port`="' + emisor_id + '" or `port`=' + receiver_id + ';', (err, res) ->
            i = 0 # broad cast
            len = res.length
            # console.log("EMISOR: " + emisor_id + " - " + "RECEIVER: " + receiver_id)
            while i < len
              # console.log(res[i])
              # console.log(res[i].port)
              if res[i].port is emisor_id
                emisor_roll = res[i].rollDice
              else if res[i].port is receiver_id
                receiver_roll = res[i].rollDice
              i++
              # console.log("EMISOR ROLL: " + emisor_roll + " - " + "RECEIVER ROLL: " + receiver_roll)
            unless emisor_roll
              winner = receiver_id
              valueC = receiver_roll
            else unless receiver_roll
              winner = emisor_id
              valueE = emisor_roll
            else if emisor_roll > receiver_roll
              winner = emisor_id
              valueE = emisor_roll
              valueC = receiver_roll
            else if receiver_roll > emisor_roll
              winner = receiver_id
              valueE = emisor_roll
              valueC = receiver_roll
            ret = JSON.stringify(
              Action: "finishBattle"
              ValueClient: valueC
              ValueEnemy: valueE
              Winner: winner
            )
            sock.write ret
            return

        return
      )
      svraddr = "0.0.0.0"
      svrport = 8089
      svr.listen svrport, svraddr
      sys.puts "Server Created at " + svraddr + ":" + svrport + "\n"
      return
