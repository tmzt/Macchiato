# This file defines the base DataSource class, and exposes it to the outside
# world.
#
# Any conceptual data source, including data sources that require asynchronous
# remote requests, can be created by extending this class and replacing the
# "retrieve" function.
class DataSource extends PublishSubscribe

    # Sets up the named topic channels this class can publish.
    constructor: ->
        # Set up the named topic channels
        super "loading", "complete", "exception"

    # Placeholder function for child classes to replace.
    #
    # param   function  The callback function to run once we successfully
    #                   retrieve the data we are looking for.
    # return  void
    retrieve: (respond) ->
        # Respond with null for data
        respond null

    # Kicks off a set of tasks to load the data - potentially from an
    # asynchronous source. 
    #
    # return  object  A reference to this class instance.
    load: ->
        # Define the data-retrieval multi-stage task
        dataRetrievalTasks = new Tasks [
            # The first step
            (taskControl) =>
                # Issue the "loading" notification
                @notifyObservers "loading", @
                # Move on to the next step
                taskControl.next()
            # The second step
            (taskControl) =>
                # Attempt to load the data using the local "retrieve" function,
                # passing in the task control object. We trust that "retrieve"
                # will call the "next" function on the passed task control
                # object after it has finished retrieving the data, or will
                # invoke the "exception" named topic channel on any kind of
                # failure
                @retrieve taskControl.next
            # The third step
            (taskControl, data) =>
                # Issue the "complete" notification, passing in the data
                @notifyObservers "complete", @, data
        ]
        # Run the first data retrieval task
        dataRetrievalTasks.run()
        # Return a reference to this class instance
        return @

# Expose this class to the parent scope
Macchiato.expose "DataSource", DataSource
