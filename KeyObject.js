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

/**
class Key
  constructor:(@Id, @PosX, @PosY, @Color) ->
  getId: -> @Id
  setPosX:(x) -> @PosX = x
  setPosY:(y) -> @PosY = y
  getPosX: -> @PosX
  getPosY: -> @PosY
  setColor:(color) -> @Color =color
  getColor: -> @Color
*/

var KeyObject = (function() {
  function KeyObject(id, posX, posY, color) {
    this.Id = id;
    this.PosX = posX;
    this.PosY = posY;
    this.Color = color;
  }

  KeyObject.prototype.getId = function() {
    return this.Id;
  };


  KeyObject.prototype.setPosX = function(x) {
    return this.PosX = x;
  };

  KeyObject.prototype.setPosY = function(y) {
    return this.PosY = y;
  };

  KeyObject.prototype.getPosX = function() {
    return this.PosX;
  };

  KeyObject.prototype.getPosY = function() {
    return this.PosY;
  };

  KeyObject.prototype.setColor = function(color) {
    return this.Color = color;
  };

  KeyObject.prototype.getColor = function() {
    return this.Color;
  };

  return KeyObject;

})();

module.exports = KeyObject;