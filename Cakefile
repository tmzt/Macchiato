# Include a snapshot of the Macchiato library
{Macchiato: {PublishSubscribe, Tasks}} = require "./Snapshots/Macchiato-0.0.8.js"

# Define the project options
options =
    name: "Macchiato"
    url: "http://github.com/sheatrevor/Macchiato"
    source: "CoffeeScript"
    destination: "Compiled"

# Represents a single CoffeeScript source code file.
class CoffeeScriptSourceFile extends PublishSubscribe

    # Defines the named topic channels this class is able to publish
    # notifications on, and sts up the passed configuration settings
    # on this class instance.
    #
    # param  string  filename  The source code filename managed by this class.
    constructor: (@filename) ->
        # Define the named topic channels this class can publish
        super "complete", "exception"
        # Holds the file data
        @data = null
        # Holds a list of class names defined in this file
        @classes = []
        # Holds a list of class name dependencies required by this file
        @dependencies = []

    # Attempts to search for class definitions in the file.
    #
    # return  object  A reference to this class instance so we can do
    #                 method chaining.
    search: ->
        # Execute the following tasks in order
        Tasks.runTasks [
            @taskLoad
            @taskRemoveComments
            @taskFindClasses
            @taskComplete
        ]
        # Return a reference to this class instance
        return @

    # Attempts to load the configured filename.
    #
    # param   object  A reference to the tasks object.
    # return  null
    taskLoad: (tasks) =>
        # Grab a reference to the node file system object
        fs = require "fs"
        # Attempt to load the file content
        fs.readFile @filename, "utf8", (err, data) =>
            # Throw the error if one happened
            throw err if err
            # Place the loaded file data into the data instance variable
            @data = data
            # Move on to the next task
            tasks.next()

    # Attempts to remove code comments from the loaded file data.
    #
    # param   object  A reference to the tasks object.
    # return  null
    taskRemoveComments: (tasks) =>
        # Split the file data into individual lines of code
        lines = @data.split "\n"
        # Loop over each of the code lines
        for line, index in lines
            # Attempt to find the starting position of a code comment
            commentIndex = line.indexOf "#"
            # If this line does not appear to have a code comment in it, move
            # on to the next line
            continue if commentIndex is -1
            # Remove the code comment from this line
            cleanLine = line.substr 0, commentIndex
            # If the line is null
            if cleanLine is null
                # Just write an empty string for this line
                lines[index] = ""
            else
                # Replace the current line of code with the clean line
                lines[index] = cleanLine
        # Re-join the lines together
        @data = lines.join "\n"
        # Move on to the next task
        tasks.next()

    # Attempt to find all of the class declarations in the loaded file.
    #
    # param   object  A reference to the tasks object.
    # return  null
    taskFindClasses: (tasks) =>
        # Attempt to find things that look like class definitions in the
        # file data
        matches = /class +([A-Za-z0-9_]*)/g.exec @data
        # If we have a class name match, add it to the classes array
        @classes.push matches[1] if matches[1]?
        # Move on to the next task
        tasks.next()

    # Completes the search and issues a notification.
    #
    # param   object  A reference to the tasks object.
    # return  null
    taskComplete: (tasks) =>
        # Issue a notification on the "complete" channel
        @notifyObservers "complete"

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
                    # Throw the error if one happened
                    throw err if err
                    # Forward the array of items to the next task
                    control.next items
            (control, items) =>
                # If we have no more items to process, move on to the
                # next task
                return control.next() if items.length is 0
                # Remove the top item from the list of items in this directory
                item = @directory + '/' + items.shift()
                # Attempt to get the stats about this item
                fs.stat item, (err, stats) =>
                    # Throw the error if one happened
                    throw err if err
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
    #
    # return  object  A reference to this class instance so we can do
    #                 method chaining.
    build: ->
        # Execute the following tasks in order
        Tasks.runTasks [
            @taskScan
            @taskFindClasses
            @taskComplete
        ]
        # Return a reference to this class instance
        return @

    # Starts the scan of the project directory.
    #
    # param   object  A reference to the tasks object.
    # return  null
    taskScan: (tasks) =>
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
                @files.push new CoffeeScriptSourceFile file
            # Move on to the next task
            tasks.next()
        # Start a recursive search
        directory.search yes

    # Attempts to find all of the classes definitions in each of the project
    # source code files.
    #
    # param   object  A reference to the tasks object.
    # param   int     The current index in the files array.
    # return  null
    taskFindClasses: (tasks, index = 0) =>
        # Move on to the next task if we have reached the last file
        tasks.next() if index is @files.length
        # Grab a reference to the current file
        file = @files[index]
        # Add an observer to listen for the "complete" notification
        file.addObserver "complete", ->
            # Move on to the next file
            tasks.run index + 1
        # Search the file for class definitions
        file.search()

    taskComplete: ->
        console.log "hi"

# Define a new instance of the CoffeeScriptProject class, passing in the
# project options object that was defined at the top of this file
project = new CoffeeScriptProject options

# Define the task that builds everything
task "build", "Builds everything in the CoffeeScript directory.", ->
    # Start the build process
    project.build()

