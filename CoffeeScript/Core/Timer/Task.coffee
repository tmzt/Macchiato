# This file defines the TimerTask class.
#
# TimerTask delegates the actual running of the task function to one of the two
# available native JavaScript timer metaphors, either setTimeout or
# setInterval.
class TimerTask extends Task

	# Takes the task function and any options, then assigns them to this
	# object.
	#
	# param  function  taskFunction            The task function itself.
	# param  object    timer         optional  The timer function to use,
	#                                          either setTimeout or
	#                                          setInterval. Defaults to
	#                                          setTimeout.
	# param  integer   interval      optional  The length of the interval, in
	#                                          milliseconds. Defaults to 1.
	# param  object    runScope      optional  The scope to run the task
	#                                          function at. Defaults to @.
	constructor: (taskFunction, timer = null, interval = 1, runScope = @) ->
		# Invoke the parent constructor
		super taskFunction, runScope
		# If timer is null, default it to setTimeout
		timer = setTimeout if timer is null
		# Store the the desired timer
		@timer = timer
		# Store the desired interval
		@interval = interval
		# Set the instance variables to their initial state
		@reset()

	# Resets the state of this class instance by initializing all of the class
	# variables.
	#
	# return  object  A reference to this class instance.
	reset: ->
		# Reset the value of the timer reference class variable
		@timerReference = null
		# Reset the variable that tells us if we have executed the task
		@timerExecuted = no
		# Return a reference to this class instance
		return @

	# Cancels the future execution of the task.
	#
	# return  object  A reference to this class instance.
	cancel: ->
		# If we have a timer that we can cancel
		if @timerReference isnt null
			# If the timer is setTimeout
			if @timer is setTimeout 
				# Clear the timeout if it has not already run
				clearTimeout @timerReference if @timerExecuted is no
			else if @timer is setInterval
				# Clear the interval
				clearInterval @timerReference
		# Reset the class state back to the initial values
		@reset()
		# Return a reference to this class instance
		return @

	# Runs the task function using the passed arguments.
	#
	# param   mixed   ...  optional  Any number of arguments to forward to the task
	#                                function itself.
	# return  object                 A reference to this class instance.
	run: ->
		# Create a new instance of the Arguments class to convert the arguments
		# object into an array
		taskArguments = (new Arguments(arguments)).toArray()
		# Store a reference to the timer
		@timerReference = @timer =>
			# Notify any observers attached to the "run" channel
			@notifyObservers "run", @
			# Inform the class that this timer function has been run
			@timerExecuted = yes
			# Wrap this run attempt in a try/catch so we can capture exceptions
			try
				# Run the task function at the desired scope
				@taskFunction.apply @runScope, taskArguments
			# If an exception is thrown, catch it
			catch exception
				# Notify any observers attached to the "exception" channel
				@notifyObservers "exception", @, exception
		# Forward the desired interval to the timer function
		, @interval
		# Return a reference to this class instance
		return @
