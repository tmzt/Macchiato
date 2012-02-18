# This file defines the Cookie class, and exposes it to the outside world.
#
# Each instance of the Cookie class is designed to manage a single cookie
# variable using the name passed into the constructor. If a cookie exists for
# the passed name, it will automatically be loaded.
class HTTPCookie extends MacchiatoClass

    # Calls the parent constructor, and then attempts to load the
    # cookie data.
    #
    # param  string  name  The name of the cookie to retrieve/create.
    constructor: (@name = 'default', options = {}) ->
        # Invoke the parent constructor
        super()
        # Initialize the class variables
        @data = null
        @path = '/'
        @domain = no
        @expiration = no
        @secure = no
        @encode = yes
        # Loop over each of the options
        for name, value of options
            # Set the option value onto this class instance if it matches one
            # of the following names
            @[name] = value if name.match /^(data|path|domain|expiration|secure|encode)$/
        # Attempt to load the cookie value
        @load()

    # Attempts to load the cookie value using the cookie name that was passed
    # into the constructor.
    #
    # return  object  A reference to this class instance.
    load: ->
        # Attempt to grab the cookie data
        data = document.cookie.match '(?:^|;)\\s*' +
            HTTPCookie.escapeRegExp(@name) + '=([^;]*)'
        # Assign the value class variable to the first matched result
        @data = decodeURIComponent data[1] if data?
        # Return a reference to this class instance
        return @

    # Returns the current cookie data, and assigns a new value if replacement
    # data is provided in the first parameter.
    #
    # param   mixed  data  Optional. The string data to assign.
    # return  mixed        A string of data, if available, null if nothing
    #                      has been assigned to the cookie yet.
    value: (data = null) ->
        # If replacement cookie data was passed in, assign it
        @data = data if typeof data is 'string'
        # Return the cookie value
        return @data

    # Saves the cookie using the provided settings.
    #
    # return  object  A reference to this class instance.
    save: ->
        # Begin assembling the cookie
        cookie = @name + '='
        # Grab a shortcut reference to the cookie data
        data = @data
        # URI-encode the data if the encode option is set
        data = encodeURIComponent data if @encode
        # Add the value to the cookie
        cookie += data
        # Add the domain information, if we have one
        cookie += '; domain=' + @domain if @domain
        # Add the path information, if we have one
        cookie += '; path=' + @path if @path
        # If we have an expiration time
        if @expiration
            # Define a new date class instance to help us generate the GMT
            # string required for HTTP cookies
            date = new Date()
            # Set the time to be the current time plus a passed number of days
            date.setTime date.getTime() + @expiration * 24 * 60 * 60 * 1000
            # Set the cookie expiration
            cookie += '; expires=' + date.toGMTString()
        # If the cookie needs to be secure
        cookie += '; secure' if @secure
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
