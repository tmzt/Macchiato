# Contains functions designed to help manage code organization and visibility.
class Macchiato

    # Holds a collection of name/class-reference pairs for everything that gets
    # exposed.
    @exposed = {}

    # Attaches the passed class, object, or function reference to this class
    # instance, and adds it to the exposed class variable by name.
    #
    # param   string  name       The name that should be used to expose the
    #                            function or object reference.
    # param   mixed   reference  A reference to the function or object that
    #                            will be exposed.
    # return  object             A reference to this class instance.
    @expose: (name, reference) ->
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
    @overlay: (destination) ->
        # Clone the exposed references collection onto the destination object
        destination[name] = reference for own name, reference of @exposed
        # Return a reference to the destination object
        return destination

# If the DoNotExposeMacchiato flag is not defined or is not set to boolean true
if not DoNotExposeMacchiato? or DoNotExposeMacchiato isnt true
    # Attach the Macchiato class to the parent scope
    (if exports? then exports else @).Macchiato = Macchiato
