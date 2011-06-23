# This file defines the RepeatedTask class, and exposes it to the outside
# world.
#
# RepeatedTask wraps the actual running of the task function in a JavaScript
# timer using the setInterval function. Execution of the "run" method starts
# the timer, and the execution of the "cancel" method halts it.
class RepeatedTask extends TimerTask

    # Takes the task function and any options, then assigns them to this
    # object.
    #
    # param  function  taskFunction            The task function itself.
    # param  integer   interval      optional  The length of the interval, in
    #                                          milliseconds. Defaults to 1.
    # param  object    runScope      optional  The scope to run the task
    #                                          function at. Defaults to @.
    constructor: (taskFunction, interval = 1, runScope = @) ->
        # Invoke the parent constructor
        super taskFunction, "interval", interval, runScope
        # Set the instance variables to their initial state
        @reset()

# Expose this class to the parent scope
Macchiato.expose "RepeatedTask", RepeatedTask
