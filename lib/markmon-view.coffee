{CompositeDisposable, Disposable} = require 'atom'
{$, $$$, ScrollView}  = require 'atom-space-pen-views'
MarkmonController = require './markmon-command'
request = require 'request'

module.exports =

class MarkmonView extends ScrollView
  atom.deserializers.add(this)

  editorSub           : null
  onDidChangeTitle    : -> new Disposable()
  onDidChangeModified : -> new Disposable()

  @deserialize: (state) ->
    new MarkmonView(state)

  @content: ->
    @iframe class: 'markmon-preview native-key-bindings', tabindex: -1, sandbox: 'allow-same-origin allow-scripts allow-top-navigation allow-pointer-lock'

  constructor: ({@editorId, filePath}) ->
    super

    if @editorId?
      @resolveEditor @editorId
    else
      if atom.workspace?
        @subscribeToFilePath(filePath)
      else
        atom.packages.onDidActivatePackage =>
          @subscribeToFilePath(filePath)

  serialize: ->
    deserializer : 'MarkmonView'
    filePath     : @getPath()
    editorId     : @editorId

  destroy: ->
    @editorSub.dispose() if @editorSub?

  subscribeToFilePath: (filePath) ->
    @trigger 'title-changed'
    @handleEvents()
    @renderHTML()

  resolveEditor: (editorId) ->
    resolve = =>
      @editor = @editorForId editorId

      if @editor?
        @trigger 'title-changed'
        @handleEvents()
      else
        atom.workspace?.paneForItem(this)?.destroyItem(this)

    if atom.workspace.getPaneItems().length > 0
      resolve()
    else
      atom.packages.onDidActivatePackage =>
        resolve()
        @renderHTML()

  editorForId: (editorId) ->
    for editor in atom.workspace.getTextEditors()
      return editor if editor.id?.toString() is editorId.toString()
    null

  handleEvents: =>

    changeHandler = =>
      @renderHTML()
      pane = atom.workspace.paneForURI @getURI()
      if pane? and pane isnt atom.workspace.getActivePane()
        pane.activateItem(this)

    @editorSub = new CompositeDisposable
    MarkmonController.init () =>
      @.attr 'src', "http://localhost:#{atom.config.get('markmon-preview.port')}"

      if @editor?
        @editorSub.add @editor.onDidStopChanging changeHandler
        @editorSub.add @editor.onDidChangePath => @trigger 'title-changed'

  renderHTML: () ->
    if @editor?.getPath()?
      request
        uri: "http://localhost:#{atom.config.get('markmon-preview.port')}"
        method: 'PUT'
        body: @editor.getText()
      , (error, response, body) ->
        console.log error if error?

  getTitle: ->
    if @editor?
      "#{@editor.getTitle()} Preview"
    else
      "Markmon Preview"

  getURI: ->
    "markmon-preview://editor/#{@editorId}"

  getPath: ->
    if @editor?
      @editor.getPath()

  showError: (result) ->
    failureMessage = result?.message

    @html $$$ ->
      @h2 'Previewing Pandoc Failed'
      @h3 failureMessage if failureMessage?
