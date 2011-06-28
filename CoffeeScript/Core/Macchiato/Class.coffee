# This file defines the MacchiatoClass class, and exposes it to the outside
# world.
#
# MacchiatoClass holds simple utility functions that are intended to make
# working with classes easier.
class MacchiatoClass

    # Invokes the named method on the scope of this class instance, forwarding
    # the passed arguments array to the method.
    #
    # param   string  name            The name of the method to invoke.
    # param   array   argumentsArray  The arguments to forward to the named
    #                                 method.
    # return  mixed                   The result of the method call.
    callMethodArray: (name, argumentsArray = []) ->
        # Run the named method forwarding the arguments that were passed in
        return @[name].apply @, argumentsArray

# Expose this class to the parent scope
Macchiato.expose "MacchiatoClass", MacchiatoClass
