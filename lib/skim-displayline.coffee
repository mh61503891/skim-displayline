{ CompositeDisposable } = require 'atom'
child_process = require 'child_process'

module.exports =
  config:
    binaryPath:
      description: 'Path for the displayline binary'
      type: 'string'
      default: 'displayline'
      order: 1
    readingBar:
      description: 'Indicate the line using the reading bar'
      type: 'boolean'
      default: false
    background:
      description: 'Do not bring Skim to the foreground'
      type: 'boolean'
      default: true

  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'skim:displayline': => @displayline()

  deactivate: ->
    @subscriptions.dispose()

  displayline: ->
    editor = atom.workspace.getActiveTextEditor()
    return unless editor.getBuffer().getBaseName().split('.').pop() == 'tex'
    app = atom.config.get('skim-displayline.binaryPath')
    line = editor.getCursorBufferPosition().row + 1
    texsourcefile = editor.getPath()
    texsourcefile = texsourcefile.replace(/\s/g, "\\ ")#Escape spaces in path

    rootspec = (/^% ?!TEX root ?= ?(.*)$/gm).exec(editor.getBuffer().getText())
    if rootspec
      roottex = texsourcefile.replace(/[^\/]*$/, rootspec[1].trim())
    else
      roottex = texsourcefile
    pdffile = roottex.replace('.tex', '.pdf')

    options = ""
    if atom.config.get('skim-displayline.readingBar')
      options += " -readingbar"
    if atom.config.get('skim-displayline.background')
      options += " -background"

    command = "#{app} #{options} #{line} #{pdffile} #{texsourcefile}"
    console.log(command)
    child_process.exec(command, {}, (error, stdout, stderr) ->
      if error
        console.error(error)
        atom.notifications.addError("skim-displayline", {
          detail: error.toString()
        })
      console.log(stdout) if stdout
      console.log(stderr) if stderr
    )
