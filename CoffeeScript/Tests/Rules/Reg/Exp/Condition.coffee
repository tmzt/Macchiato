# This file defines the TestRule test suite, and queues it for execution.
class TestRule extends Tests

	# Sets up an instance of the Rule class configured to evaluate a regular
	# expression.
	#
	# param  object  test  A reference to the Test object.
	testRegularExpression: (test) ->
		# Set up an instance of the rules class to use for testing
		rule = new Rule "regex", /[0-9]*/g, ->
			
		# Mark this test as complete
		test.complete()

# Add this test class to the tests collection
Meta.test "TestRule", TestRule
