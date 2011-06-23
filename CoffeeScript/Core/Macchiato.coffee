# Contains functions designed to help manage code organization and visibility.
class Macchiato

	# Creates a class variable to store the exposed object and function
	# references.
	constructor: ->
		# Define an object to hold everything that gets exposed
		@exposed = {}

	# Attaches the passed class, object, or function reference to this class
	# instance, and adds it to the exposed class variable by name.
	#
	# param   string  name       The name that should be used to expose the
	#                            function or object reference.
	# param   mixed   reference  A reference to the function or object that
	#                            will be exposed.
	# return  object             A reference to this class instance.
	expose: (name, reference) ->
		# Add the passed name and reference to the exposed references
		# collection
		@exposed[name] = reference
		# Attach the passed reference to the current class scope
		@[name] = reference
		# Return a reference to this class instance
		return @

	# Overlays all of the named function and object references in the exposed
	# objects collection onto the passed object.
	#
	# param   object  destination  The object on which to overlay the named
	#                              references.
	# return  object               A reference to the destination object.
	overlay: (destination) ->
		# Clone the exposed references collection onto the destination object
		destination[name] = reference for own name, reference of @exposed
		# Return a reference to the destination object
		return destination

# Create a single instance of the Macchiato class, overwriting the class
# definition in the process
Macchiato = new Macchiato

# Overlay the Macchiato class, object, and function references onto the parent
# scope
(if exports? then exports else @).Macchiato = Macchiato
