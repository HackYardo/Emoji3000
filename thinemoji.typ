#set par(spacing:8pt)
#set text(blue)
#set grid(
	align: (x, y) => (
		if x == 0 {left + bottom}
		else {center + horizon}))
#show grid.cell: it => {
	if it.x == 0 or it.y == 0 {
		set text(size:13pt)
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

#let compose() = {
	if sys.inputs.len() == 0 {
		line(length:100%)
		unicode_printer(9728, 10064)  // 2600~274f
		line(length:100%)
		unicode_printer(61398, 62177)  // efd6~f2e0
		line(length:100%)
		unicode_printer(127744, 128765)  // 1f300~1f6fc
		line(length:100%)
		unicode_printer(129292, 129785)}  // 1f90c~1faf8
	else {
		for (key, value) in sys.inputs {
			line(length:100%)
			unicode_printer(eval(key), eval(value))}}}

#compose()
