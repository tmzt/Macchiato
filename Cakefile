# Grab the node File System and Child Process libraries
fs = require "fs"
{exec} = require "child_process"

# Shortcuts to common node.js functions
echo = console.log
exit = process.exit

# Define the different packages and their dependencies
files =
	"Core":
		"files": [
			"Meta.coffee"
			"Observable.coffee"
			"Publish/Subscribe.coffee"
			"Log.coffee"
			"HTML/Element.coffee"
			"Task.coffee"
			"Delayed/Task.coffee"
			"Debounced/Task.coffee"
			"Tasks.coffee"
			"Assertion.coffee"
			"Assertion/Success.coffee"
			"Assertion/Failure.coffee"
			"Synchronizable.coffee"
			"Test.coffee"
			"Tests.coffee"
		]

# Define the different packages that make up the unit tests and their
# dependencies
tests =
	"Core":
		"dependencies": [
			"Core"
		]
		"files": [
			"Test/Observable.coffee"
			"Test/Publish/Subscribe.coffee"
		]

# Trims any whitespace off of the ends of the passed string value
trim = (value) ->
	# Return the trimmed value of the string
	value.replace /^\s+|\s+$/g, ""

# Returns the contents of the specified filename
read = (filename) ->
	# Read the file and return its contents
	fs.readFileSync filename, "ascii"

# Writes the passed data to the specified filename
write = (filename, data) ->
	# Write the contents of data to the specified filename
	fs.writeFileSync filename, data, "ascii"

# Helper function to standardize the way we handle unexpected errors
handleError = (err) ->
	# If the error has a message member, we display it
	if err.message?
		# Display the message
		echo err.message
		# Exit with a failure
		exit 1
	# Otherwise we just throw
	throw err

# Grab the library name, version, and tagline
libraryName = trim read "NAME"
libraryVersion = trim read "VERSION"
libraryTagline = trim read "TAGLINE"

# Display the name, version, and tagline on screen
echo "#{libraryName} #{libraryVersion} - #{libraryTagline}"

# Define the main build task
task "build", "Build the complete #{libraryName} library", ->

# Define the main build task
task "build-core", "Build only the core components", ->

# Define the task that runs all of the unit tests
task "test", "Runs all of the unit tests", ->

# Define the task that resets everything
task "clean", "Removes everything that build creates", ->
	
