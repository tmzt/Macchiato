# This file defines the TestDelayedTask test suite, and queues it for
# execution.
class TestDelayedTask extends Tests

    # Asserts that the passed value matches what was expected and then
    # completes the task.
    #
    # param  object  test  A reference to the Test object.
    testSimpleDelayedTask: (test) ->
        # Define a new DelayedTask with a timeout of 1/4th of a second
        task = new DelayedTask (value) ->
            # Assert that the passed value is 70
            test.assertEquals 70, value, "the passed value is 70"
            # Complete the test
            test.complete()
        , 250
        # Start the DelayedTask, passing in 70 as the value
        task.run 70

# Add this test class to the tests collection
Macchiato.test "TestDelayedTask", TestDelayedTask
