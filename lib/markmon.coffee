url                   = require 'url'
path                  = require 'path'
{CompositeDisposable} = require 'atom'
MarkmonView = require './markmon-view'
MarkmonController = require './markmon-command'

module.exports =
  config:
    port:
      type        : 'integer'
      description : 'The port where markmon daemon will be listening'
      default     : 3000
    command:
      type        : 'string'
      description : 'Pandoc command to render markdown code into HTML'
      default     : 'pandoc --mathjax'
    stylesheet:
      type        : 'string'
      description : 'Path to your custom CSS stylesheet of preview'
      default     : ''
    view:
      type        : 'string'
      description : 'Command to execute after the markmon server is setup'
      default     : ''

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'markmon-preview:toggle': => @toggle()

    atom.workspace.addOpener (uri) ->
      try
        {protocol, host, pathname} = url.parse(uri)
      catch error
        console.log error
        return

      return unless protocol is 'markmon-preview:'

      try
        pathname = decodeURI(pathname) if pathname
      catch error
        return

      if host is 'editor'
        new MarkmonView(editorId: pathname.substring(1))
      else
        new MarkmonView(filePath: pathname)

  toggle: ->
    editor = atom.workspace.getActiveTextEditor()
    return unless editor?

    ext = path.extname(editor.getPath()).split '.'
    return unless ext[ext.length - 1] is 'md'

    uri = "markmon-preview://editor/#{editor.id}"

    previewPane = atom.workspace.paneForURI(uri)
    if previewPane
      previewPane.destroyItem(previewPane.itemForURI(uri))
      return

    previousActivePane = atom.workspace.getActivePane()
    atom.workspace.open(uri, split: 'right', searchAllPanes: true).then (view) ->
      if view instanceof MarkmonView
        view.renderHTML()
        previousActivePane.activate()

  deactivate: ->
    MarkmonController.finish()
    @subscriptions.dispose()
