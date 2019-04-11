# Presentation: Immutable Data, Lenses, and Pac-man

Using Lenses to implement a Text based Pacman Game.  Haskell presents some
challenges as data structures are immutable.  Pac-man, like most games, has
lots of state that changes as game play evolves.  Lenses provide an
ergonomically friendly way of using immutable data structures in a seemingly
object-orientated way.  But how they work is facinating.  This talk will show
how they are used, and then, assuming I can understand them, delve into how
they work!

(Note, I didn't quite get to the "how they work" bit!

## Building the presentation

The presentation is a single Markdown file which is build with [pandoc][1]
and uses [Reveal.js][2].  The `make.sh` shell script builds the presentation into
the Presentation [`pacman.html`][3] file.

The presentation uses my Text User Interface (TUI) Haskell version of
Pac-man at: https://github.com/ajkavanagh/pacman

## References

1. [Pandoc][1], swiss army knife for document conversions.
2. [Reveal.js][2], JavaScript framework for building presentations.

[1]: https://pandoc.org/
[2]: https://revealjs.com/#/
[3]: ./pacman.html
