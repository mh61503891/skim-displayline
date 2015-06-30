{CompositeDisposable} = require 'atom'
child_process = require 'child_process'
module.exports =
  subscriptions: null
  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'skim:displayline': => @displayline()
  deactivate: ->
    @subscriptions.dispose()
  displayline: ->
    editor = atom.workspace.getActiveTextEditor()
    return unless editor.getBuffer().getBaseName().split('.').pop() == 'tex'
    app = 'displayline'
    line = editor.getCursorBufferPosition().row + 1
    texsourcefile = editor.getPath()
    texsourcefile = texsourcefile.replace(/\s/g, "\\ ")#Escape spaces in path
    pdffile = texsourcefile.replace('.tex', '.pdf')

    command = "#{app} -g #{line} #{pdffile} #{texsourcefile}"
    console.log(command)
    child_process.exec(command, {}, (error, stdout, stderr) ->
      console.error(error) if error
      console.error(stderr) if stderr
      console.log(stdout) if stdout
    )
