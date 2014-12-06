---
title: "Using requestAnimationFrame with React"
date: "2014-03-12 20:26:46 +0100"
---

The following is a small example showing how you can use
<code>requestAnimationFrame</code> in conjunction with React.
The animation is started in the <code>componentDidMount</code> hook
and stopped in <code>componentWillUnmount</code>.
The request <small>ID</small> is stored using React's state mechanism.

```javascript
var ReactRoot = React.createClass({
   getInitialState: function () {
      return {
         millis: Date.now(),
         timezoneOffset: new Date().getTimezoneOffset(),
         request: 0
      };
   },

   componentDidMount: function () {
      this.setState({
         request: requestAnimationFrame(this.tick)
      });
   },

   componentWillUnmount: function () {
      cancelAnimationFrame(this.state.request);
   },

   tick: function () {
      this.setState({
         millis: Date.now(),
         request: requestAnimationFrame(this.tick)
      });
   },

   render: function () {
      return React.DOM.div(
         {},
         Clock({
            millis: this.state.millis,
            timezoneOffset: this.state.timezoneOffset
         })
      );
   }
});
```

The <code>tick</code> function writes the current time to a state variable,
and <code>render</code> passes it,
along with the time zone offset,
down to the <code>props</code> structure of the <code>Clock</code> component:

```javascript
var Clock = React.createClass({
   getAngle: function (cycleTime) {
      return 360 * (this.getMillis() % cycleTime) / cycleTime;
   },

   getMillis: function () {
      return this.props.millis - this.props.timezoneOffset * 60000;
   },

   render: function () {
      return React.DOM.svg({
            viewBox: '-1.5 -1.5 3 3'
         },
         React.DOM.circle({
            r: 1,
            fill: 'ivory'}),
         Hand({
            length: 0.7,
            width: 0.1,
            angle: this.getAngle(12 * 60 * 60000)
         }),
         Hand({
            length: 0.9,
            width: 0.05,
            angle: this.getAngle(60 * 60000)
         }),
         Hand({
            length: 0.9,
            width: 0.01,
            angle: this.getAngle(60000)
         })
      );
   }
});
```

<code>Clock</code> in turn renders itself as SVG,
with a circle as clock face.
It calculates the angle for each clock hand and sends them
to the respective <code>Hand</code> components:

```javascript
var Hand = React.createClass({
   render: function () {
      return React.DOM.line({
         y2: -this.props.length,
         transform: 'rotate(' + this.props.angle + ')',
         strokeLinecap: 'square',
         strokeWidth: this.props.width,
         stroke: 'darkslategray'
      });
   }
});
```

In general it's a good idea to keep the state as high up in the component
hierarchy as possible.
In this example that's really easy,
because the sub-components have no event handling.

You'd like to see what it looks like?
[Go right ahead](http://clock.hersen.name)!