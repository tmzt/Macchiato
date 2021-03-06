# This file defines the PublishSubscribe class, and exposes it to the outside
# world.
#
# PublishSubscribe is an implementation of the publish/subscribe or pub/sub
# pattern. This implementation supports topic-based "message filtering" by
# creating named topic channels that are each separate instances of Observable.
#
# This implementation also has a single universal topic channel which is named
# '*'. It behaves as a catch-all channel. Subscribers to the universal channel
# are notified for all notifications to all of the other named topic queues.
#
# Subscribers are expected to subscribe to either the named topic channel, or
# the universal channel. Subscribers cannot subscribe to both.
class PublishSubscribe extends MacchiatoClass

    # Creates the universal observable channel and initializes the class
    # variable for named topic channels. If an array of topic channels is
    # passed in, these channels are added.
    #
    # param   string  ...  optional  Any number of arguments that we want to
    #                                create named topic channels for.
    constructor: ->
        # Create an instance of Observable for the universal channel
        @universalChannel = new Observable()
        # Create a place for any named topic channels to go
        @namedChannels = {}
        # Grab any arguments that may have been passed in and convert them to a
        # simple array of argument values which are named topic channels
        names = Arguments.convertToArray arguments
        # If any named topic channels were passed in, create them
        @callMethodArray "addChannels", names if names.length > 0

    # Create a way to add a named topic channel where event messages can be
    # published.
    #
    # param   string  name  The name of the new channel to create.
    # return  object        A reference to this class instance.
    addChannel: (name) ->
        # Create the new channel
        @namedChannels[name] = new Observable()
        # Return a reference to this class instance
        return @

    # Accepts any number of string arguments, and creates named topic channels
    # for each.
    #
    # param   string  ...  optional  Any number of arguments that we want to
    #                                create named topic channels for.
    # return  object                 A reference to this class instance.
    addChannels: ->
        # Grab any arguments that may have been passed in and convert them to a
        # simple array of argument values which are named topic channels
        names = Arguments.convertToArray arguments
        # If we have topic channel names to add, add them
        @addChannel name for name in names if names.length > 0
        # Return a reference to this class instance
        return @

    # Adds an Observer to either the universal channel or a named topic
    # channel.
    #
    # param   string    name      The name of the channel to add this observer
    #                             to.
    # param   function  observer  A reference to the observer function to add.
    # return  object              A reference to this class instance.
    addObserver: (name, observer) ->
        # If a channel name was passed in
        if name isnt "*"
            # Add the observer function to the named topic channel, if a named
            # topic channel was passed in and it exists
            @namedChannels[name]?.addObserver observer
            # Return a reference to this class instance
            return @
        # Add the observer function to the universal channel
        @universalChannel.addObserver observer
        # Return a reference to this class instance
        return @

    # Simple alias for addObserver.
    subscribe: (name, observer) ->
        # Return the result of the addObserver method, passing the same
        # argument values
        return @addObserver name, observer

    # Issues an event to all of the observers on both the unnamed universal
    # channel, and, if a named topic channel is provided, the named topic
    # channel as well.
    #
    # param   string  name            The named topic channel that we want to
    #                                 notify. If the name is "*", only the
    #                                 universal channel is issued the
    #                                 notification. Otherwise, both the named
    #                                 topic channel as well as the universal
    #                                 channel are notified.
    # param   mixed   ...   optional  Any arguments that we want to forward to
    #                                 all of the observer functions. Defaults
    #                                 to an empty array if nothing is passed
    #                                 in. Subscribers to the universal channel
    #                                 will also receive the name of the topic
    #                                 channel as the first argument to the
    #                                 observer function, followed by the rest
    #                                 of the arguments.
    # return  object                  A reference to this class instance.
    notifyObservers: (name) ->
        # Create a new instance of the Arguments class to convert the arguments
        # object into an array
        notificationArguments = Arguments.convertToArray arguments
        # If the channel name that was passed in is not for the universal
        # channel
        if name isnt "*" and @namedChannels[name]?
            # The arguments that we will forward to the named topic channel are
            # everything that was passed in after the name argument
            observerArguments = notificationArguments.slice 1
            # Notify the observers on the named topic channel, if the named
            # topic channel exists
            @namedChannels[name]?.callMethodArray "notifyObservers",
                observerArguments
        # Notify the observers on the universal channel no matter what
        @universalChannel.callMethodArray "notifyObservers",
            notificationArguments
        # Return a reference to this class instance
        return @

    # Simple alias for notifyObservers.
    publish: ->
        # Convert the JavaScript arguments object into a normal array
        notificationArguments = Arguments.convertToArray arguments
        # Return the result of the notifyObservers method, passing the same
        # arguments
        return @callMethodArray "notifyObservers", notificationArguments

    # Forwards all future notifications issued on a specific named topic
    # channel to an identically-named topic channel belonging to an external
    # PublishSubscribe class instance.
    #
    # param   string  name      The named topic channel to forward.
    # param   object  instance  An external PublishSubscribe class instance to
    #                           forward to.
    # return  object            A reference to this class instance.
    forwardNotifications: (name, instance) ->
        # Attach an observer function to the named topic channel
        @addObserver name, ->
            # Convert the JavaScript arguments object into a normal array
            notificationArguments = Arguments.convertToArray arguments
            # Add the topic channel name as the first argument
            notificationArguments.unshift name
            # Call the external notify observers method forwarding any
            # arguments that were passed in
            instance.callMethodArray "notifyObservers", notificationArguments
            

    # Returns whether or not the notify observers method has ever been called
    # on this class instance.
    #
    # param   string  name  optional  The named topic channel that we want to
    #                                 check. If the name is "*", we inspect
    #                                 each of the topic channels to see if any
    #                                 of them have ever issued notifications.
    #                                 Defaults to "*".
    # return  bool                    If the notify observers method has ever
    #                                 been called for the passed topic channel
    #                                 name.
    hasIssuedNotifications: (name = "*") ->
        # If the value passed for the name argument is anything other then the
        # universal topic channel "*"
        if name isnt "*"
            # Return the value of the has issued notifications method attached
            # to the specified topic channel
            return @namedChannels[name]?.hasIssuedNotifications()
        # Loop over each of the named channels
        for channel in @namedChannels
            # If this channel has not ever issued any notifications
            if not channel.hasIssuedNotifications()
                # Move on to the next channel
                continue
            # If we made it here, that means that the current channel has
            # issued notifications
            return true
        # If we made it all the way down here, that means we did not find a
        # named topic channel that had issued notifications
        return false

# Expose this class to the parent scope
Macchiato.expose "PublishSubscribe", PublishSubscribe
