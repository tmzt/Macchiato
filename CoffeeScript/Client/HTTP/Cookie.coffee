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
    constructor: (@cookieName, options = {}) ->
        # Invoke the parent constructor
        super()
        # Initialize the class variables
        @cookieValue = null
        @cookiePath = '/'
        @cookieDomain = no
        @cookieExpiration = no
        @cookieSecure = no
        @encodeCookie = yes
        # Loop over each of the options
        for name, value of options
            # Invoke the class method by the same name, if one exists, passing
            # in the option value
            @[name](value) if @[name]?
        # Attempt to load the cookie value
        @load()

    # Attempts to load the cookie value using the cookie name that was passed
    # into the constructor.
    #
    # return  object  A reference to this class instance.
    load: ->
        # Clear the current value
        # Attempt to grab the cookie value
        value = document.cookie.match '(?:^|;)\\s*' +
            HTTPCookie.escapeRegExp(@cookieName) + '=([^;]*)'
        # TODO: Remove this console debug line
        console.debug 'Cookie value: ', value
        # Assign the value class variable to the first matched result
        @cookieValue = decodeURIComponent value[1] if value?
        # Return a reference to this class instance
        return @

    # Saves the cookie using the provided settings.
    #
    # return  object  A reference to this class instance.
    save: ->
        # Begin assembling the cookie
        cookie = @cookieName + '='
        # Grab a shortcut reference to the cookie value
        value = @cookieValue
        # URI-encode the value if the encode option is set
        value = encodeURIComponent value if @encodeCookie
        # Add the value to the cookie
        cookie += value
        # Add the domain information, if we have one
        cookie += '; domain=' + @cookieDomain if @cookieDomain
        # Add the path information, if we have one
        cookie += '; path=' + @cookiePath if @cookiePath
        # If we have an expiration time
        if @cookieExpiration
            # Define a new date class instance to help us generate the GMT
            # string required for HTTP cookies
            date = new Date()
            # Set the time to be the current time plus a passed number of days
            date.setTime date.getTime() + @cookieExpiration * 24 * 60 * 60 * 1000
            # Set the cookie expiration
            cookie += '; expires=' + date.toGMTString()
        # If the cookie needs to be secure
        cookie += '; secure' if @cookieSecure
        # Write the cookie
        document.cookie = cookie
        # Return a reference to this class instance
        return @

    # Escapes the passed string, making it safe for inclusion in the body of
    # a regular expression.
    #
    # param   string  The string value to escape.
    # return  string  The escaped version of the passed value.
    @escapeRegExp: (value) ->
        # Return the escaped version of the string
        return value.replace /[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&"

# Expose this class to the parent scope
Macchiato.expose "HTTPCookie", HTTPCookie
