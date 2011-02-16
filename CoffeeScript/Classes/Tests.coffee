# This file defines the Tests class, and exposes it to the outside world.
#
# This class is not intended to be instantiated directly. Instead, child
# classes should be created that have collections of unit test methods.
#
# A method created on the child class that is intended to be a test should be
# prefixed with "test". For example "test1Plus1Equals2" would be considered
# a unit test method.
#
# Other methods that are not tests can also be added and called. Also, complex
# inheritance schemes can be used to ease the creation of the application
# state for a particular unit test.
#
# Tests are intended to be fully asynchronous, and self-contained. When a test
# function is called by [Tests].run(), the test function is passed a single
# argument. This argument will be an instance of the Test class, and this
# instance is used to track the state of the current test that is running.
#
# From within the test function, [Test].assert() is used to make the individual
# assertions. After all of the tests have finished running, use
# [Test].complete() to indicate that there is no further processing to be done
# as part of that test.
#
# Because of the asynchronous way that the tests are run, the developer must
# assume that each test method on the child class may be run in a completely
# random order. Because of this, creating any reliance on external state during
# any test is not recommended. Avoid class instance variables at all costs!
class Tests

	# Runs all of the test methods defined on this class instance
	run: ->
		# Loop over all of the members of this class, searching for test
		# methods
		for own name, method of @
			# Move on if the name does not match what is expected
			continue if not name.match /^test[a-z0-9_]*$/i
			# Move on if the data type is not a function
			continue if typeof method isnt "function"
			# Add the test results

# Expose this class to the parent scope
Meta.expose "Tests", Tests