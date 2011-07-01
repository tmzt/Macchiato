# This file defines the TestBase64Utilities test suite, and queues it for execution.
class TestBase64Utilities extends Tests

    # Attempts to Base64 encode a simple text string.
    #
    # param  object  test  A reference to the Test object.
    testEncode: (test) ->
        # Define a value to Base64 encode
        value = "Hello World!"
        # Attempt to Base64 encode this value
        base64Value = Base64Utilities.encode value
        # Confirm that the result is what we expect it to be
        test.assertEquals "SGVsbG8gV29ybGQh", base64Value, "the Base64 " +
            "encoded value was correct"
        # Mark this test as completed
        test.complete()

# Add this test class to the tests collection
Macchiato.test "TestBase64Utilities", TestBase64Utilities
