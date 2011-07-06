# This file defines the UTF8Utilities class, and exposes it to the outside
# world.
class UTF8Utilities extends MacchiatoClass

    # UTF-8-encodes the passed input string.
    #
    # param   string  input  The string to UTF-8-encode.
    # return  string         The encoded string.
    encode: (input) ->
        # Replace any \r\n sequences with \n
        input = input.replace /\r\n/g, "\n"
        # Initialize the output string
        output = ""
        # Loop over each character in the input string
        for bufferPosition in input
            # Grab the current character code
            characterCode = input.charCodeAt bufferPosition
            # If the character code is within the normal ASCII range
            if characterCode < 128
                # Simply add this character code to the output string
                output += String.fromCharCode characterCode
            else if characterCode > 127 and characterCode < 2048
                output += String.fromCharCode (characterCode >> 6) | 192
                output += String.fromCharCode (characterCode & 63) | 128
            else
                output += String.fromCharCode (characterCode >> 12) | 224
                output += String.fromCharCode ((characterCode >> 6) & 63) | 128
                output += String.fromCharCode (characterCode & 63) | 128
        # Return the finished output string
        return output

    # Decodes the passed UTF-8-encoded string.
    #
    # param   string  input  The UTF-8-encoded string to decode.
    # return  string         The decoded string.
    decode: (input) ->
        # Initialize the output string
        output = ""
        # Loop until we get to the end of the string
        while bufferPosition < input.length
            # Grab the current character code
            characterCode = input.charCodeAt bufferPosition
            # If the character code is within the normal ASCII range
            if characterCode < 128
                # Add this character to the output string
                output += String.fromCharCode characterCode
                # Increment the buffer position
                bufferPosition++

