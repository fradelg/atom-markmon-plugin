childProcess = require 'child_process'
_ = require 'underscore-plus'

language = (name) ->
  (atom.config.get('pandoc.languages') || {})[name.toLowerCase()] || 'markdown'

args = ->
  list = []
  list.push "--port #{atom.config.get('markmon-preview.port')}"
  list.push "--command \"#{atom.config.get('markmon-preview.command')}\""
  list.push "--projectdir \"#{atom.project.path}\""
  stylesheet = atom.config.get('markmon-preview.stylesheet')
  list.push "--stylesheet \"#{stylesheet}\"" if stylesheet isnt ""
  view = atom.config.get('markmon-preview.view')
  list.push "--view \"#{view}\"" if view isnt ""
  _.flatten list

module.exports = ->
  cmd = atom.config.get('markmon-preview.cmd') + ' ' + args().join ' '
  markmon = childProcess.exec cmd, [ atom.project.path ]
  markmon.stderr.on 'data', (data) -> console.log data
  return markmon
