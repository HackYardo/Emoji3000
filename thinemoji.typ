#set par(spacing:12pt)

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
	set grid(
		align: (x, y) => (
			if x == 0 {left + bottom}
			else {center + horizon}))
	show grid.cell: it => {
		if it.x == 0 or it.y == 0 {
			set text(black, size:13pt)
			it}
		else {
			set text(blue, size:18pt)
			it}}

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
	item.push(itemEmpty)

	middle = middle + 16
	if end <= middle {
		item.push(range(start, end).map(str.from-unicode))
		for count in range(0, middle - end) {item.push("")}}
	else {
		item.push(range(start, middle).map(str.from-unicode))}
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

//all unicode: (0, 1114112)  // 0000~10FFFF
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
	/*let resize(char) = {text(size:16pt, char)}
	let M = range(0x1f385, 0x1f6cd)
	let N = range(0x1f3fb, 0x1f400).map(str.from-unicode)
	let item = ()

	let h = ("",)
	for n in N {h.push(n)}  // header


	for m in M {item.push(dec2hex(m))  // leader
		for n in N {
			m = str.from-unicode(int(m))
			item.push([#n#m])}}

	grid(columns:(1fr,)*6, row-gutter:2pt,
		grid.header(..h),
		..item)}*/
	return str.codepoints("a")}

#let unicode_printer_segment(start, end) = {
	end = end + 2

	let header = ("",)
	let middle = start
	while middle < end {
		header.push(dec2hex(middle).at(-1))
		middle = middle + 1}

	let leader = dec2hex(start).slice(0,-1)

	let item = range(start, end).map(str.from-unicode)
	item.insert(0, leader)

	return (header, item)}

#let unicode_printer_scatter(nums) = {
	let header = ()
	let leader = ""
	let item = ()

	for num in nums {
		if type(num) == int {
			let idx = dec2hex(num)
			let idxRow = idx.slice(0,-1)
			let idxCol = idx.at(-1)
			if idxRow != leader {
				header.push("")
				item.push(idxRow)
				leader = idxRow}
			header.push(idxCol)
			item.push(str.from-unicode(num))}
		else if type(num) == array {
			let (h, i) = unicode_printer_segment(num.at(0), num.at(-1))
			header.push(h)
			item.push(i)}
		else {panic("func u_char_p: Input must be int or array{int}")}}

	header = header.flatten()
	item = item.flatten()

	let rowIdxCol = ()
	let i = 0
	for chr in header {
		if chr == "" {rowIdxCol.push(i)}
		i = i + 1}

	show grid.cell: it => {
		if it.y == 0 {
			set text(black, size:13pt)
			align(center + horizon, it)}
		else if it.x in rowIdxCol {
			set text(black, size:13pt)
			align(center + bottom, it)}
		else {
			set text(blue, size:18pt)
			align(center + horizon, it)}}

	grid(columns:(1fr,)*header.len(), row-gutter:6pt,
		grid.header(..header),
		..item)}

#let emoji_supplement() = {
	unicode_printer_scatter((0x23, 0x2a, range(0x30,0x39), 0xa9, 0xae))
	unicode_printer_scatter((0x203c, 0x2049, 0x2122, 0x2139,
		range(0x2194,0x2199), range(0x21a9,0x21aa)))
	unicode_printer_scatter((0x231a, 0x231b, 0x2328, 0x23cf,
		range(0x23e9,0x23ef)))
	unicode_printer_scatter((range(0x23f0,0x23f3), range(0x23f8,0x23fa),
		0x24c2, 0x25aa, 0x25ab, 0x25b6, 0x25c0))
	unicode_printer_scatter((range(0x25fb,0x25fe), 0x2753,0x2754,0x2755,
		0x2757, 0x2763, 0x2764, range(0x2795,0x2797)))
	unicode_printer_scatter((0x27a1, 0x27b0, 0x27bf, 0x2934, 0x2935,
		range(0x2b05,0x2b07), 0x2b1b, 0x2b1c, 0x2b50, 0x2b55))
	unicode_printer_scatter((0x3030, 0x303d, 0x3297, 0x3299, 0x1f004,
		0x1f0cf, 0x1f170, 0x1f171, 0x1f17e, 0x1f17f, 0x1f18e))
	unicode_printer_scatter((range(0x1f191,0x1f19a), 0x1f201, 0x1f202,
		0x1f21a, 0x1f22f))
	unicode_printer_scatter((range(0x1f232,0x1f23a), 0x1f250, 0x1f251))
	unicode_printer_scatter((range(0x1f7e0,0x1f7eb), 0x1f7f0))}

#let compose() = {
	if sys.inputs.len() == 0 {
		emoji_supplement()  // 231a~b,2328,23f0~3,2764,2b50,...

		unicode_printer(9728, 10064)  // 2600~274f
		unicode_printer(127744, 128592)  // 1f300~1f64f
		unicode_printer(128640, 128765)  // 1f680~1f6fc
		unicode_printer(129292, 129536)  // 1f90c~1f9ff
		unicode_printer(129648, 129785)  // 1fa70~1faf8

		unicode_printer(127462, 127488)  // 1f1e6~1f1ff(A~Z)
		unicode_flags()  // AA~ZZ

		/*emoji_modifier_sequence()*/}
	else {
		for (key, value) in sys.inputs {
			unicode_printer(eval(key), eval(value))}}}

#compose()
