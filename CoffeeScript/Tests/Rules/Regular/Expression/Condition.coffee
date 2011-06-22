# This file defines the TestRegularExpressionCondition test suite, and queues
# it for execution.
class TestRegularExpressionCondition extends Tests

	# Sets up an instance of the Rule class configured to evaluate a regular
	# expression.
	#
	# param  object  test  A reference to the Test object.
	testRegularExpressionEvaluation: (test) ->
		# Setup a simple data source to use for testing
		dataSource = new SimpleDataSource "Hello World!"
		# Set up the test object instance
		condition = new RegularExpressionCondition /^Hello/g, dataSource
		# Add an observer to the universal topic channel
		condition.addObserver "*", (channel) ->
			# Assert that the passed channel name is "success"
			test.assertEquals channel, "success", "channel is 'success'"
			# Mark this test as complete
			test.complete()
		# Execute the condition
		condition.execute()

# Add this test class to the tests collection
Meta.test "TestRegularExpressionCondition", TestRegularExpressionCondition
