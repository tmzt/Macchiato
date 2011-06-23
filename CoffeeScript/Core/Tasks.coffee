# Manages a list of Task classes and provides a set of stepper methods to
# advance and rewind the current position in the tasks queue.
class Tasks extends MacchiatoClass

	# Initialize the class variables and add any Task functions that were
	# passed in.
	#
	# param  array  tasks  optional  Adds functions in this array to the task
	#                                queue. Defaults to an empty array.
	constructor: (tasks = []) ->
		# Set everything to the initial state
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
	#                                 queue.
	# return  object                  A reference to this class instance.
	add: (taskFunction) ->
		# Adds a task to the task queue
		@taskQueue.push new Task taskFunction, @
		# Return a reference to this class instance
		return @

	# Runs the next task function in the tasks queue.
	#
	# param   mixed   ...  optional  Any number of arguments that we want to
	#                                forward to all of the observer functions.
	# return  object                 Returns the result of the run class
	#                                method.
	next: ->
		# Do nothing unless a next task actually exists
		return @ unless @exists @currentTask + 1
		# Increment the current task by 1
		@currentTask++
		# Create a new instance of the Arguments class to convert the arguments
		# object into an array
		taskArguments = (new Arguments(arguments)).toArray()
		# Run the current task, forwarding the arguments that were passed in
		return @callMethodArray "run", taskArguments

	# Runs the previous task in the tasks queue.
	#
	# return  object  Returns the result of the run class method.
	previous: ->
		# Do nothing unless a previous task actually exists
		return @ unless @exists @currentTask - 1
		# Decrement the current task by 1
		@currentTask--
		# Create a new instance of the Arguments class to convert the arguments
		# object into an array
		taskArguments = (new Arguments(arguments)).toArray()
		# Run the current task, forwarding the arguments that were passed in
		return @callMethodArray "run", taskArguments

	# Returns true if a task exists in the specified queue location.
	#
	# param   integer  taskIndex  The index in the task queue to check.
	# return  boolean             If the requested queue index exists, true.
	exists: (taskIndex) ->
		# Determine if the current task function exists or not
		return @taskQueue[taskIndex]?

	# Runs all of the tasks in the task queue.
	#
	# param   mixed   ...  Accepts any number of arguments which will be
	#                      forwarded to each of the task methods.
	# return  object       A reference to this class instance.
	runAll: ->
		# Create a new instance of the Arguments class to convert the arguments
		# object into an array
		taskArguments = (new Arguments(arguments)).toArray()
		# Make a reference to this class instance the first argument that we
		# pass into the task function
		taskArguments.unshift @
		# Loop over each of the tasks in the task queue and run them
		task.callMethodArray "run", taskArguments for task in @taskQueue
		# Return a reference to this class instance
		return @

	# Runs the current task in the task queue.
	#
	# param   mixed   ...  Accepts any number of arguments which will be
	#                      forwarded to the task method itself.
	# return  object       A reference to this class instance.
	run: ->
		# Create a new instance of the Arguments class to convert the arguments
		# object into an array
		taskArguments = (new Arguments(arguments)).toArray()
		# Make a reference to this class instance the first argument that we
		# pass into the task function
		taskArguments.unshift @
		# Run the current task, passing in a reference to the this Tasks class
		# instance, assuming we have a task at this queue position
		@taskQueue[@currentTask].callMethodArray "run", taskArguments if \
			@exists @currentTask
		# Return a reference to this class instance
		return @

# Define a simple helper function that creates a new instance of Tasks, using
# the passed tasks argument, then runs it immediately.
#
# param  array  tasks  The tasks to add to the new Tasks object.
Tasks.runTasks = (tasks) ->
	# Create the new Tasks class instance, and run it
	new Tasks(tasks).run()

# Expose this class to the parent scope
Macchiato.expose "Tasks", Tasks
