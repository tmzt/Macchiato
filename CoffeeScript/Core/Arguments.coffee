# This file defines the Arguments class, and exposes it to the outside world.
#
# The Arguments class exposes utility methods that make working with the
# special JavaScript arguments object easier. 
class Arguments

	# Accepts the a reference to the arguments object, converts it to an array, 
	# and stores it on this class instance for later use.
	#
	# param  object  argumentsObject  A JavaScript arguments object.
	constructor: (argumentsObject) ->
		# Convert the arguments object to an array and store it on this class instance
		@argumentsArray = Array.prototype.slice.call arguments, 0

	# Returns a reference to the arguments array.
	#
	# return  array  The arguments array.
	toArray: ->
		# Return a reference to the arguments array
		return @argumentsArray

# Expose this class to the parent scope
Meta.expose "Arguments", Arguments
