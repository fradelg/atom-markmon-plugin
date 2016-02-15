# Markmon Preview package for Atom

This package runs [markmon](https://github.com/yyjhao/markmon) as a server, sends your Markdown files to it and preview the output in Atom.

It supports latex mathematical expressions thanks to Mathjax and the pandoc processor

## Commands

  * `Markmon Preview: Toggle` -> Runs markdown as a server and opens a new pane to render the HTML output

## Settings

  * `markmon-preview.port` which is the local port on which server listens
  * `markmon-preview.command`, the Markdown converter to execute (pandoc is used by default)
  * `markmon-preview.stylesheet`, a CSS stylesheet for the server HTML output
  * `markmon-preview.view`, the command to execute after the server is setup

To solve problems with PATH take a look at [Pandoc Preview Atom Package](https://atom.io/packages/pandoc)

## Acknowledgements

 - [Atom HTML Preview](https://github.com/webBoxio/atom-html-preview).
 - [Pandoc](http://pandoc.org)
 - [Markmon](https://github.com/yyjhao/markmon)
