childProcess = require 'child_process'
_ = require 'underscore-plus'

language = (name) ->
  (atom.config.get('pandoc.languages') || {})[name.toLowerCase()] || 'markdown'

args = ->
  _.flatten ["--port #{atom.config.get('markmon-preview.port')}", "--command \"#{atom.config.get('markmon-preview.command')}\"", "--projectdir \"#{atom.project.path}\"", "--stylesheet \"#{atom.config.get('markmon-preview.stylesheet')}\""]

module.exports = ->
  cmd = atom.config.get('markmon-preview.cmd') + ' ' + args().join ' '
  markmon = childProcess.exec cmd, [ atom.project.path ]
  markmon.stderr.on 'data', (data) -> console.log data
  return markmon
