
const smap = [
	[ "..-..", "─"],
	[ "..|..", "│"],

	[ "-|+..", "┐"],
	[ ".|+.-", "┌"],
	[ ".|+|-", "├"],
	[ "-|+|.", "┤"],
	[ "-.+|.", "┘"],
	[ "..+|-", "└"],
	[ "-|+.-", "┬"],
	[ "-.+|-", "┴"],
	[ "-|+|-", "┼"],

	[ "..<.-", "\u25C0"],
	[ "-.>..", "\u25B6"],
	[ ".|^..", "\u25B2"],
	[ "..v|.", "\u25Bc"],
];

const simmap = [
	[ "+", "-|+|-" ],
	[ "v", ".|v.." ],
	[ "^", "..^|." ],
	[ "<", "-.<.." ],
	[ ">", "..>.-" ],
];

function findmap(rawstr) {
	const str = rawstr.split("").map((c, i) => {
		const m = simmap.find((x) => x[0][0] == c);
		return m ? m[1][i] : c;
	}).join('');
	return smap.reduce((best, rule) => {
		const score = rule[0].split("").map((c, i) => 
			Math.max(
				2 * (c == str[i]),
				1 * (c == '.')))
		.reduce((a, b) => a * b);
		return score <= best[1] ? best : [rule[1], score];
	}, [str[2], 1])[0];
}

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
			cur = cur.replace(/[-\+v^<>|]/g, function(c, i, s) {
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
