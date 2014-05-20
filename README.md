# Markmon Preview

Run [markmon](https://github.com/yyjhao/markmon) as a server, send yout Markdown files to it and preview the output within Atom.

Commands:

  * `Markmon Preview: Show` will run the server and opens a new pane with the output.

There are three config settings:

  * `markmon.cmd` which is the markmon executable
  * `markmon.port` which is the loca port on which server listens
  * `markmon.stylesheet`, a CSS stylesheet for the server HTML output
  * `markmon.command`, the Markdown converter to execute (pandoc is by default)

To solve problems with path take a look at [Pandoc Preview Atom Package](https://atom.io/packages/pandoc)
