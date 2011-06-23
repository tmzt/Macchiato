# This file defines the DelayedTask class, and exposes it to the outside world.
#
# DelayedTask wraps the actual running of the task function in a JavaScript
# timeout using the setTimeout function. This makes the execution of the "run"
# method on this class detached from the eventual execution of the task
# function itself.
class DelayedTask extends TimerTask

	# Takes the task function and any options, then assigns them to this
	# object.
	#
	# param  function  taskFunction            The task function itself.
	# param  integer   delay         optional  The length of the delay, in
	#                                          milliseconds. Defaults to 1.
	# param  object    runScope      optional  The scope to run the task
	#                                          function at. Defaults to @.
	constructor: (taskFunction, delay = 1, runScope = @) ->
		# Invoke the parent constructor
		super taskFunction, "timeout", delay, runScope
		# Set the instance variables to their initial state
		@reset()

# Expose this class to the parent scope
Macchiato.expose "DelayedTask", DelayedTask
