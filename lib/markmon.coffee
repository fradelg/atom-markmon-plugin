{CompositeDisposable} = require 'atom'
MarkmonView = require './markmon-view'

module.exports =
  config:
    cmd:
      type        : 'string'
      description : 'The markmon executable name'
      default     : 'markmon'
    port:
      type        : 'integer'
      description : 'The port where markmon in running'
      default     : 3000
    command:
      type        : 'string'
      description : 'The pandoc command to exec'
      default     : 'pandoc --mathjax'
    stylesheet:
      type        : 'string'
      description : 'The stylesheet to render HTML view'
      default     : ''
    view:
      type        : 'string'
      description : 'The view of markmon'
      default     : ''

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'markmon-preview:toggle': => @toggle()

    atom.workspace.addOpener (uriToOpen) ->
      try
        {protocol, host, pathname} = url.parse(uriToOpen)
      catch error
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

    uri = "markmon-preview://editor/#{editor.id}"

    previewPane = atom.workspace.paneForURI(uri)
    if previewPane
      previewPane.destroyItem(previewPane.itemForURI(uri))
      return

    previousActivePane = atom.workspace.getActivePane()
    atom.workspace.open(uri, split: 'right', searchAllPanes: true).done (view) ->
      if view instanceof MarkmonView
        view.renderHTML()
        previousActivePane.activate()

  deactivate: ->
    @subscriptions.dispose()
