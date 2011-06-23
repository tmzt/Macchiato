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
    # param   object  A reference to a Tasks class instance.
    # return  object  A reference to this class instance.
    retrieve: (task) ->
        # Run the next task passing in null for the data argument
        task.next null
        # Return a reference to this class instance
        return @

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
                # Attempt to load the data using the local loadData function,
                # passing in the task control object. We trust that "loadData"
                # will call the "next" function on the passed task control
                # object after it has finished retrieving the data
                @retrieve taskControl
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
