# This file defines the RegularExpressionCondition class, and exposes it to the
# outside world.
class RegularExpressionCondition extends Condition

    # Sets up the required class variables.
    #
    # param  object  A reference to the regular expression to match.
    # param  object  A reference to one of the data source classes.
    constructor: (@regexp, dataSource) ->
        # Set up the data source
        super dataSource

    # Evaluates the passed data against the regular expression stored on this
    # class instance.
    #
    # param   mixed  The data loaded from the data source.
    # return  bool   If the evaluation succeeds or not.
    evaluate: (data) ->
        # Evaluate the passed data against the regular expression and return
        # the result
        return @regexp.test data

# Expose this class to the parent scope
Macchiato.expose "RegularExpressionCondition", RegularExpressionCondition
