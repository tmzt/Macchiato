/**
 * Copyright (c) 2011 Macchiato Team. See included AUTHORS file.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
(function() {
  var DebouncedTask, DelayedTask, IdempotentTask, Meta, Observable, PublishSubscribe, Task, Tasks;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Meta = {
    expose: (function(exposeScope) {
      return function(name, reference) {
        exposeScope[name] = reference;
        return this;
      };
    })(typeof exports != "undefined" && exports !== null ? exports : this)
  };
  Task = function() {
    function Task(taskFunction, runScope) {
      if (runScope == null) {
        runScope = this;
      }
      this.taskFunction = taskFunction;
      this.runScope = runScope;
    }
    Task.prototype.run = function(taskArguments) {
      if (taskArguments == null) {
        taskArguments = [];
      }
      this.taskFunction.apply(this.runScope, taskArguments);
      return this;
    };
    return Task;
  }();
  Meta.expose('Task', Task);
  IdempotentTask = function() {
    __extends(IdempotentTask, Task);
    function IdempotentTask(taskFunction, runScope) {
      if (runScope == null) {
        runScope = this;
      }
      IdempotentTask.__super__.constructor.call(this, taskFunction, runScope);
      this.reset();
    }
    IdempotentTask.prototype.reset = function() {
      this.runCount = 0;
      return this;
    };
    IdempotentTask.prototype.run = function(taskArguments) {
      if (taskArguments == null) {
        taskArguments = [];
      }
      if (this.runCount > 0) {
        return;
      }
      this.runCount++;
      IdempotentTask.__super__.run.call(this, taskArguments);
      return this;
    };
    return IdempotentTask;
  }();
  Meta.expose('IdempotentTask', IdempotentTask);
  DelayedTask = function() {
    __extends(DelayedTask, Task);
    function DelayedTask(taskFunction, delay, runScope) {
      if (delay == null) {
        delay = 1;
      }
      if (runScope == null) {
        runScope = this;
      }
      DelayedTask.__super__.constructor.call(this, taskFunction, runScope);
      this.reset();
    }
    DelayedTask.prototype.reset = function() {
      this.timeoutReference = null;
      this.timeoutExecuted = false;
      return this;
    };
    DelayedTask.prototype.cancel = function() {
      if (this.timeoutReference !== null && this.timeoutExecuted === false) {
        clearTimeout(this.timeoutReference);
      }
      this.reset();
      return this;
    };
    DelayedTask.prototype.run = function(taskArguments) {
      if (taskArguments == null) {
        taskArguments = [];
      }
      this.timeoutReference = setTimeout(__bind(function() {
        this.timeoutExecuted = true;
        return this.taskFunction.apply(this.runScope, taskArguments);
      }, this), this.delay);
      return this;
    };
    return DelayedTask;
  }();
  Meta.expose('DelayedTask', DelayedTask);
  DebouncedTask = function() {
    __extends(DebouncedTask, DelayedTask);
    function DebouncedTask(taskFunction, delay, runScope) {
      if (delay == null) {
        delay = 1;
      }
      if (runScope == null) {
        runScope = this;
      }
      DebouncedTask.__super__.constructor.call(this, taskFunction, delay, runScope);
    }
    DebouncedTask.prototype.run = function(taskArguments) {
      if (taskArguments == null) {
        taskArguments = [];
      }
      this.cancel();
      DebouncedTask.__super__.run.call(this, taskArguments);
      return this;
    };
    return DebouncedTask;
  }();
  Meta.expose('DebouncedTask', DebouncedTask);
  Tasks = function() {
    function Tasks(tasks) {
      var taskFunction, _i, _len;
      if (tasks == null) {
        tasks = [];
      }
      this.reset();
      if (tasks.length > 0) {
        for (_i = 0, _len = tasks.length; _i < _len; _i++) {
          taskFunction = tasks[_i];
          this.add(taskFunction);
        }
      }
    }
    Tasks.prototype.reset = function() {
      this.state = {};
      this.taskQueue = [];
      this.currentTask = 0;
      return this;
    };
    Tasks.prototype.add = function(taskFunction) {
      this.taskQueue.push(new Task(taskFunction, this));
      return this;
    };
    Tasks.prototype.next = function() {
      if (!this.exists(this.currentTask + 1)) {
        return this;
      }
      this.currentTask++;
      return this.run();
    };
    Tasks.prototype.previous = function() {
      if (!this.exists(this.currentTask - 1)) {
        return this;
      }
      this.currentTask--;
      return this.run();
    };
    Tasks.prototype.exists = function(taskIndex) {
      return this.taskQueue[taskIndex] != null;
    };
    Tasks.prototype.run = function() {
      if (this.exists(this.currentTask)) {
        this.taskQueue[this.currentTask].run([this, this.state]);
      }
      return this;
    };
    return Tasks;
  }();
  Tasks.runTasks = function(tasks) {
    return new Tasks(tasks).run();
  };
  Meta.expose('Tasks', Tasks);
  Observable = function() {
    function Observable() {
      this.observers = [];
    }
    Observable.prototype.addObserver = function(observer) {
      this.observers.push(observer);
      return this;
    };
    Observable.prototype.subscribe = function(observer) {
      return this.addObserver(observer);
    };
    Observable.prototype.notifyObservers = function(message) {
      var observer, _i, _len, _ref;
      if (this.observers.length > 0) {
        _ref = this.observers;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          observer = _ref[_i];
          observer(message);
        }
      }
      return this;
    };
    Observable.prototype.publish = function(message) {
      return this.notifyObservers(message);
    };
    return Observable;
  }();
  Meta.expose('Observable', Observable);
  PublishSubscribe = function() {
    function PublishSubscribe() {
      this.universalChannel = new Observable();
      this.namedChannels = {};
    }
    PublishSubscribe.prototype.addChannel = function(name) {
      this.namedChannels[name] = new Observable();
      return this;
    };
    PublishSubscribe.prototype.addChannels = function(names) {
      var name, _i, _len;
      if (names.length > 0) {
        for (_i = 0, _len = names.length; _i < _len; _i++) {
          name = names[_i];
          this.addChannel(name);
        }
      }
      return this;
    };
    PublishSubscribe.prototype.addObserver = function(name, observer) {
      var _ref;
      if (name !== '*') {
        if ((_ref = this.namedChannels[name]) != null) {
          _ref.addObserver(observer);
        }
        return this;
      }
      this.universalChannel.addObserver(observer);
      return this;
    };
    PublishSubscribe.prototype.subscribe = function(name, observer) {
      return this.addObserver(name, observer);
    };
    PublishSubscribe.prototype.notifyObservers = function(name, message) {
      var _ref;
      if (message == null) {
        message = null;
      }
      if (name !== '*') {
        if ((_ref = this.namedChannels[name]) != null) {
          _ref.notifyObservers(message);
        }
      }
      this.universalChannel.notifyObservers(message);
      return this;
    };
    PublishSubscribe.prototype.publish = function(name, message) {
      if (message == null) {
        message = null;
      }
      return this.notifyObservers(name, message);
    };
    return PublishSubscribe;
  }();
  Meta.expose('PublishSubscribe', PublishSubscribe);
}).call(this);
