# This file defines the RegExpCondition class, and exposes it to the
# outside world.
class RegExpCondition extends Condition

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
		# If the regular expression matches the passed data
		if @regexp.match data isnt null
			# The regular expression matched
			return true
		# If we made it down here, that means the regular expression did not
		# match the passed data
		return false

# Expose this class to the parent scope
Meta.expose "RegExpCondition", RegExpCondition
