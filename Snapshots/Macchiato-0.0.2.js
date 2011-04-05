(function() {
  var Assertion, AssertionFailure, AssertionSuccess, DebouncedTask, DelayedTask, HTMLElement, Log, Meta, Observable, PublishSubscribe, Synchronizable, Task, Tasks, Test, Tests;
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
    },
    test: function(name, reference) {
      var instance;
      instance = new reference(name);
      instance.run();
      return this;
    }
  };
  Meta.expose('overlay', Meta.overlay);
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
    Observable.prototype.notifyObservers = function(observerArguments) {
      var observer, _i, _len, _ref;
      if (observerArguments == null) {
        observerArguments = [];
      }
      if (this.observers.length > 0) {
        _ref = this.observers;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          observer = _ref[_i];
          observer.apply(this, observerArguments);
        }
      }
      return this;
    };
    Observable.prototype.publish = function(observerArguments) {
      if (observerArguments == null) {
        observerArguments = [];
      }
      return this.notifyObservers(observerArguments);
    };
    return Observable;
  }();
  Meta.expose("Observable", Observable);
  PublishSubscribe = function() {
    function PublishSubscribe(names) {
      if (names == null) {
        names = [];
      }
      this.universalChannel = new Observable();
      this.namedChannels = {};
      if (names.length > 0) {
        this.addChannels(names);
      }
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
    PublishSubscribe.prototype.notifyObservers = function(name, observerArguments) {
      var universalArguments, _ref;
      if (observerArguments == null) {
        observerArguments = [];
      }
      if (name !== "*") {
        if ((_ref = this.namedChannels[name]) != null) {
          _ref.notifyObservers(observerArguments);
        }
      }
      universalArguments = observerArguments.slice(0);
      universalArguments.unshift(name);
      this.universalChannel.notifyObservers(universalArguments);
      return this;
    };
    PublishSubscribe.prototype.publish = function(name, observerArguments) {
      if (observerArguments == null) {
        observerArguments = [];
      }
      return this.notifyObservers(name, observerArguments);
    };
    return PublishSubscribe;
  }();
  Meta.expose("PublishSubscribe", PublishSubscribe);
  Log = function() {
    __extends(Log, PublishSubscribe);
    function Log() {
      Log.__super__.constructor.call(this, ["info", "debug", "error"]);
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
  }();
  Log = new Log;
  Meta.expose("Log", Log);
  HTMLElement = function() {
    __extends(HTMLElement, PublishSubscribe);
    function HTMLElement() {
      HTMLElement.__super__.constructor.call(this);
    }
    return HTMLElement;
  }();
  Meta.expose("HTMLElement", HTMLElement);
  Task = function() {
    __extends(Task, PublishSubscribe);
    function Task(taskFunction, runScope) {
      if (runScope == null) {
        runScope = this;
      }
      Task.__super__.constructor.call(this);
      this.taskFunction = taskFunction;
      this.runScope = runScope;
      this.addChannels(["run", "exception"]);
    }
    Task.prototype.run = function(taskArguments) {
      if (taskArguments == null) {
        taskArguments = [];
      }
      this.notifyObservers("run", [this]);
      try {
        this.taskFunction.apply(this.runScope, taskArguments);
      } catch (exception) {
        this.notifyObservers("exception", [this, exception]);
      }
      return this;
    };
    return Task;
  }();
  Meta.expose("Task", Task);
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
        this.notifyObservers("run", [this]);
        this.timeoutExecuted = true;
        try {
          return this.taskFunction.apply(this.runScope, taskArguments);
        } catch (exception) {
          return this.notifyObservers("exception", [this, exception]);
        }
      }, this), this.delay);
      return this;
    };
    return DelayedTask;
  }();
  Meta.expose("DelayedTask", DelayedTask);
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
  Meta.expose("DebouncedTask", DebouncedTask);
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
  Meta.expose("Tasks", Tasks);
  Assertion = function() {
    function Assertion(description) {
      this.description = description;
    }
    return Assertion;
  }();
  AssertionSuccess = function() {
    __extends(AssertionSuccess, Assertion);
    function AssertionSuccess(description) {
      AssertionSuccess.__super__.constructor.call(this, description);
    }
    return AssertionSuccess;
  }();
  AssertionFailure = function() {
    __extends(AssertionFailure, Assertion);
    function AssertionFailure(description) {
      AssertionFailure.__super__.constructor.call(this, description);
    }
    return AssertionFailure;
  }();
  Synchronizable = function() {
    function Synchronizable() {}
    return Synchronizable;
  }();
  Meta.expose("Synchronizable", Synchronizable);
  Test = function() {
    __extends(Test, PublishSubscribe);
    function Test(name, testFunction, testScope) {
      var task;
      if (testScope == null) {
        testScope = this;
      }
      Test.__super__.constructor.call(this);
      this.name = name;
      this.task = new Task(testFunction, testScope);
      this.addChannels(["start", "assertion", "complete", "exception"]);
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
        return this.notifyObservers("exception", [this, exception]);
      }, this));
      this.task = task;
    }
    Test.prototype.run = function() {
      this.started = true;
      this.notifyObservers("start", [this]);
      this.task.run([this]);
      return this;
    };
    Test.prototype.assert = function(description, subject) {
      var assertion;
      if (subject === true) {
        assertion = new AssertionSuccess(description);
        this.successfulAssertions++;
      } else {
        this.successful = false;
        assertion = new AssertionFailure(description);
        this.failedAssertions++;
      }
      this.assertions.push(assertion);
      this.notifyObservers("assertion", [this, assertion]);
      return this;
    };
    Test.prototype.assertFalse = function(description, subject) {
      return this.assert(description, !subject);
    };
    Test.prototype.assertEqual = function(description, left, right) {
      return this.assert(description, left === right);
    };
    Test.prototype.assertNotEqual = function(description, left, right) {
      return this.assert(description, left !== right);
    };
    Test.prototype.complete = function() {
      this.completed = true;
      if (this.successful === null) {
        this.successful = true;
      }
      this.notifyObservers("complete", [this]);
      return this;
    };
    return Test;
  }();
  Meta.expose("Test", Test);
  Tests = function() {
    function Tests(name) {
      this.name = name;
    }
    Tests.prototype.reset = function() {
      this.tests = {};
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
          console.log("" + testName + ": Threw an exception");
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
  }();
  Meta.expose("Tests", Tests);
}).call(this);
