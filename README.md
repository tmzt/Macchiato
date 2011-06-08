# Macchiato #

Macchiato is a toolkit for building complex software in JavaScript. It is
designed for use both in the web browser as well as on the server, and just so
happens to be written in [CoffeeScript][homepage-coffeescript].

## Building the Macchiato Library ##

If you have Node.js and CoffeeScript installed, chances are you have Cake - the
CoffeeScript build tool. If so, you should be able to run:

	# Change into the base Macchiato project directory
	cd /somewhere/on/your/disk/Macchiato
	# Use the Cake utility to build the project
	cake build

Cake should display some text on the screen that looks something like:

	Macchiato - The CoffeeScript toolkit.
	Building the complete Macchiato library...
	Done.

The finished library file will be inside of the Macchiato/JavaScript directory,
and should be named "Macchiato.js".

## License ##

Macchiato is, and always will be, free and open source software, both for fun
and for profit. All files in this repository are released under the terms
specified in the file [LICENSE][repo-license]. For more information, please see
the the [Wikipedia article on the MIT License][wikipedia-mit-license].

## Contributing ##

Macchiato needs your help! If you want to be a contributer, of anything, you
are more then welcome to do so. The project guidelines for contributors can be
found in the official project Wiki [here][wiki-guidelines].

[homepage-coffeescript]: http://jashkenas.github.com/coffee-script/ "CoffeeScript's Homepage"
[repo-license]: ./Macchiato/blob/master/LICENSE "View the file LICENSE in the Macchiato project repository"
[wikipedia-mit-license]: http://en.wikipedia.org/wiki/MIT_License "Wikipedia article for the MIT License"
[wiki-guidelines]: ./Macchiato/wiki/Guidelines-for-Contributors "Macchiato Wiki - Guidelines for Contributors"
