# This file defines the AssertionFailure class, which is not exposed.
class AssertionFailure extends Assertion

    # Accepts the description string and forwards it to the parent constructor.
    #
    # param  string  description  The description for this assertion.
    constructor: (description) ->
        # Call the parent constructor, passing in the description
        super description
