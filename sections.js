/*

I have not used CoffeeScript in a while, so I had to first write messy working solution
in JavaScript and than I rewrote it as CoffeeScript.

*/

var md = require('markdown').markdown;

module.exports = function sections(markdown) {

	var tree = md.parse(markdown);
	if (tree.length === 1) {
		return {
			sections: []
		}
	}

	var mainHeadingLevel = null,
		subsectionHeadingLevel = null,
		currentSection = null,
		mainSection = null,
		subsection = null,
		contentStart = 1,
		currentPosition = 1,
		mainSections = [];

	function closeCurrentSection() {
		if (currentPosition !== 1) {
			if (currentSection === null) { // preamble
				currentSection = {name: null};
				mainSections.push(currentSection);
			}
			// single node, place directly
			if (contentStart === currentPosition - 1) {
				currentSection.text = tree[contentStart];
			} else if (contentStart !== currentPosition) {
				currentSection.text = tree.slice(contentStart, currentPosition);
			}
		}

		contentStart = currentPosition + 1
	}

	for (; currentPosition < tree.length; currentPosition++) {
		var node = tree[currentPosition],
			level,
			headingContent;

		if (node[0] !== 'header') {
			continue; // no processing
		}

		if (currentPosition !== 1) {
		}

		if (node.length === 3 && !Array.isArray(node[2])) { // simple text as content
			headingContent = node[2];
		} else { // content is array
			headingContent = node.slice(2);
		}

		level = node[1].level;

		if (mainHeadingLevel === null || level <= mainHeadingLevel) {
			closeCurrentSection();

			mainHeadingLevel = level;
			subheadingLevel = null;
			mainSection = currentSection = {name: headingContent};
			mainSections.push(currentSection);

		} else if (subheadingLevel === null || level <= subheadingLevel) {
			closeCurrentSection();

			subheadingLevel = level;
			currentSection = {name: headingContent};
			if (!('subsections' in mainSection)) {
				mainSection.subsections = [];
			}
			mainSection.subsections.push(currentSection);
		}
	}

	closeCurrentSection();

	return {
		sections: mainSections,
	};
}
