# Include a snapshot of the Macchiato library
macchiato = require "./Snapshots/Macchiato-0.0.8.js"

# Define the project settings
projectSettings =
    name: "Macchiato"
    url: "http://github.com/sheatrevor/Macchiato"
    source: "CoffeeScript"
    destination: "Compiled"

# Define a class to help manage the project
class CoffeeScriptProject extends PublishSubscribe

    # Defines the named topic channels this class is able to publish
    # notifications on, and then sets up the passed configuration settings
    # on this class instance.
    #
    # param  object  A set of key/value pairs that correspond to instance
    #                variables with the same names as the keys.
    construct: (settings) ->
        # Define 

# Define a new instance of the CoffeeScriptProject class, passing in the
# project settings object
project = new CoffeeScriptProject projectSettings

# Find every file in the project
fs.readdir project.source, (err, files) ->
    # Write the names
    console.log files

# Define the task that builds everything
task "build", "Builds everything in the CoffeeScript directory.", ->
    # Stuff
