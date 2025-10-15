#set par(spacing:8pt)
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
	let v = ("[]",)

	for i in r {v.push("[\u{" + i + "}]")}  // header
	for m in r {v.push("[\u{" + m + "}]")  // leader
		for n in r {v.push("[\u{" + m + "}\u{" + n + "}]")}}

	grid(columns:(1fr,)*27, row-gutter:2pt,
		..v.map(eval).map(resize))}

#let compose() = {
	if sys.inputs.len() == 0 {
		unicode_printer(9728, 10064)  // 2600~274f
		unicode_printer(61398, 62177)  // efd6~f2e0
		unicode_printer(127744, 128592)  // 1f300~1f64f
		unicode_printer(128640, 128765)  // 1f680~1f6fc
		unicode_printer(129292, 129536)  // 1f90c~1f9ff
		unicode_printer(129648, 129785)  // 1fa70~1faf8
		unicode_printer(127462, 127488)  // 1f1e6~1f1ff
		unicode_flags()}
	else {
		for (key, value) in sys.inputs {
			unicode_printer(eval(key), eval(value))}}}

#compose()
