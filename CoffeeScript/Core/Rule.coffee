# This file defines the Rule class, and exposes it to the outside world.
#
# An instance of the Rule class manages the evaluation of a single condition or
# action.
#
# Rule extends the PublishSubscribe class, and publishes notifications into
# either the "pass" or "fail" named topic channels based on the result of the
# evaluator.
class Rule extends PublishSubscribe

	# Sets up the passed rule type, rule evaluator, and data source as
	# variables on this class instance.
	#
	# param  object  An instance of one of the rule evaluator classes.
	# param  object  An instance of one of the rule data source classes.
	constructor: (@evaluator, @dataSource) ->
		# Set up the named topic channels that this class can publish
		super "pass", "fail"

	# Evaluates this rule, then using the result of the evaluation either
	# issues a "pass" or "fail" notification.
	#
	# return  object  A reference to this class instance.
	evaluate: ->
		# If the result of the evaluation is boolean true
		if @evaluator.evaluate @dataSource is true
			# Issue a notification on the "pass" topic channel
			@notifyObservers "pass", @
		# Otherwise
		else
			# Issue a notification on the "fail" topic channel
			@notifyObservers "fail", @
		# Return a reference to this class instance
		return @

# Expose this class to the parent scope
Meta.expose "Rule", Rule
