# Grab the node File System and Child Process libraries
fs = require "fs"
{exec} = require "child_process"

# Shortcuts to common node.js functions
echo = console.log
exit = process.exit

# Define the different packages and their dependencies
files =
	"All":
		"command": "build"
		"description": "Builds the complete library, excluding unit tests."
		"dependencies": ["Core"]
	"All-Minimized":
		"minimize": true
		"command": "build-minimized"
		"description": "Does the same thing as build, then minimizes the finished library file."
		"dependencies": ["All"]
	"Core":
		"command": "build-core"
		"description": "Builds only the core components of the library."
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
			"Synchronizable.coffee"
		]
	"Testing":
		"private": true
		"dependencies": ["Core"]
		"files": [
			"Meta.coffee"
			"Assertion.coffee"
			"Assertion/Success.coffee"
			"Assertion/Failure.coffee"
			"Test.coffee"
			"Tests.coffee"
		]
	"Tests":
		"run": true
		"command": "test"
		"description": "Includes and runs all of the unit tests."
		"dependencies": ["Testing"]
		"files": [
			"Core/Observable.coffee"
			"Core/Publish/Subscribe.coffee"
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

# Unlinks the file from the disk
erase = (filename) ->
	# We dont care if the unlink works or not
	try
		# Unlink the file
		fs.unlinkSync filename

# Grab the library name, version, and tagline
libraryName = trim read "NAME"
libraryVersion = trim read "VERSION"
libraryTagline = trim read "TAGLINE"

# Display the name, version, and tagline on screen
echo "#{libraryName} #{libraryVersion} - #{libraryTagline}"

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

# Generates an array of files to concatenate based on the rules defined in the
# files object
getFiles = (packageName) ->
	# Define the file list array we will be returning back
	fileList = []
	# Grab a shortcut variable to the current package
	package = files[packageName]
	# If a dependencies array is defined on this package
	if package.dependencies?
		# Loop over each of the dependencies
		for dependency in package.dependencies
			# Grab the files from the current dependency
			dependencyFiles = getFiles dependency
			# Add the files from the other packages to this file list
			fileList = fileList.concat dependencyFiles
	# If a files array is defined on this package
	if package.files?
		# Loop over the files in this collection
		for file in package.files
			# Add this file with the package name as the parent directory
			fileList.push "#{packageName}/#{file}"
	# Return the file list
	return fileList

# Builds everything for a specific package
build = (packageName) ->
	# Grab a shortcut variable to the current package
	package = files[packageName]
	# Grab the file list for this package
	fileList = getFiles packageName
	# Create a place to store all of the file data
	data = []
	# Loop over each of the files in the file list and push the contents of the
	# file into the data array
	data.push read "CoffeeScript/#{file}" for file in fileList
	# Concatenate all of the file data together with two newlines in between
	# for readability
	data = data.join "\n\n"
	# Write out a temporary CoffeeScript file which contains all of the data
	write "#{libraryName}.coffee", data
	# Determine what the CoffeeScript compile command needs to be
	command = "coffee -pc #{libraryName}.coffee > JavaScript/#{libraryName}.js"
	# Execute the CoffeeScript compiler on the temporary file
	exec command, (err, stdout, stderr) ->
		# Handle the error if we have one
		handleError err if err
		# Erase the temporary CoffeeScript file
		erase "#{libraryName}.coffee"
		# If we should run the compiled JavaScript file
		if package.run? and package.run
			# Run it under Node.js
			exec "node JavaScript/#{libraryName}.js", (err, stdout, stderr) ->
				# Display the output without whitespace
				echo trim stdout
		# If we should attempt to minimize the compiled JavaScript file
		if package.minimize? and package.minimize
			# Determine the command to minimize the JavaScript file
			command = "cat JavaScript/#{libraryName}.js | jsmin > JavaScript/#{libraryName}.min.js"
			# Attempt to use jsmin to minimize the JavaScript
			exec command, (err, stdout, stderr) ->
				# Display the output without whitespace
				echo trim stdout

# Loop over the files object and define the tasks this Cakefile exposes
for name, rules of files
	# Move on to the next package definition if this package is supposed to be
	# private
	continue if rules.private? and rules.private
	# Define the task to run these rules
	task rules.command, rules.description, ((packageName) ->
		# Return a function that attempts to build this package
		return -> build packageName
	)(name)

# Define the task that resets everything
task "clean", "Removes everything that build creates", ->
	# Erase all JavaScript files in the JavaScript directory
	erase "JavaScript/#{libraryName}.js"
	erase "JavaScript/#{libraryName}.min.js"
