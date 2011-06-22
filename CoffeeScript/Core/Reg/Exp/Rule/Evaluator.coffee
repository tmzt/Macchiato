# This file defines the RegExpRuleEvaluator class, and exposes it to the
# outside world.
class RegExpRuleEvaluator extends PublishSubscribe

	# Sets up the required class variables and named topic channels.
	#
	# param  object  A reference to the regular expression to match.
	constructor: (@regexp) ->
		# Set up the named topic channels that this class can publish
		super "pass", "fail"

	# Evaluates the regular expression against the passed data source, then
	# issues a "pass" or "fail" notification based on the result.
	#
	# param   object  A reference to one of the rule data source classes.
	# return  object  A reference to this class instance.
	evaluate: (dataSource) ->
		# If the regular expression matches the passed data
		if @regexp.match dataSource.getData() isnt null
			# Issue a notification on the "pass" topic channel
			@notifyObservers "pass", @
		# Otherwise
		else
			# Issue a notification on the "fail" topic channel
			@notifyObservers "fail", @
		# Return a reference to this class instance
		return @

# Expose this class to the parent scope
Meta.expose "RegExpRuleEvaluator", RegExpRuleEvaluator
