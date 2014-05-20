# Markmon Preview

Run [markmon](https://github.com/yyjhao/markmon) as a server, send your Markdown files to it and preview the output within Atom.

It supports latex mathematical expressions thanks to Mathjax and pandoc processor

In order to make it work you must install `require` and `markmon` npm modules:

`npm install -g markmon require`

Commands:

  * `Markmon Preview: Show` will run the server and opens a new pane with the output.

There are four basic parameters in settings:

  * `markmon.cmd` which is the markmon executable
  * `markmon.port` which is the local port on which server listens
  * `markmon.stylesheet`, a CSS stylesheet for the server HTML output
  * `markmon.command`, the Markdown converter to execute (pandoc is by default)

To solve problems with PATH take a look at [Pandoc Preview Atom Package](https://atom.io/packages/pandoc)
