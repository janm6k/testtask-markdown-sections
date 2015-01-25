
I have used [markdown-js](https://github.com/evilstreak/markdown-js) instead of
[robotskirt](http://benmills.org/robotskirt/), I did not find easy way to access parsed markdown data with robotskirt.

My solution differs from the assignment, because it puts parsed markdown data into both `text` and `name` properties -
it was easier with my approach than to get the original unparsed string - that is because markdown-js does not easily
allow to convert parsed markdown data into original markdown notation.

I can redo it with different parser if that is a problem.


To try it out run the tests:

```
> npm test
```

If you want to add more testcases to see what conditions I failed to consider, just add it to `test/sections.coffee`

