# This file defines the TestRules test suite, and queues it for execution.
class TestRules extends Tests

	# Sets up a series of rules and confirms that they evaluate as expected.
	#
	# param  object  test  A reference to the Test object.
	testMultistageTaskProcessing: (test) ->
		# Set up an instance of the rules class to use for testing
		rule = new Rule "regex", /[0-9]*/g, ->
			
		# Mark this test as complete
		test.complete()

# Add this test class to the tests collection
Meta.test "TestRules", TestRules
