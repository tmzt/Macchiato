# Include a snapshot of the Macchiato library
{Macchiato: {PublishSubscribe, Tasks}} = require "./Snapshots/Macchiato-0.0.8.js"

# Define the project options
options =
    name: "Macchiato"
    url: "http://github.com/sheatrevor/Macchiato"
    source: "CoffeeScript"
    destination: "Compiled"

# Represents a single CoffeeScript source code file.
class CoffeeScriptFile extends PublishSubscribe

    # Defines the named topic channels this class is able to publish
    # notifications on, and sts up the passed configuration settings
    # on this class instance.
    #
    # param  string  filename  The filename managed by this class.

# Abstraction for working with a single directory with CoffeeScript source
# code in it.
class CoffeeScriptDirectory extends PublishSubscribe

    # Stores the passed configuration option, adds the named topic channels
    # this class is able to publish notifications on, and adds some instance
    # variables for maintaining the search state and result data.
    #
    # param  string  directory  The directory to search for code in.
    constructor: (@directory) ->
        # Define the named topic channels this class can publish
        # notifications on
        super "complete", "exception"
        # Variable which tells us if we are currently searching the source
        # directory for CoffeeScript files
        @searching = no
        # Define an array to hold all of the source code file names in the
        # current directory
        @files = []

    # Attempts to scan the entire project tree looking for CoffeeScript source
    # code files.
    #
    # param   boolean  recursive  If we should search recursively or not.
    # return  null
    search: (recursive) ->
        # If we are already searching this directory, do nothing
        return null if @searching
        # Set the flag which indicates that we are currently searching
        # this directory
        @searching = yes
        # Grab a reference to the node file system object
        fs = require "fs"
        # Define a new instance of the Tasks class to manage the reading
        # of each of the entities in the directory sequentially
        tasks = new Tasks [
            (control) =>
                # Set the flag which indicates that we are currently searching
                # the directory
                @searching = yes
                # Find every file and directory under the current directory
                # represented by this class instance
                fs.readdir @directory, (err, items) ->
                    # Forward the array of items to the next task
                    control.next items
            (control, items) =>
                # If we have no more items to process, move on to the
                # next task
                return control.next() if items.length is 0
                # Remove the top item from the list of items in this directory
                item = @directory + '/' + items.shift()
                console.log item
                # Attempt to get the stats about this item
                fs.stat item, (err, stats) =>
                    # If this is a file
                    if stats.isFile()
                        # Notify any observers that we found a file
                        @files.push item
                        # Move on to the next item
                        control.run items
                    else if stats.isDirectory()
                        # If we are not doing a recursive search, move on to
                        # the next item
                        return control.run items if not recursive
                        # If this is a recursive search, create a new instance
                        # of this class and configure it with the current path
                        directory = new CoffeeScriptDirectory item
                        # Wait until we get a signal back that the directory
                        # search has been complete
                        directory.addObserver "complete", (files) =>
                            # Loop over each of the files
                            for file in directory.files
                                # Add this file
                                @files.push file
                            # Move on to the next item
                            control.run items
                        # Recursively search this child directory
                        directory.search yes
            (control) =>
                # Reset the flag which indicates we are currently searching
                @searching = no
                # Notify any observers that we are complete
                @notifyObservers "complete", @files
        ]
        # Execute the tasks
        tasks.run()

# Provides methods for working with CoffeeScript projects.
class CoffeeScriptProject extends PublishSubscribe

    # Defines the named topic channels this class is able to publish
    # notifications on, adds some instance variables, and then sets
    # up the passed configuration settings.
    #
    # param  object  options  A set of key/value pairs that correspond to
    #                         instance variables with the same names as the
    #                         keys. Accepted options are: name, url, source,
    #                         and destination.
    constructor: (options) ->
        # Initialize the class variables
        @name = null
        @url = null
        @source = null
        @destination = null
        @files = []
        # Loop over each of the options
        for name, value of options
            # Set the option value onto this class instance if it matches one
            # of the following names
            @[name] = value if name.match /^(name|url|source|destination)$/

    # Starts the build process.
    build: ->
        # Define a new instance of the CoffeeScriptDirectory class configured
        # to search for all of the CoffeeScript code files in this projects
        # source code directory
        directory = new CoffeeScriptDirectory @source
        # Add an observer to let us know when the search is complete
        directory.addObserver "complete", (files) =>
            # Loop over each of the returned files
            for file in files
                # Create a new instance of the CoffeeScriptFile class and add
                # it to the local files collection
                @files.push new CoffeeScriptFile file
        # Start a recursive search
        directory.search yes

# Define a new instance of the CoffeeScriptProject class, passing in the
# project options object that was defined at the top of this file
project = new CoffeeScriptProject options

# Define the task that builds everything
task "build", "Builds everything in the CoffeeScript directory.", ->
    # Start the build process
    project.build()

