url = require 'url'
fs = require 'fs-plus'

MarkmonView = require './markmon-view'

module.exports =
  activate: (state) ->
    @setConfigDefaults()
    atom.workspaceView.command 'markmon-preview:show', =>
      @show()

  show: ->
    return unless atom.workspace.getActiveEditor()?
    pane = atom.workspace.getActivePane().splitRight()
    pane.addItem new MarkmonView()

  setConfigDefaults: ->
    atom.config.setDefaults 'markmon-preview',
      cmd: 'markmon'
      port: '3003'
      command: 'pandoc --mathjax'
      stylesheet: ''
      view: ''
