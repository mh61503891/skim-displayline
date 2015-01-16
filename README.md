# Skim Displayline Package

Runs `displayline` from Atom.

## Displayline

The `displayline` is a command line tool of [Skim](http://skim-app.sourceforge.net/) to highlight a line on PDF specified by a line number in the TeX source file.

Usage:

```bash
$ /Applications/Skim.app/Contents/SharedSupport/displayline
Usage: displayline [-r] [-b] [-g] LINE PDFFILE [TEXSOURCEFILE]
Options:
-r, -revert      Revert the file from disk if it was open
-b, -readingbar  Indicate the line using the reading bar
-g, -background  Do not bring Skim to the foreground
```

## Setup

Add the path for `displayline` to `$PATH` in `$HOME/.bash_profile`.

```$HOME/.bash_profile
export PATH=/Applications/Skim.app/Contents/SharedSupport/:$PATH
```

Check:

```bash
$ type -a displayline
displayline is /Applications/Skim.app/Contents/SharedSupport/displayline
```

## Usage

1. Create PDF with `latex -synctex=1 example.tex && dvipdfmx example.dvi`. (`-synctex=1` is **required**.)
2. Open `example.pdf` by Skim.
2. Open the command pallet by `shift-cmd-P` on Atom.
3. Find `Skim:Displayline` and run it.

Or, for example, add the following to `keymap.cson`.

```keymap.cson
'.platform-darwin':
  'cmd-s cmd-s': 'skim:displayline'
```
