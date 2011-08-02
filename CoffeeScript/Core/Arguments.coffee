# This file defines the Arguments class, and exposes it to the outside world.
#
# The Arguments class exposes utility methods that make working with the
# special JavaScript arguments object easier.
class Arguments extends MacchiatoClass

    # Class method to convert JavaScript arguments objects into normal arrays.
    #
    # param   object  argumentsObject  A JavaScript arguments object.
    # return  array                    The arguments object converted into a
    #                                  normal array. 
    @convertToArray: (argumentsObject) ->
        # Return the array version of the passed arguments object
        return Array.prototype.slice.call argumentsObject, 0

# Expose this class to the parent scope
Macchiato.expose "Arguments", Arguments
