# This file defines the HTTPServer class, and exposes it to the outside world.
class HTTPServer extends PublishSubscribe

    # Sets up the named topic channels that this class uses to issue
    # notifications.
    constructor: ->
        # Define the named topic channels
        super "request"

# Expose this class to the parent scope
Macchiato.expose "HTTPServer", HTTPServer
