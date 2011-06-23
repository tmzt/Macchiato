# This file defines the Condition class, and exposes it to the outside world.
#
# Any number of different condition evaluators can be created by extending this
# class and replacing the "evaluate" function.
class Condition extends PublishSubscribe

	# Sets up the named topic channels and grabs a reference to the passed data
	# source object.
	#
	# param  object  An instance of one of the rule data source classes.
	constructor: (@dataSource) ->
		# Set up the named topic channels that this class can publish
		super "success", "failure"
		# Set up an observer for the "complete" topic channel on the passed
		# data source class instance
		@dataSource.addObserver "complete", (unused, data) =>
			# If the evaluate function returns boolean true for the passed data
			if @evaluate data
				# Issue a notification on the "success" topic channel
				@notifyObservers "success", @
			# Otherwise
			else
				# Issue a notification on the "failure" topic channel
				@notifyObservers "failure", @

	# Placeholder function for child classes to replace.
	#
	# param   mixed  The data loaded from the data source.
	# return  bool   If the evaluation succeeds or not.
	evaluate: (data) ->
		# This placeholder function always returns true
		return true
 
	# Attempts to load and evaluate the data retrieved from the data source.
	#
	# return  object  A reference to this class instance.
	execute: ->
		# Attempt to load the data from the data source
		@dataSource.load()
		# Return a reference to this class instance
		return @

# Expose this class to the parent scope
Macchiato.expose "Condition", Condition
