---
title: "Lo-Dash: Basic Higher-Order Functions"
date: "2015-01-05 22:24:26 +0100"
---

This is the first post in a series about the [Lo-Dash](https://lodash.com/) utility library.
Let's start with some motivation:
If you look into your codebase and find code like this
(and I would not be too surprised if you do)
you should definitely consider introducing a collection library to reduce the code noise level.

```javascript
var result = [];
for (var i = 0; i < array.length; i++) {
    var obj = array[i];
    if (isRelevant(obj)) {
        result[i] = transform(obj);
    }
}
return result;
```

The tools we need to improve this are _higher-order functions_,
which are functions that take other functions as parameters.
The most basic higher-order functions are
<code>forEach</code>,
<code>filter</code>,
<code>map</code>
and
<code>reduce</code>.
Of these,
<code>forEach</code> is too simple for our purposes (it's just used for extracting the loop body)
and <code>reduce</code> is too powerful (it can basically be used to implement any higher-order function).

Going back to the example above,
we can use the remaining two functions for improving our code:
The <code>if</code> statement can be replaced by <code>filter</code>
and the assignment can be replaced by <code>map</code>.
The example will then boil down to this much simpler version:

```javascript
var relevant = _.filter(array, isRelevant);
var result = _.map(relevant, transform);
return result;
```

Note that the functions
<code>isRelevant</code> and <code>transform</code>
that were originally called explicitly are now sent as parameters to
<code>filter</code> and <code>map</code>,
so these are by definition higher-order functions.

We should of course take our simplification one step further and inline the variables in our example:

```javascript
return _.map(_.filter(array, isRelevant), transform);
```

I have chosen the underscore/lodash syntax for this code because these libraries are so much more
powerful than vanilla Javascript,
and because I intend to write a whole lot more about them,
but for this simple example we can make do with the builtin methods of Javascript <code>Array</code> objects:

```javascript
return array.filter(isRelevant).map(transform);
```