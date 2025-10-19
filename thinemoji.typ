#set par(spacing:12pt)
#set text(blue)
#set grid(
	align: (x, y) => (
		if x == 0 {left + bottom}
		else {center + horizon}))
#show grid.cell: it => {
	if it.x == 0 or it.y == 0 {
		set text(black, size:13pt)
		it}
	else {
		set text(size:18pt)
		it}}

#let dec2hex(num) = {
	let digits = "0123456789abcdef"
	let hex = ""
	let rem = 0
	while true {
		rem = calc.rem(num, 16)
		hex = digits.at(rem) + hex
		num = calc.quo(num, 16)
		if num < 16 {
			hex = digits.at(num) + hex
			break}}
	return hex}

#let row_idx(start, end) = {
	let rowIdx = ()
	while start < end {
		rowIdx.push(dec2hex(start).slice(0,-1))
		start = start + 16}
	return rowIdx}

#let unicode_printer_no_axis(start, end) = {
	grid(columns:16, gutter:12pt,
		..range(start, end).map(str.from-unicode))}

#let unicode_printer(start, end) = {
	let header = "0123456789abcdef".split("").slice(0,-1)
	
	let item = ()
	let rowIdx = 0
	let middle = start

	// special case: first row
	let itemEmpty = ()
	while dec2hex(middle).at(-1) != "0" {
		itemEmpty.push("")
		middle = middle -1}

	let leader = row_idx(middle, end)
	item.push(leader.at(rowIdx))
	
	if itemEmpty.len() > 0 {item.push(itemEmpty)}

	middle = middle + 16
	item.push(range(start, middle).map(str.from-unicode))
	// first row done

	while middle < end {
		rowIdx = rowIdx + 1
		start = middle
		middle = middle + 16

		item.push(leader.at(rowIdx))

		if middle >= end {middle = end}
		item.push(range(start, middle).map(str.from-unicode))}

	grid(columns:(1fr,)*17, row-gutter:6pt,
		grid.header(..header),
		..item.flatten())}

//all unicode: (0, 1114096)  // 0000~10FFEF
//invalid unicode: (55296, 57344)  // d800~dfff
//unicode flags' letters: (127462, 127488)  // 1f1e6~1f1ff

#let unicode_flags() = {
	let resize(char) = {text(size:16pt, char)}
	let r = range(127462, 127488).map(dec2hex)
	let v = ()

	let h = ("[]",)
	for i in r {h.push("[\u{" + i + "}]")}  // header

	for m in r {v.push("[\u{" + m + "}]")  // leader
		for n in r {v.push("[\u{" + m + "}\u{" + n + "}]")}}

	grid(columns:(1fr,)*27, row-gutter:2pt,
		grid.header(..h.map(eval).map(resize)),
		..v.map(eval).map(resize))}

#let emoji_modifier_sequence() = {
	let resize(char) = {text(size:16pt, char)}
	let M = range(0x1f385, 0x1f6cd).map(dec2hex)
	let N = range(0x1f3fb, 0x1f400).map(dec2hex)
	let v = ()

	let h = ("[]",)
	for i in N {h.push("[\u{" + i + "}]")}  // header

	for m in M {v.push("[\u{" + m + "}]")  // leader
		for n in N {v.push("[\u{" + m + "}\u{" + n + "}]")}}

	grid(columns:(1fr,)*6, row-gutter:2pt,
		grid.header(..h.map(eval)),
		..v.map(eval))}

#let emoji_supplement() = {
	grid(columns:(7fr,5fr,11fr,5fr,5fr),
		grid(columns:(1.6em,)*3, row-gutter:1pt,
			[],[a],[b],[231],[\u{231a}],[\u{231b}]),
		grid(columns:(1.6em,)*2, row-gutter:1pt,
			[],[8],[232],[\u{2328}]),
		grid(columns:(1.6em,)*5, row-gutter:1pt,
			[],[0],[1],[2],[3],
			[23f],[\u{23f0}],[\u{23f1}],[\u{23f2}],[\u{23f3}]),
		grid(columns:(1.6em,)*2, row-gutter:1pt,
			[],[4],[276],[\u{2764}]),
		grid(columns:(1.6em,)*2, row-gutter:1pt,
			[],[0],[2b5],[\u{2b50}]))}

#let compose() = {
	if sys.inputs.len() == 0 {
		//emoji_supplement()  // 231a~b,2328,23f0~3,2764,2b50
		//unicode_printer(9728, 10064)  // 2600~274f
		//unicode_printer(127744, 128592)  // 1f300~1f64f
		//unicode_printer(128640, 128765)  // 1f680~1f6fc
		//unicode_printer(129292, 129536)  // 1f90c~1f9ff
		//unicode_printer(129648, 129785)  // 1fa70~1faf8
		unicode_printer(127462, 127488)  // 1f1e6~1f1ff(A~Z)
		unicode_flags()  /* AA~ZZ */
		emoji_modifier_sequence()}
	else {
		for (key, value) in sys.inputs {
			unicode_printer(eval(key), eval(value))}}}

#compose()
