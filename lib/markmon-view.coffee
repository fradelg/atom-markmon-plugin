{CompositeDisposable, Disposable} = require 'atom'
{$, $$$, ScrollView}  = require 'atom-space-pen-views'
markmon = require './markmon-command'
path = require 'path'
request = require 'request'
os = require 'os'

module.exports =

class MarkmonView extends ScrollView
  atom.deserializers.add(this)

  editorSub           : null
  onDidChangeTitle    : -> new Disposable()
  onDidChangeModified : -> new Disposable()

  @deserialize: (state) ->
    new MarkmonView(state)

  constructor: ({@editorId, filePath}) ->
    super

    @iframe = document.createElement('iframe')
    @iframe.classList.add('markmon-preview native-key-bindings')
    @iframe.setAttribute("sandbox", "allow-scripts allow-same-origin")
#    @iframe.src = "http://localhost:#{atom.config.get('markmon-preview.port')}"

    if @editorId?
      @resolveEditor(@editorId)
      @tmpPath = @getPath() # after resolveEditor
    else
      if atom.workspace?
        @subscribeToFilePath(filePath)
      else
        atom.packages.onDidActivatePackage =>
          @subscribeToFilePath(filePath)

    @child = markmon()


  serialize: ->
    deserializer : 'MarkmonView'
    filePath     : @getPath()
    editorId     : @editorId

  destroy: ->
    @element.remove()
    @child.kill()
    @editorSub.dispose()

  getElement: ->
    @element

  subscribeToFilePath: (filePath) ->
    @trigger 'title-changed'
    @handleEvents()
    @renderHTML()

  resolveEditor: (editorId) ->
    resolve = =>
      @editor = @editorForId(editorId)

      if @editor?
        @trigger 'title-changed'
        @handleEvents()
      else
        atom.workspace?.paneForItem(this)?.destroyItem(this)

    if atom.workspace?
      resolve()
    else
      atom.packages.onDidActivatePackage =>
        resolve()
        @renderHTML()

  handleEvents: =>

    changeHandler = =>
      @renderHTML()
      pane = atom.workspace.paneForURI(@getURI())
      if pane? and pane isnt atom.workspace.getActivePane()
        pane.activateItem(this)

    @editorSub = new CompositeDisposable
    ext = path.extname(editor.getPath()).split '.'

    if @editor? and ext[ext.length - 1] is 'md'
      @editorSub.add @editor.onDidStopChanging changeHandler
      @editorSub.add @editor.onDidChangePath => @trigger 'title-changed'

  renderHTML: ->
    @showLoading()
    if @editor?
      @renderHTMLCode()

  renderHTMLCode: (text) ->
    if @editor.getPath()? then @save () =>
      request
        uri: "http://localhost:#{atom.config.get('markmon-preview.port')}"
        method: 'PUT'
        body: @editor.getText()
      , (error, response, body) ->
        console.log error if error?
        @iframe.src = "data:text/html;charset=utf-8," + escape(body);

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

  showLoading: ->
    @html $$$ ->
      @div class: 'atom-html-spinner', 'Loading HTML Preview\u2026'
