# This file defines the Rules class, and exposes it to the outside world.
#
# Instances of the Rules class manage one or more named decision-trees, which
# each are instances of the Rule class. These decision-trees can be invoked by
# executing the "run" method.
#
# The Rules class also exposes (what is intended to be) a write-only interface
# to a simple state object for key/value pairs. The state object can be
# referenced by the Rule class instances during evaluation.
class Rules extends PublishSubscribe

    # Evaluates a specific named decision-tree.
    #
    # param   string  The name of the decision-tree to run.
    # return  object  A reference to this class instance.
    evaluate: (name) ->
        # Return a reference to this class instance
        return @

# Expose this class to the parent scope
Macchiato.expose "Rules", Rules
