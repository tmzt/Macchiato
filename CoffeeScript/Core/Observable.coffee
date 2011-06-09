# This file defines the Observable class, and exposes it to the outside world.
#
# Observable is an implementation of the observer pattern, which is a simplified
# subset of the publish/subscribe or pub/sub pattern. If provided, Observable
# notification messages are sent to all of the observer functions in the
# observers collection.
class Observable extends MacchiatoClass

	# Creates the class variable to store the observers.
	constructor: ->
		# Create a place for the observer functions to go
		@observers = []

	# Adds a single Observer function to the list of observers.
	#
	# param   function  observer  A reference to the observer function to add.
	# return  object              A reference to this class instance.
	addObserver: (observer) ->
		# Add the observer function to the universal channel
		@observers.push observer
		# Return a reference to this class instance
		return @

	# Simple alias for addObserver.
	subscribe: (observer) ->
		# Return the result of the addObserver method, passing the same
		# argument value
		return @addObserver observer

	# Issues an event to all of the observer functions in the observers
	# collection on this class instance.
	#
	# param   mixed   ...  optional  Any number of arguments that we want to
	#                                forward to all of the observer functions.
	# return  object                 A reference to this class instance.
	notifyObservers: ->
		# If we do not have any observer functions
		if @observers.length < 1
			# Do nothing but return a reference to this class instance
			return @
		# Create a new instance of the Arguments class to convert the arguments
		# object into an array
		observerArguments = (new Arguments(arguments)).toArray()
		# Notify all of the observer functions in the observers collection
		observer.apply @, observerArguments for observer in @observers
		# Return a reference to this class instance
		return @

	# Simple alias for notifyObservers.
	publish: ->
		# Create a new instance of the Arguments class to convert the arguments
		# object into an array
		observerArguments = (new Arguments(arguments)).toArray()
		# Return the result of the notifyObservers method, passing the same
		# argument values that were passed in
		return @callMethodArray "notifyObservers", observerArguments

# Expose this class to the parent scope
Meta.expose "Observable", Observable
