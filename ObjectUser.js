// Copyright (c) 2015, maldicion069 (Cristian Rodríguez) <ccrisrober@gmail.con>
//
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
//
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.package com.example

/*
class ObjectUser
  constructor:(@Id, @PosX, @PosY, @Map = 0, @RollDice = 0) ->
  getId: -> @Id
  getRollDice: -> @RollDice
  setPosX:(x) -> @PosX = x
  setPosY:(y) -> @PosY = y
  getPosX: -> @PosX
  getPosY: -> @PosY
  getMap: -> @Map
  setMap:(m) -> @Map = m
  setPosition:(x, y) ->
    @PosX = x
    @PosY = y
  setRollDice:(dice) ->
    @RollDice = dice

s = new ObjectUser(1, 2, 3)
console.log s.getPosX()
s.setPosX(12)
console.log s.getPosX()
*/

var ObjectUser = (function() {
  function ObjectUser(id, posX, posY, map, rollDice) {
    this.Id = id;
    this.PosX = posX;
    this.PosY = posY;
    this.Map = map != null ? map : 0;
    this.RollDice = rollDice != null ? rollDice : 0;
    // Me
    this.Objects = {}; // TODO: Podemos guardar si eso solo una lista, sin importar qué objeto es, solo su id!!!
  }

  ObjectUser.prototype.getId = function() {
    return this.Id;
  };

  ObjectUser.prototype.getRollDice = function() {
    return this.RollDie;
  };

  ObjectUser.prototype.setPosX = function(x) {
    return this.PosX = x;
  };

  ObjectUser.prototype.setPosY = function(y) {
    return this.PosY = y;
  };

  ObjectUser.prototype.getPosX = function() {
    return this.PosX;
  };

  ObjectUser.prototype.getPosY = function() {
    return this.PosY;
  };

  ObjectUser.prototype.getMap = function() {
    return this.Map;
  };

  ObjectUser.prototype.setMap = function(m) {
    return this.Map = m;
  };

  ObjectUser.prototype.setPosition = function(x, y) {
    this.PosX = x;
    return this.PosY = y;
  };

  ObjectUser.prototype.setRollDice = function(die) {
    return this.RollDie = die;
  };

  /*// me
  ObjectUser.prototype.addObject = function(obj) {
    this.Objects[obj.getId()] = obj;
  };

  // me
  ObjectUser.prototype.removeObject = function(id_obj) {
    delete this.Objects[id_obj];
  };*/

  return ObjectUser;

})();

module.exports = ObjectUser;
