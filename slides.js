
const smap = [
	[ "AA-AA", "\u2500"],
	[ "AA|AA", "\u2502"],

	[ "SS+AA", "\u2510"],
	[ "AS+AS", "\u250c"],
	[ "AS+SS", "\u251c"],
	[ "SS+SA", "\u2524"],
	[ "SA+SA", "\u2518"],
	[ "AA+SS", "\u2514"],
	[ "SS+AS", "\u252c"],
	[ "SA+SS", "\u2534"],
	[ "SS+SS", "\u253c"],
];

const symap = [
	[ "|-+", "S" ],
];

function symbclass(s) {
	return symap.reduce((best, rule) => rule[0].includes(s) ? rule[1] : best, "N");
}

function findmap(str) {
	return smap.reduce((best, rule) => {
		const bestscore = best[1];
		const matches = rule[0].split("").map((c, i) => Math.max(
			c == "A" ? 1 : 0,
			c == symbclass(str[i]) ? 2 : 0,
			c == str[i] && i == 2 ? 20 : 0));

		const newscore = matches.reduce((a, b) => a + b);
		return newscore > best[1] ? [rule[1], newscore] : best;
	}, [str[2], 20])[0];
};

function asciidrawing(text) {
	let drawing = false;

	let a = text.split("\n");

	a = a.map(function(cur, i, a) {
		let p = a[i-1] || "";
		let n = a[i+1] || "";

		if (p == "```asciidrawing") {
			drawing = true;
			p = "";
		}

		const lastdraw = drawing && n == "```";
		if (lastdraw) {
			n = "";
		}

		if (drawing) {
			cur = cur.replace(/[-\+|]/g, function(c, i, s) {
				const h = s[i-1] || "X";
				const j = n[i]   || "X";
				const k = p[i]   || "X";
				const l = s[i+1] || "X";
				return findmap(h + j + c + k + l);
			});
		}

		if (lastdraw) {
			drawing = false;
		}

		return cur;
	});

	a = a.map(function(cur) {
		return cur == "```asciidrawing" ? "```" : cur;
	});

	return a.join("\n");
}

var e = document.getElementById('source');
e.textContent = asciidrawing(e.textContent);

var slideshow = remark.create();
