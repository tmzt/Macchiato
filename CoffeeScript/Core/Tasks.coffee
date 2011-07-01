# Manages a list of Task classes and provides a set of stepper methods to
# advance and rewind the current position in the tasks queue.
class Tasks extends MacchiatoClass

    # Initialize the instance variables and add any task functions that were
    # passed into the tasks array.
    #
    # param  array  tasks  optional  Adds functions in this array to the task
    #                                queue. Defaults to an empty array.
    constructor: (tasks = []) ->
        # Set everything to an initial state
        @reset()
        # Add each function in the passed tasks array
        @add taskFunction for taskFunction in tasks if tasks.length > 0

    # Resets the class variables to their initial state.
    #
    # return  object  A reference to this class instance.
    reset: ->
        # Holds the current list of tasks
        @taskQueue = []
        # Holds the next task index to run
        @currentTask = 0
        # Return a reference to this class instance
        return @

    # Adds a single task function to the task queue.
    #
    # param   function  taskFunction  A single task function to add to the
    #                                 task queue.
    # return  object                  A reference to this class instance.
    add: (taskFunction) ->
        # Adds a task to the task queue
        @taskQueue.push new Task taskFunction, @
        # Return a reference to this class instance
        return @

    # Runs the next task function in the tasks queue.
    #
    # param   mixed   ...  optional  Any number of arguments that we want to
    #                                forward to the next task.
    # return  object                 A reference to this class instance.
    next: ->
        # Do nothing unless task actually exists for the next task index
        return @ unless @exists @currentTask + 1
        # Increment the current task index by 1
        @currentTask++
        # Convert the arguments object into an array
        taskArguments = Arguments.convertToArray arguments
        # Run the current task, forwarding the arguments that were passed in
        return @callMethodArray "run", taskArguments

    # Runs the previous task function in the tasks queue.
    #
    # param   mixed   ...  optional  Any number of arguments that we want to
    #                                forward to the previous task.
    # return  object                 A reference to this class instance.
    previous: ->
        # Do nothing unless a previous task actually exists
        return @ unless @exists @currentTask - 1
        # Decrement the current task index by 1
        @currentTask--
        # Convert the arguments object into an array
        taskArguments = Arguments.convertToArray arguments
        # Run the current task, forwarding the arguments that were passed in
        return @callMethodArray "run", taskArguments

    # Returns true if a task exists in the tasks queue for the specified task
    # index.
    #
    # param   integer  taskIndex  The index in the task queue to check.
    # return  boolean             If the requested queue index exists, true.
    exists: (taskIndex) ->
        # Determine if the specified task function exists or not
        return @taskQueue[taskIndex]?

    # Runs all of the tasks in the task queue.
    #
    # param   mixed   ...  Accepts any number of arguments which will be
    #                      forwarded to each of the tasks.
    # return  object       A reference to this class instance.
    runAll: ->
        # Convert the arguments object into an array
        taskArguments = Arguments.convertToArray arguments
        # Inject a reference to this class instance as the first argument that
        # we pass into each of the task functions
        taskArguments.unshift @
        # Loop over each of the tasks in the task queue and run them
        task.callMethodArray "run", taskArguments for task in @taskQueue
        # Return a reference to this class instance
        return @

    # Runs the current task in the task queue.
    #
    # param   mixed   ...  Accepts any number of arguments which will be
    #                      forwarded to the current task.
    # return  object       A reference to this class instance.
    run: ->
        # Convert the arguments object into an array
        taskArguments = Arguments.convertToArray arguments
        # Inject a reference to this class instance as the first argument that
        # we pass into the task function
        taskArguments.unshift @
        # If we have a task in the tasks queue for the current task index
        if @exists @currentTask
            # Run the current task
            @taskQueue[@currentTask].callMethodArray "run", taskArguments
        # Return a reference to this class instance
        return @

    # Define a static helper method that creates a new instance of this class
    # using the passed tasks argument, then runs it immediately.
    #
    # param   array   tasks  optional  Adds functions in this array to the task
    #                                  queue. Defaults to an empty array.
    # return  object                   A reference to the new Tasks class
    #                                  instance.
    @runTasks: (tasks = []) ->
        # Create the new Tasks class instance, and run it
        new Tasks(tasks).run()

# Expose this class to the parent scope
Macchiato.expose "Tasks", Tasks
