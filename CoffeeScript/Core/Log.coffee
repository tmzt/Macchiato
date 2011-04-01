# This file defines the Log class, and immediately overwrites its own
# definition variable with a single instance of itself. This single instance
# is then exposed to the outside world.
#
# Log extends the PublishSubscribe class to support the creation of different
# log writer classes.
class Log extends PublishSubscribe

	# Defines the named topic channels this class supports.
	constructor: ->
		# Invoke the parent constructor, passing in the named topic channels
		# this class instance supports
		super ["info", "debug", "error"]

	# Fires the appropriate notification to any observers that may be present. 
	#
	# param   string  The log level of the message.
	# param   string  The message to log.
	# return  object  A reference to this class instance.
	add: (level, message) ->
		# Issue the notification, passing in the log message
		@notifyObservers level, [message]

	# Issues an info-level notification with the passed message.
	#
	# param   string  The message to log.
	# return  object  A reference to this class instance.
	info: (message) ->
		# Issue the info-level notification
		@add "info", message

	# Issues a debug-level notification with the passed message.
	#
	# param   string  The message to log.
	# return  object  A reference to this class instance.
	debug: (message) ->
		# Issue the debug-level notification
		@add "debug", message

	# Issues an error-level notification with the passed message.
	#
	# param   string  The message to log.
	# return  object  A reference to this class instance.
	error: (message) ->
		# Issue the error-level notification
		@add "error", message

	# Allows for developers to attach their own custom log-writer classes
	# quickly and painlessly.
	#
	# param   object  A log writer class with, at the very least, a single
	#                 method named "add" which should accept the log-level and
	#                 message as the first and second arguments.
	# return  object  A reference to this class instance.
	attach: (instance) ->
		# Attach the passed class instance to the universal channel
		@addObserver "*", (level, message) ->
			# Attempt to invoke the "add" method on the log-writer class,
			# passing in the log-level and message
			instance.add level, message
		# Return a reference to this class instance
		return @

# Create one instance of the Log class, overwriting the class definition in the
# process
Log = new Log

# Expose this single instance of the Log class to the outside world
Meta.expose "Log", Log
