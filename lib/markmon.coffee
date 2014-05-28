MarkmonView = require './markmon-view'

module.exports =
  configDefaults:
    cmd: 'markmon'
    port: '3000'
    command: 'pandoc --mathjax -N -t html 5'
    stylesheet: ''
    view: ''

  activate: ->
    atom.workspaceView.command 'markmon-preview:show', =>
      @show()

  show: ->
    return unless atom.workspace.getActiveEditor()?
    pane = atom.workspace.getActivePane().splitRight()
    pane.addItem new MarkmonView()