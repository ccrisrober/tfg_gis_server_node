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
class Map
  constructor:(@Id, @MapFields, @Width, @Height, @KeyObjects) ->
  getId: -> @Id
  getMapFields: -> @MapFields
  getWidth: -> @Width
  getHeight: -> @Height
  getKeyObjects: -> @KeyObjects
m = new Map(1, "a, b, c", 5, 9)
*/

RealObjects = {};

var Map = (function() {

  function Map(Id, MapFields, Width, Height, KeyObjects) {
    this.Id = Id;
    this.MapFields = MapFields;
    this.Width = Width;
    this.Height = Height;
    this.KeyObjects = KeyObjects;

    console.log(this);
    console.log(RealObjects);
  }

  Map.prototype.getId = function() {
    return this.Id;
  };

  Map.prototype.getMapFields = function() {
    return this.MapFields;
  };

  Map.prototype.getWidth = function() {
    return this.Width;
  };

  Map.prototype.getHeight = function() {
    return this.Height;
  };

  Map.prototype.getKeyObjects = function() {
    return this.KeyObjects;
  };

  // Me
  Map.prototype.removeKeyObject = function(idx) {
    //this.KeyObjects.splice(idx, 1);
    console.log("REMOVE " + this.KeyObjects[idx]);
    this.KeyObjects[idx-1] = undefined;
    console.log(this.KeyObjects);
    console.log(RealObjects);
    return RealObjects[idx];
  }

    // Me
  Map.prototype.addKeyObject = function(idx, x, y) {
    console.log (idx + " " + x + " - " + y)
    console.log(RealObjects);
    RealObjects[idx].setPosX(x);
    RealObjects[idx].setPosY(y);
    this.KeyObjects[idx-1] = RealObjects[idx];
    console.log("Recuperado");
    return this.KeyObjects[idx-1];
  }

  return Map;

})();


module.exports = Map;
