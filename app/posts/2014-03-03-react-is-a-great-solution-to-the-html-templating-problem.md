---
title: "React is a great solution to the HTML templating problem"
date: "2014-03-03 20:16:37 +0100"
---

Fifteen years ago Sun unleashed JSP on the world.
It was soon augmented with semi-languages like EL and JSTL.
Languages with cumbersome syntax and limited power.
Since then people have invented new templating languages by the truckload.
Syntax have improved in some cases,
but our hands are still tied by the limited power of these almost-languages.

Enter React.

React enables us to define our HTML as composable components.  And we
get the full power of JavaScript at our fingertips, like in this
example where higher order functions are used to generate the table:

```javascript
function range(n) {
   return Array.apply(null, Array(n)).map(function (el, i) {
      return i;
   });
}

var MultiplicationTable = React.createClass({
   render: function () {
      return React.DOM.section(null, range(12).map(getRow));

      function getRow(i) {
         return React.DOM.div(null, range(12).map(times(i)).map(getCell));
      }

      function getCell(content) {
         return React.DOM.span(null, content);
      }

      function times(i) {
         return function (j) {
            return i * j;
         };
      }
   }
});
```

And this can be refactored to show how to compose React components:

```javascript
function range(n) {
   return Array.apply(null, Array(n)).map(function (el, i) {
      return i;
   });
}

var MultiplicationTable = React.createClass({
   render: function () {
      return React.DOM.section(null, range(12).map(getRow));

      function getRow(i) {
         return TableRow({i: i});
      }
   }
});

var TableRow = React.createClass({
   render: function () {
      return React.DOM.div(null, range(12).map(times(this.props.i)).map(getCell));

      function getCell(content) {
         return React.DOM.span(null, content);
      }

      function times(i) {
         return function (j) {
            return i * j;
         };
      }
   }
});
```

Here we can also see how data is passed down the component tree;
<code>i</code> is sent to the constructor function of <code>TableRow</code>,
and it's picked up in <code>this.props</code> in the subcomponent.
