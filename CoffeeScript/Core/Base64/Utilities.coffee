# This file defines the Base64Utilities class, and exposes it to the outside
# world.
class Base64Utilities extends MacchiatoClass

    # Class variable to hold the output keys string. Base64 encoded values are
    # limited to this character set.
    @outputKeys = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" +
        "0123456789+/="

    # Returns a Base64-encoded string value using the passed input value. The
    # passed input value can contain anything, including binary data.
    #
    # The actual encoding process is reasonably straightforward. This function
    # loops over the passed input string from left to right taking 3 character
    # chunks. Then, using the JavaScript bitwise operators, 6 bits are removed
    # from each 8 bit source character to create a 4th output character using
    # the reassembled bits.
    #
    # For more information, please see the Wikipedia article on Base64 encoding
    # located at [http://en.wikipedia.org/wiki/Base64].
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
            encodedIndex1 = characterCode1 >> 2;
            # Grab the remaining 2 bits from the first character and 4 bits
            # from the second character
            encodedIndex2 = ((characterCode1 & 3) << 4) | (characterCode2 >> 4)
            # Grab the remaining 4 bits from the second character and then grab
            # 2 bits from the third character
            encodedIndex3 = ((characterCode2 & 15) << 2) | (characterCode3 >> 6)
            # Grab the remaining 6 bits from the third character
            encodedIndex4 = characterCode3 & 63;

            # If the second character code is not a number
            if typeof characterCode2 isnt "number"
                # The third and fourth encoded indexes should point at the "="
                # sign in the output keys string
                encodedIndex3 = encodedIndex4 = 64
            # Otherwise, if just the last character code is not a number
            else if typeof characterCode3 isnt "number"
                # Point it at the "=" sign in the output keys string
                encodedIndex4 = 64

            # Concatenate this 4 character block to the final output string
            output = output +
                @outputKeys.charAt encodedIndex1 +
                @outputKeys.charAt encodedIndex2 +
                @outputKeys.charAt encodedIndex3 +
                @outputKeys.charAt encodedIndex4

        # Return the finished output string
        return output
