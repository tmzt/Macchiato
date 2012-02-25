# This file defines the Observable class, and exposes it to the outside world.
#
# Observable is an implementation of the observer pattern, which is a simplified
# subset of the publish/subscribe or pub/sub pattern. If provided, Observable
# notification messages are sent to all of the observer functions in the
# observers collection.
class Observable extends MacchiatoClass

    # Creates the class variable to store the observers.
    constructor: ->
        # Define an integer variable which we can increment to create unique
        # identifiers for observers
        @identifierIndex = 0
        # Create a place for the observer functions to go
        @observers = {}
        # Indicates if the notify observers method has ever been invoked
        @notifyObserversInvoked = no

    # Adds a single Observer function to the list of observers.
    #
    # param   function  observer  A reference to the observer function to add.
    # return  int                 A unique identifier so that the observer can
    #                             be removed later.
    addObserver: (observer) ->
        # Increment the unique identifier integer
        @identifierIndex++
        # Add the observer function using its unique identifier as the key
        @observers[@identifierIndex] = observer
        # Return the unique identifier of the observer
        return @identifierIndex

    # Simple alias for addObserver.
    subscribe: (observer) ->
        # Return the result of the addObserver method, passing the same
        # argument value
        return @addObserver observer

    # Removes a specific observer function using the passed unique identifier.
    #
    # param   int     identifier  The unique identifier of the observer
    #                             to remove.
    # return  object              A reference to this class instance.
    removeObserver: (index) ->
        # Remove the observer
        delete @observers[index]
        # Return a reference to this class instance
        return @

    # Simple alias for removeObserver.
    unsubscribe: (index) ->
        # Return the result of the removeObserver method, passing the same
        # argument value
        return @removeObserver index

    # Issues an event to all of the observer functions in the observers
    # collection on this class instance.
    #
    # param   mixed   ...  optional  Any number of arguments that we want to
    #                                forward to all of the observer functions.
    # return  object                 A reference to this class instance.
    notifyObservers: ->
        # Set the notify observers issued flag
        @notifyObserversInvoked = yes
        # If we do not have any observer functions
        if @observers.length < 1
            # Do nothing but return a reference to this class instance
            return @
        # Create a new instance of the Arguments class to convert the arguments
        # object into an array
        observerArguments = Arguments.convertToArray arguments
        # Notify all of the observer functions in the observers collection
        observer.apply @, observerArguments for observer in @observers
        # Return a reference to this class instance
        return @

    # Simple alias for notifyObservers.
    publish: ->
        # Create a new instance of the Arguments class to convert the arguments
        # object into an array
        observerArguments = Arguments.convertToArray arguments
        # Return the result of the notifyObservers method, passing the same
        # argument values that were passed in
        return @callMethodArray "notifyObservers", observerArguments

    # Returns whether or not the notify observers method has ever been called
    # on this class instance.
    #
    # return  bool  If the notify observers method has ever been called, true.
    hasIssuedNotifications: ->
        # Return the value of the notify observers invoked flag
        return @notifyObserversInvoked

# Expose this class to the parent scope
Macchiato.expose "Observable", Observable
