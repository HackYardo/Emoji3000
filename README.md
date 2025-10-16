# ThinEmoji
The most concise Emoji table in the world, with hex Unicode codepoints.\
**Key words:** unicode, emoji, cheat-sheet, full-list, typst, pdf

<table>
  <tr align="center"><td>E.g.</td><td>0 .. 5 .. a .. f</td></tr>
  <tr><td>1f34</td><td>&#x1f340 &#x1f345 &#x1f34a &#x1f34f</td></tr>
  <tr><td>1f37</td><td>&#x1f370 &#x1f375 &#x1f37a &#x1f37f</td></tr>
  <tr><td>1f98</td><td>&#x1f980 &#x1f985 &#x1f98a &#x1f98f</td></tr>
  <tr><td>1f68</td><td>&#x1f680 &#x1f685 &#x1f68a &#x1f68f</td></tr>
</table>

## Use
Tired to search unicodes one by one? All emojis on a 6-page pdf!\
<a href="../../releases/download/v0.1.6/ThinEmoji.pdf">ThinEmoji.pdf</a><br>
Not only Emoji, but also any Unicode char.
## Dev
```
./typst compile some.typ  # gen some.pdf
typst c some.typ --input 0x00=0xc0 --input 0x1f980=0x1faf9
```
## License
[GPL-3.0](LICENSE)
