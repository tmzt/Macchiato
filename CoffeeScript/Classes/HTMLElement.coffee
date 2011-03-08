# This file defines the Element class, and exposes it to the outside world.
#
# Each Element class instance manages a single HTML document element, providing
# one final layer of abstraction before the underlying document is actually
# manipulated or queried.
class HTMLElement extends PublishSubscribe

	# Creates the class variable to store the observers.
	constructor: ->

# Expose this class to the parent scope
Meta.expose "HTMLElement", HTMLElement
