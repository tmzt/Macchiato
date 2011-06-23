# This file defines the SimpleDataSource class, and exposes it to the outside
# world.
class SimpleDataSource extends DataSource

    # Sets up the required class variables and named topic channels.
    #
    # param  mixed  The data to store on this class instance.
    constructor: (@data) ->
        # Invoke the parent constructor
        super()

    # Forwards a reference to the data stored on this class instance by the
    # constructor.
    #
    # param   object  A reference to a Tasks class instance.
    # return  object  A reference to this class instance.
    retrieve: (task) ->
        # Run the next task passing in null for the data argument
        task.next @data
        # Return a reference to this class instance
        return @

# Expose this class to the parent scope
Macchiato.expose "SimpleDataSource", SimpleDataSource
