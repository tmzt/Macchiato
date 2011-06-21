# This file defines the Rule class, and exposes it to the outside world.
#
# An instance of the Rule class manages the evaluation of a single condition or
# action.
class Rule extends PublishSubscribe

	# Sets up the passed rule type, rule evaluator, and data source as
	# variables on this class instance.
	#
	# param  string  The type of rule. Can currently be "regex", "string" or
	#                "function".
	# param  
	constructor: (@type, @evaluator, @data) ->
		# Set up a task queue for the success case
		@passTasks = new Tasks
		# Set up a task queue for the failure case
		@failTasks = new Tasks

	# Adds a single task function to the pass task queue.
	#
	# param   function  taskFunction  A single task function to add to the
	#                                 queue.
	# return  object                  A reference to this class instance.
	addPassTask: (taskFunction) ->
		# Adds a task to the task queue
		@passTasks.add taskFunction
		# Return a reference to this class instance
		return @

	# Adds a single task function to the fail task queue.
	#
	# param   function  taskFunction  A single task function to add to the
	#                                 queue.
	# return  object                  A reference to this class instance.
	addFailTask: (taskFunction) ->
		# Adds a task to the task queue
		@passTasks.add taskFunction
		# Return a reference to this class instance
		return @

	# Evaluates this rule.
	#
	# return  object  A reference to this class instance.
	evaluate: ->
		# If we are evaluating a regular expression
		if @type is "regex"
			# Attempt to match using the regular expression evaluator
			@evaluator.match @data
		# If we are evaluating a simple string
		else if @type is "string"
			
		# If we are evaluating the result of a function
		else if @type is "function"
			# Define the two-stage evaluation tasks object to allow for
			# asynchronous rule processing
			evaluationTasks = new Tasks [
				# The first task is to do the evaluation
				(evaluationTaskControl) =>
					# Run the evaluation function, passing in the tasks object
					# and capturing the result
					evaluationResult = @evaluator evaluationTaskControl
					# If the function returned boolean true, we assume we are
					# being used for synchronous processing, so we move on to
					# complete the task right here
					evaluationTaskControl.next true if evaluationResult is true
				(evaluationTaskControl, evaluationResult) =>
					# If the evaluation result is true
					if evaluationResult is true
						# Run all of the pass task functions
						@passTasks.runAll()
					else
						# Run all of the fail task functions
						@failTasks.runAll()
			]
			# Run the evaluation tasks
			evaluationTasks.run()
		# Return a reference to this class instance
		return @

# Expose this class to the parent scope
Meta.expose "Rule", Rule
