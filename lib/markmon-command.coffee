spawn = require('child_process').spawn

module.exports =
  class MarkmonController
    @markmon: null

    @args: ->
      list = []
      list.push "--port #{atom.config.get('markmon-preview.port')}"
      list.push "--command \"#{atom.config.get('markmon-preview.command')}\""
      list.push "--projectdir \"#{atom.project.getPaths()[0]}\""
      stylesheet = atom.config.get('markmon-preview.stylesheet')
      list.push "--stylesheet \"#{stylesheet}\"" if stylesheet isnt ""
      view = atom.config.get('markmon-preview.view')
      list.push "--view \"#{view}\"" if view isnt ""
      # Add project path at the end of the command
      list.push atom.project.getPaths()[0]
      return list

    @init: (cb) ->
      return cb() if @markmon?
      cmd = atom.config.get('markmon-preview.cmd')
      console.log "Starting markmon daemon: #{cmd}"
      @markmon = spawn cmd, @args()
      #@markmon.stdout.on 'data', (chunk) -> console.log chunk
      #@markmon.stderr.on 'data', (chunk) -> console.log chunk
      # just wait a second till the daemon starts
      setTimeout () ->
        return cb
      , 1000

    @finish: ->
      console.log "Stopping markmon daemon ..."
      @markmon.kill 'SIGINT' if @markmon?
