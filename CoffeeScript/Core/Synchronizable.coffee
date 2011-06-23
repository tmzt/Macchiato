# This file defines the Synchronizable class, and exposes it to the outside
# world.
class Synchronizable

    # Does stuff.
    constructor: ->

# Expose this class to the parent scope
Macchiato.expose "Synchronizable", Synchronizable
