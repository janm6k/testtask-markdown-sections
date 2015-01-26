Parse two levels of headers from markdown file.

It transforms this markdown:

```
# Main header

First paragraph

## Subheader

Subheader text

# Second header
```

into

```
{
	sections: [
		{
			name: 'Main header',
			text: ['para', 'First paragraph'], // markdown-js JsonMl
			subsections: [
				{
					name: 'Subheader',
					text: ['para', 'Subheader text']
				}
			]
		},
		{
			name: 'Second header'
		}
	]
}
```

Content before first header is put into "preamble" section, with `name` set to `null`.


## Run tests

To try it out run the tests:

```
> npm test
```

If you want to add more testcases to see what conditions I failed to consider, just add it to `test/sections.coffee`

