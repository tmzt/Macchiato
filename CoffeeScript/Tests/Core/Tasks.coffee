# This file defines the TestTasks test suite, and queues it for execution.
class TestTasks extends Tests

	# Add a single observer to the Observable class instance, and sends it one
	# notification.
	#
	# param  object  test  A reference to the Test object.
	testMultistageTaskProcessing: (test) ->
		# Create a new instance of Tasks with 3 separate subtasks
		tasks = new Tasks [
			# Define the first task
			(taskControl) ->
				# Kick off the next task, forwarding two arguments
				taskControl.next 90, "X"
			# Define the second task
			(taskControl, theNumber, theString) ->
				# Assert that the passed number is 90
				test.assertEqual "the number is 90", 90, theNumber
				# Assert that the passed string is the letter X
				test.assertEqual "the string is X", "X", theString
				# Create a simple DelayedTask to wait 1/4th of a second before
				# moving on to the next Tasks function
				simpleDelay = new DelayedTask ->
					# Move on to the next Tasks task, forwarding the passed
					# value string
					taskControl.next "Y"
				, 250
				# After a second, move on to the next task
				simpleDelay.run()
			# Define the third task
			(taskControl, differentString) ->
				# Assert that the passed string is the letter X
				test.assertEqual "the string is Y", "Y", differentString
				# Mark this test as complete
				test.complete()
		]
		# Start the tasks
		tasks.run()

# Add this test class to the tests collection
Meta.test "TestTasks", TestTasks
