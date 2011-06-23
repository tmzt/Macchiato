Macchiato.test = (name, reference) ->
	# Create a new instance of the passed Tests class reference, passing it
	# the name of the test suite it represents
	instance = new reference name
	# Execute the tests
	instance.run()
	# Return a reference to this class instance
	return @
