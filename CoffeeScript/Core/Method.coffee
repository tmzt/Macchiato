# This file defines the MethodCall class, and exposes it to the outside world.
#
# The MethodCall class makes it easier to bind and forward arguments to class
# methods.
class MethodCall

	# Takes the object instance, the method name, and the arguments array, and
	# stores them as class variables.
	#
	# param  object  instance        The class instance to invoke the method on.
	# param  string  methodName      The name of the method to invoke.
	# param  array   argumentsArray  The arguments to pass in to the method.
	constructor: (instance, methodName, argumentsArray) ->
		# Store the values that were passed in
		@instance = instance
		@methodName = methodName
		@argumentsArray = argumentsArray

	# Runs the method.
	run: ->
		@instance[@methodName].apply @instance, @argumentsArray

# Expose this class to the parent scope
Meta.expose "MethodCall", MethodCall
