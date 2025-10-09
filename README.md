# ThinEmoji
The most concise Emoji table in the world, with hex Unicode codepoints.\
**Key words:** unicode, emoji, cheat-sheet, full-list, typst, pdf
# Use
Tired to search unicode one by one? All emojis on a 6-page pdf!\
<a href="../../releases/download/v0.1.0/ThinEmoji.pdf">ThinEmoji.pdf</a><br>
Not only Emoji, but also any Unicode char.
# Dev
```sh
typst compile some.typ  # gen some.pdf
typst compile some.typ --input 0x00=0xc0 --input 0x1f980=0x1faf9
```
## License
[GPL-3.0](LICENSE)
