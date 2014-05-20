_ = require 'underscore-plus'
{$, $$$, ScrollView} = require 'atom'
markmon = require './markmon-command'
path = require 'path'
request = require 'request'

module.exports =

class MarkmonView extends ScrollView

  atom.deserializers.add(this)

  @deserialize: ({filePath}) ->
    new MarkmonView(filepath)

  @content: ->
    @iframe class: 'markmon-preview native-key-bindings', tabindex: -1, sandbox: 'allow-same-origin allow-scripts allow-forms allow-popups'

  constructor: ->
    super
    @child = markmon()
    @.attr 'src', "http://localhost:#{atom.config.get('markmon.port')}"

    # Register updates on every existing and future editor
    atom.workspace.eachEditor (editor) =>
      ext = path.extname(editor.getPath()).split '.'
      if ext[ext.length - 1] is 'md'
        @subscribe editor.buffer, 'saved', _.debounce((=> @render()), 500)

  # Returns an object that can be retrieved when package is activated
  serialize: ->
    deserializer: 'MarkmonView'
    filePath: @getPath()

  # Tear down any state and detach
  destroy: ->
    @child.kill()
    atom.workspace.eachEditor (editor) =>
      @unsubscribe()

  getTitle: ->
    'Pandoc preview'

  # Update HTML with the editor content
  render: ->
    request
      uri: "http://localhost:#{atom.config.get('markmon.port')}"
      method: 'PUT'
      body: atom.workspace.getActiveEditor().getText()
    , (error, response, body) ->
      console.log error if error?

    $('iframe.markmon-preview').attr 'src', (i, val) -> val

    atom.workspaceView.getActiveView()
