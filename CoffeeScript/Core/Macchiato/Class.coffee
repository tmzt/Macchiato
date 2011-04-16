# This file defines the MacchiatoClass class, and exposes it to the outside
# world.
#
# MacchiatoClass has simple utility functions that make working with classes
# easier.
class MacchiatoClass

	# Runs a method on this class instance
	executeMethod: ->
		@instance[@methodName].apply @instance, @argumentsArray

# Expose this class to the parent scope
Meta.expose "MethodCall", MethodCall
