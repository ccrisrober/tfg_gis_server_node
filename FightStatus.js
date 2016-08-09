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

var locks = require('locks');

var FightStatus = (function() {

  //{None, Init, NeedACK, OKInit, Fight, FinalFight};

  function FightStatus(id_battle, int id_emisor, int id_receiver) {
    this.id_battle = id_battle;
    this.id_emisor = id_emisor;
    this.id_receiver = id_receiver;

		this.state = "None";
		this.finish = false;
		this.semaphore = 0;
    this.mutex = locks.createMutex();
  }

  FightStatus.prototype.getIdBattle = function() {
    return this.id_battle;
  };

  FightStatus.prototype.getIdEmisor = function() {
    return this.id_emisor;
  };

  FightStatus.prototype.getIdReceiver = function() {
    return this.id_receiver;
  };

  FightStatus.prototype.getState = function() {
    return this.state;
  };

  FightStatus.prototype.isFinish = function() {
    return this.finish;
  };

  FightStatus.prototype.getConnecteds = function() {
    this.mutex.lock(function () {
      var v = this.semaphore;
      this.mutex.unlock();
      return v;
    });
  };

  FightStatus.prototype.addPlayer = function() {
    this.mutex.lock(function () {
      this.semaphore++;
      this.mutex.unlock();
    });
  };

  FightStatus.prototype.setState = function(state) {
    if (state == "FinalFight") {
      this.finish = true;
    }
    this.state = state
  };


  return FightStatus;

})();
