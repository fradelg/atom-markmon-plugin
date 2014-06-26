# Markmon Preview

Run [markmon](https://github.com/yyjhao/markmon) as a server, send your Markdown files to it and preview the output within Atom.

It supports latex mathematical expressions thanks to Mathjax and pandoc processor

In order to make it work you must install the `markmon` npm module:

`npm install -g markmon`

Commands:

  * `Markmon Preview: Show` will run markdown as a server and opens a new pane to render the HTML output. The output is updated 1 second after the last change in the editor.

There are four basic parameters in settings:

  * `markmon-preview.cmd` which is the markmon executable
  * `markmon-preview.port` which is the local port on which server listens
  * `markmon-preview.command`, the Markdown converter to execute (pandoc is used by default)
  * `markmon-preview.stylesheet`, a CSS stylesheet for the server HTML output
  * `markmon-preview.view`, the command to execute after the server is setup

To solve problems with PATH take a look at [Pandoc Preview Atom Package](https://atom.io/packages/pandoc)
