# This file defines the HTMLElement class, and exposes it to the outside world.
#
# Each HTMLElement class instance manages a single HTML document element,
# providing one final layer of abstraction before the underlying document is
# actually manipulated.
class HTMLElement extends PublishSubscribe

    # Calls the parent constructor.
    constructor: ->
        # Invoke the parent constructor
        super()

# Expose this class to the parent scope
Macchiato.expose "HTMLElement", HTMLElement
