# This file defines the SimpleDataSource class, and exposes it to the outside
# world.
#
# Instances of SimpleDataSource provide a DataSource-style external interface
# for accessing local data, which is useful for setting up support for
# asynchronous communication even if the majority of use cases allow for
# synchronous local data retrieval.
class SimpleDataSource extends DataSource

    # Stores the passed data onto this class instance and then invokes the
    # parent constructor.
    #
    # param  mixed  data  The data to respond with.
    constructor: (@data) ->
        # Invoke the parent constructor
        super()

    # Forwards a reference to the data stored on this class instance by the
    # constructor.
    #
    # param   function  respond  The callback function to run once we
    #                            successfully retrieve the data we are looking
    #                            for.
    # return  void
    retrieve: (respond) ->
        # Respond with the data that was passed in
        respond @data

# Expose this class to the parent scope
Macchiato.expose "SimpleDataSource", SimpleDataSource
