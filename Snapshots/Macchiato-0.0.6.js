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
  var Arguments, Assertion, AssertionFailure, AssertionSuccess, DebouncedTask, DelayedTask, HTMLElement, Log, MacchiatoClass, Meta, Observable, PublishSubscribe, RepeatedTask, Rule, Rules, Synchronizable, Task, Tasks, Test, Tests, TimerTask;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Meta = {
    exposed: {},
    expose: (function(exposeScope) {
      return function(name, reference) {
        this.exposed[name] = reference;
        exposeScope[name] = reference;
        return this;
      };
    })(typeof exports != "undefined" && exports !== null ? exports : this),
    overlay: function(destination) {
      var name, reference, _ref;
      _ref = Meta.exposed;
      for (name in _ref) {
        if (!__hasProp.call(_ref, name)) continue;
        reference = _ref[name];
        destination[name] = reference;
      }
      return destination;
    }
  };
  Meta.expose('overlay', Meta.overlay);
  MacchiatoClass = (function() {
    function MacchiatoClass() {}
    MacchiatoClass.prototype.callMethodArray = function(name, argumentsArray) {
      if (argumentsArray == null) {
        argumentsArray = [];
      }
      return this[name].apply(this, argumentsArray);
    };
    return MacchiatoClass;
  })();
  Meta.expose("MacchiatoClass", MacchiatoClass);
  Arguments = (function() {
    __extends(Arguments, MacchiatoClass);
    function Arguments(argumentsObject) {
      this.argumentsArray = Array.prototype.slice.call(argumentsObject, 0);
    }
    Arguments.prototype.toArray = function() {
      return this.argumentsArray;
    };
    return Arguments;
  })();
  Meta.expose("Arguments", Arguments);
  Observable = (function() {
    __extends(Observable, MacchiatoClass);
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
    Observable.prototype.notifyObservers = function() {
      var observer, observerArguments, _i, _len, _ref;
      if (this.observers.length < 1) {
        return this;
      }
      observerArguments = (new Arguments(arguments)).toArray();
      _ref = this.observers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        observer = _ref[_i];
        observer.apply(this, observerArguments);
      }
      return this;
    };
    Observable.prototype.publish = function() {
      var observerArguments;
      observerArguments = (new Arguments(arguments)).toArray();
      return this.callMethodArray("notifyObservers", observerArguments);
    };
    return Observable;
  })();
  Meta.expose("Observable", Observable);
  PublishSubscribe = (function() {
    __extends(PublishSubscribe, MacchiatoClass);
    function PublishSubscribe() {
      var names;
      this.universalChannel = new Observable();
      this.namedChannels = {};
      names = (new Arguments(arguments)).toArray();
      if (names.length > 0) {
        this.callMethodArray("addChannels", names);
      }
    }
    PublishSubscribe.prototype.addChannel = function(name) {
      this.namedChannels[name] = new Observable();
      return this;
    };
    PublishSubscribe.prototype.addChannels = function() {
      var name, names, _i, _len;
      names = (new Arguments(arguments)).toArray();
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
      if (name !== "*") {
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
    PublishSubscribe.prototype.notifyObservers = function(name) {
      var notificationArguments, observerArguments, _ref;
      notificationArguments = (new Arguments(arguments)).toArray();
      if (name !== "*" && (this.namedChannels[name] != null)) {
        observerArguments = notificationArguments.slice(1);
        if ((_ref = this.namedChannels[name]) != null) {
          _ref.callMethodArray("notifyObservers", observerArguments);
        }
      }
      this.universalChannel.callMethodArray("notifyObservers", notificationArguments);
      return this;
    };
    PublishSubscribe.prototype.publish = function() {
      var notificationArguments;
      notificationArguments = (new Arguments(arguments)).toArray();
      return this.callMethodArray("notifyObservers", notificationArguments);
    };
    return PublishSubscribe;
  })();
  Meta.expose("PublishSubscribe", PublishSubscribe);
  Log = (function() {
    __extends(Log, PublishSubscribe);
    function Log() {
      Log.__super__.constructor.call(this, "info", "debug", "error");
    }
    Log.prototype.add = function(level, message) {
      return this.notifyObservers(level, [message]);
    };
    Log.prototype.info = function(message) {
      return this.add("info", message);
    };
    Log.prototype.debug = function(message) {
      return this.add("debug", message);
    };
    Log.prototype.error = function(message) {
      return this.add("error", message);
    };
    Log.prototype.attach = function(instance) {
      this.addObserver("*", function(level, message) {
        return instance.add(level, message);
      });
      return this;
    };
    return Log;
  })();
  Log = new Log;
  Meta.expose("Log", Log);
  Task = (function() {
    __extends(Task, PublishSubscribe);
    function Task(taskFunction, runScope) {
      this.taskFunction = taskFunction;
      this.runScope = runScope != null ? runScope : this;
      Task.__super__.constructor.call(this, "run", "exception");
    }
    Task.prototype.run = function() {
      var taskArguments;
      taskArguments = (new Arguments(arguments)).toArray();
      this.notifyObservers("run", this);
      try {
        this.taskFunction.apply(this.runScope, taskArguments);
      } catch (exception) {
        this.notifyObservers("exception", this, exception);
      }
      return this;
    };
    return Task;
  })();
  Meta.expose("Task", Task);
  TimerTask = (function() {
    __extends(TimerTask, Task);
    function TimerTask(taskFunction, timer, interval, runScope) {
      if (timer == null) {
        timer = "timeout";
      }
      if (interval == null) {
        interval = 1;
      }
      if (runScope == null) {
        runScope = this;
      }
      TimerTask.__super__.constructor.call(this, taskFunction, runScope);
      this.timer = timer;
      this.interval = interval;
      this.reset();
    }
    TimerTask.prototype.reset = function() {
      this.timerReference = null;
      this.timerExecuted = false;
      return this;
    };
    TimerTask.prototype.cancel = function() {
      if (this.timerReference !== null) {
        if (this.timer === "timeout") {
          if (this.timerExecuted === false) {
            clearTimeout(this.timerReference);
          }
        } else if (this.timer === "interval") {
          clearInterval(this.timerReference);
        }
      }
      this.reset();
      return this;
    };
    TimerTask.prototype.run = function() {
      var taskArguments, wrapperFunction;
      taskArguments = (new Arguments(arguments)).toArray();
      wrapperFunction = __bind(function() {
        this.notifyObservers("run", this);
        this.timerExecuted = true;
        try {
          return this.taskFunction.apply(this.runScope, taskArguments);
        } catch (exception) {
          return this.notifyObservers("exception", this, exception);
        }
      }, this);
      if (this.timer === "timeout") {
        this.timerReference = setTimeout(wrapperFunction, this.interval);
      } else if (this.timer === "interval") {
        this.timerReference = setInterval(wrapperFunction, this.interval);
      }
      return this;
    };
    return TimerTask;
  })();
  DelayedTask = (function() {
    __extends(DelayedTask, TimerTask);
    function DelayedTask(taskFunction, delay, runScope) {
      if (delay == null) {
        delay = 1;
      }
      if (runScope == null) {
        runScope = this;
      }
      DelayedTask.__super__.constructor.call(this, taskFunction, "timeout", delay, runScope);
      this.reset();
    }
    return DelayedTask;
  })();
  Meta.expose("DelayedTask", DelayedTask);
  DebouncedTask = (function() {
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
    DebouncedTask.prototype.run = function() {
      var taskArguments;
      taskArguments = (new Arguments(arguments)).toArray();
      this.cancel();
      DebouncedTask.__super__.run.apply(this, taskArguments);
      return this;
    };
    return DebouncedTask;
  })();
  Meta.expose("DebouncedTask", DebouncedTask);
  RepeatedTask = (function() {
    __extends(RepeatedTask, TimerTask);
    function RepeatedTask(taskFunction, interval, runScope) {
      if (interval == null) {
        interval = 1;
      }
      if (runScope == null) {
        runScope = this;
      }
      RepeatedTask.__super__.constructor.call(this, taskFunction, "interval", interval, runScope);
      this.reset();
    }
    return RepeatedTask;
  })();
  Meta.expose("RepeatedTask", RepeatedTask);
  Tasks = (function() {
    __extends(Tasks, MacchiatoClass);
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
      this.taskQueue = [];
      this.currentTask = 0;
      return this;
    };
    Tasks.prototype.add = function(taskFunction) {
      this.taskQueue.push(new Task(taskFunction, this));
      return this;
    };
    Tasks.prototype.next = function() {
      var taskArguments;
      if (!this.exists(this.currentTask + 1)) {
        return this;
      }
      this.currentTask++;
      taskArguments = (new Arguments(arguments)).toArray();
      return this.callMethodArray("run", taskArguments);
    };
    Tasks.prototype.previous = function() {
      var taskArguments;
      if (!this.exists(this.currentTask - 1)) {
        return this;
      }
      this.currentTask--;
      taskArguments = (new Arguments(arguments)).toArray();
      return this.callMethodArray("run", taskArguments);
    };
    Tasks.prototype.exists = function(taskIndex) {
      return this.taskQueue[taskIndex] != null;
    };
    Tasks.prototype.runAll = function() {
      var task, taskArguments, _i, _len, _ref;
      taskArguments = (new Arguments(arguments)).toArray();
      taskArguments.unshift(this);
      _ref = this.taskQueue;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        task = _ref[_i];
        task.callMethodArray("run", taskArguments);
      }
      return this;
    };
    Tasks.prototype.run = function() {
      var taskArguments;
      taskArguments = (new Arguments(arguments)).toArray();
      taskArguments.unshift(this);
      if (this.exists(this.currentTask)) {
        this.taskQueue[this.currentTask].callMethodArray("run", taskArguments);
      }
      return this;
    };
    return Tasks;
  })();
  Tasks.runTasks = function(tasks) {
    return new Tasks(tasks).run();
  };
  Meta.expose("Tasks", Tasks);
  Synchronizable = (function() {
    function Synchronizable() {}
    return Synchronizable;
  })();
  Meta.expose("Synchronizable", Synchronizable);
  Rules = (function() {
    function Rules() {
      Rules.__super__.constructor.apply(this, arguments);
    }
    __extends(Rules, PublishSubscribe);
    Rules.prototype.evaluate = function(name) {
      return this;
    };
    return Rules;
  })();
  Meta.expose("Rules", Rules);
  Rule = (function() {
    __extends(Rule, PublishSubscribe);
    function Rule(type, evaluator, data) {
      this.type = type;
      this.evaluator = evaluator;
      this.data = data;
      this.passTasks = new Tasks;
      this.failTasks = new Tasks;
    }
    Rule.prototype.addPassTask = function(taskFunction) {
      this.passTasks.add(taskFunction);
      return this;
    };
    Rule.prototype.addFailTask = function(taskFunction) {
      this.passTasks.add(taskFunction);
      return this;
    };
    Rule.prototype.evaluate = function() {
      var evaluationTasks;
      if (this.type === "regex") {
        this.evaluator.match(this.data);
      } else if (this.type === "string") {} else if (this.type === "function") {
        evaluationTasks = new Tasks([
          __bind(function(evaluationTaskControl) {
            var evaluationResult;
            evaluationResult = this.evaluator(evaluationTaskControl);
            if (evaluationResult === true) {
              return evaluationTaskControl.next(true);
            }
          }, this), __bind(function(evaluationTaskControl, evaluationResult) {
            if (evaluationResult === true) {
              return this.passTasks.runAll();
            } else {
              return this.failTasks.runAll();
            }
          }, this)
        ]);
        evaluationTasks.run();
      }
      return this;
    };
    return Rule;
  })();
  Meta.expose("Rule", Rule);
  HTMLElement = (function() {
    __extends(HTMLElement, PublishSubscribe);
    function HTMLElement() {
      HTMLElement.__super__.constructor.call(this);
    }
    return HTMLElement;
  })();
  Meta.expose("HTMLElement", HTMLElement);
  Meta.test = function(name, reference) {
    var instance;
    instance = new reference(name);
    instance.run();
    return this;
  };
  Assertion = (function() {
    __extends(Assertion, MacchiatoClass);
    function Assertion(description) {
      this.description = description;
    }
    return Assertion;
  })();
  AssertionSuccess = (function() {
    __extends(AssertionSuccess, Assertion);
    function AssertionSuccess(description) {
      AssertionSuccess.__super__.constructor.call(this, description);
    }
    return AssertionSuccess;
  })();
  AssertionFailure = (function() {
    __extends(AssertionFailure, Assertion);
    function AssertionFailure(description) {
      AssertionFailure.__super__.constructor.call(this, description);
    }
    return AssertionFailure;
  })();
  Test = (function() {
    __extends(Test, PublishSubscribe);
    function Test(name, testFunction, testScope) {
      var task;
      if (testScope == null) {
        testScope = this;
      }
      Test.__super__.constructor.call(this);
      this.name = name;
      this.task = new Task(testFunction, testScope);
      this.addChannels("start", "assertion", "complete", "exception");
      this.started = false;
      this.completed = false;
      this.exception = false;
      this.successful = null;
      this.assertions = [];
      this.successfulAssertions = 0;
      this.failedAssertions = 0;
      task = new Task(testFunction, testScope);
      task.addObserver("exception", __bind(function(task, exception) {
        this.successful = false;
        this.exception = true;
        return this.notifyObservers("exception", this, exception);
      }, this));
      this.task = task;
    }
    Test.prototype.run = function() {
      this.started = true;
      this.notifyObservers("start", this);
      this.task.run(this);
      return this;
    };
    Test.prototype.assertTrue = function(subject, description) {
      var assertion;
      if (description == null) {
        description = "";
      }
      if (subject === true) {
        assertion = new AssertionSuccess(description);
        this.successfulAssertions++;
      } else {
        this.successful = false;
        assertion = new AssertionFailure(description);
        this.failedAssertions++;
      }
      this.assertions.push(assertion);
      this.notifyObservers("assertion", this, assertion);
      return this;
    };
    Test.prototype.assertFalse = function(subject, description) {
      if (description == null) {
        description = "";
      }
      return this.assertTrue(!subject, description);
    };
    Test.prototype.assertEquals = function(left, right, description) {
      if (description == null) {
        description = "";
      }
      return this.assertTrue(left === right, description);
    };
    Test.prototype.complete = function() {
      this.completed = true;
      if (this.successful === null) {
        this.successful = true;
      }
      this.notifyObservers("complete", this);
      return this;
    };
    return Test;
  })();
  Meta.expose("Test", Test);
  Tests = (function() {
    function Tests(name) {
      this.name = name;
    }
    Tests.prototype.reset = function() {
      this.tests = {};
      this.totalTests = 0;
      this.successfulTests = 0;
      this.failedTests = 0;
      return this;
    };
    Tests.prototype.run = function() {
      var method, name, test;
      this.reset();
      for (name in this) {
        method = this[name];
        if (!name.match(/^test[a-z0-9_]*$/i)) {
          continue;
        }
        if (typeof method !== "function") {
          continue;
        }
        test = new Test(name, method, this);
        test.addObserver("*", __bind(function(channel, test, reference) {
          if (reference == null) {
            reference = null;
          }
          return this.observer(channel, test, reference);
        }, this));
        this.tests[name] = test;
        this.totalTests++;
        test.run();
      }
      return this;
    };
    Tests.prototype.observer = function(channel, test, reference) {
      var description, exception, successful, testName;
      if (reference == null) {
        reference = null;
      }
      testName = "" + this.name + "." + test.name;
      if (channel === "assertion") {
        successful = reference instanceof AssertionSuccess;
        if (!successful) {
          description = reference.description;
          return console.log(("" + testName + ": Failed to assert that ") + ("" + description));
        }
      } else if (channel === "exception" || channel === "complete") {
        exception = test.exception;
        successful = test.successful;
        if (exception) {
          console.log("" + testName + ": Threw an exception: [" + reference + "]");
          return this.failedTests++;
        } else if (!successful) {
          console.log("" + testName + ": Test failed");
          return this.failedTests++;
        } else {
          return this.successfulTests++;
        }
      }
    };
    return Tests;
  })();
  Meta.expose("Tests", Tests);
}).call(this);
