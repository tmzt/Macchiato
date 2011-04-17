# This file defines the MacchiatoClass class, and exposes it to the outside
# world.
#
# MacchiatoClass has simple utility functions that make working with classes
# easier.
class MacchiatoClass

	# Runs the named method on the scope of this class instance.
	#
	# param   string  name            The name of the method to invoke.
	# param   array   argumentsArray  The arguments to forward to the named
	#                                 method.
	# return  mixed                   The result of the method call.
	callMethod: (name, argumentsArray = []) ->
		# Run the named method forwarding the arguments that were passed in
		@[name].apply @, argumentsArray

# Expose this class to the parent scope
Meta.expose "MacchiatoClass", MacchiatoClass
