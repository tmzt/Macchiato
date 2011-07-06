# This file defines the Base64Utilities class, and exposes it to the outside
# world.
#
# For more information on Base64 encoding and decoding, please see the
# Wikipedia article located at [http://en.wikipedia.org/wiki/Base64].
class Base64Utilities extends MacchiatoClass

    # Class variable to hold the output keys string. Base64 encoded values are
    # limited to this character set.
    @outputKeys = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" +
        "0123456789+/="

    # Returns a Base64-encoded string value using the passed input value. The
    # passed input value can contain anything, including binary data.
    #
    # param   string  The string data to Base64 encode.
    # return  string  The Base64-encoded version of the passed input string.
    @encode: (input) ->
        # Initialize the output string
        output = ""
        # Initialize the current buffer position
        bufferPosition = 0
        # Loop until we get to the end of the input string
        while bufferPosition < input.length
            # Grab three characters from the input string
            characterCode1 = input.charCodeAt bufferPosition++
            characterCode2 = input.charCodeAt bufferPosition++
            characterCode3 = input.charCodeAt bufferPosition++
            # Grab 6 bits from the first character
            encodedIndex1 = characterCode1 >> 2
            # Grab the remaining 2 bits from the first character and 4 bits
            # from the second character
            encodedIndex2 = ((characterCode1 & 3) << 4) | (characterCode2 >> 4)
            # Grab the remaining 4 bits from the second character and then grab
            # 2 bits from the third character
            encodedIndex3 = ((characterCode2 & 15) << 2) | (characterCode3 >> 6)
            # Grab the remaining 6 bits from the third character
            encodedIndex4 = characterCode3 & 63;
            # If the second character code is not a number
            if isNaN characterCode2
                # The third and fourth encoded indexes should point at the "="
                # sign in the output keys string
                encodedIndex3 = 64
                encodedIndex4 = 64
            # Otherwise, if just the last character code is not a number
            else if isNaN characterCode3
                # Point it at the "=" sign in the output keys string
                encodedIndex4 = 64
            # Concatenate this 4 character block to the final output string
            output += @outputKeys.charAt(encodedIndex1) +
                @outputKeys.charAt(encodedIndex2) +
                @outputKeys.charAt(encodedIndex3) +
                @outputKeys.charAt(encodedIndex4)

        # Return the finished output string
        return output

    # Attempts to decode the passed Base64-encoded string value by using the
    # same bitwise operations as the encoder in reverse.
    #
    # param   string  A Base64-encoded value.
    # return  string  The decoded string value.
    @decode: (input) ->
        # Strip any invalid characters from the input string
        input = input.replace /[^A-Za-z0-9\+\/\=]/g, ""
        # Initialize the output string
        output = ""
        # Initialize the current buffer position
        bufferPosition = 0
        # Loop until we get to the end of the input string
        while bufferPosition < input.length
            # Grab four characters from the input string
            encodedIndex1 = @outputKeys.indexOf input.charAt bufferPosition++
            encodedIndex2 = @outputKeys.indexOf input.charAt bufferPosition++
            encodedIndex3 = @outputKeys.indexOf input.charAt bufferPosition++
            encodedIndex4 = @outputKeys.indexOf input.charAt bufferPosition++
            # Reassemble the 4 6 bit values back into 3 8 bit values
            characterCode1 = (encodedIndex1 << 2) | (encodedIndex2 >> 4)
            characterCode2 = ((encodedIndex2 & 15) << 4) | (encodedIndex3 >> 2)
            characterCode3 = ((encodedIndex3 & 3) << 6) | encodedIndex4
            # Add the characters to the output string if they are not "="
            output += String.fromCharCode characterCode1
            output += String.fromCharCode characterCode2 if encodedIndex2 isnt 64
            output += String.fromCharCode characterCode3 if encodedIndex3 isnt 64

        # Return the decoded output value
        return output
