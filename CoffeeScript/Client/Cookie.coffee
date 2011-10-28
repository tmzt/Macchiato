# This file defines the Cookie class, and exposes it to the outside world.
#
# Each instance of the Cookie class is designed to manage a single cookie
# variable using the name passed into the constructor. If a cookie exists for
# the passed name, it will automatically be loaded.
class HTTPCookie extends MacchiatoClass

    # Calls the parent constructor, and then attempts to load the
    # cookie value.
    #
    # param  string  name  The name of the cookie to retrieve/create.
    constructor: (@name) ->
        # Invoke the parent constructor
        super()
        # Attempt to load the cookie value
        @load()

    # Attempts to load the cookie value using the cookie name that was passed
    # into the constructor.
    #
    # return  object  A reference to this class instance.
    load: ->
        # Attempt to grab the cookie value
        value = document.cookie.match('(?:^|;)\\s*' + @escapeRegExp(@name) +
            '=([^;]*)')
        # Return a reference to this class instance
        return @

    # Saves the cookie using the provided settings.
    #
    # return  object  A reference to this class instance.
    save: ->
        # Return a reference to this class instance
        return @


    # Escapes the passed string, making it safe for inclusion in the body of
    # a regular expression.
    #
    # param   string  The string value to escape.
    # return  string  The escaped version of the passed value.
    escapeRegExp: (value) ->
        # Return the escaped version of the string
        return value.replace /[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&"

# Expose this class to the parent scope
Macchiato.expose "HTTPCookie", HTTPCookie
