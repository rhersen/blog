---
title: "Clean Code with Lexical Scoping"
date: "2012-08-12 09:34"
---

A year ago I attended a Clean Code course held by Uncle Bob Martin.
He described how to write clean code like a newspaper article, by
starting the source file with high-level functions (or methods if you
wish) which call lower-level functions, which in turn call functions
on the level below themselves, and so on, until at the bottom of the
source file you'll find the lowest-level functions where the least
interesting details reside.  He called this the *stepdown rule*.

The key to this technique is to avoid mixing abstraction levels within
a single function.  Each function should only call functions at the
level below itself.

Then, suddenly, Uncle Bob frowned for a second, and said that the most
proper way of writing such code is to use lexical scoping like in
Algol 68.  In this way, each lower-level function can be declared
within the scope of a higher-level function,
and the least interesting details will be indented the most.

If you want to use lexical scoping nowadays, you can use one of the
Lisp dialects that support it, like Scheme.  Here is an example, right
out of [SICP](http://mitpress.mit.edu/sicp/):

```scheme
(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (* guess guess) x)) 0.001))
  (define (improve guess)
    (average guess (/ x guess)))
   (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))))
(sqrt-iter 1.0))
```

There are however a couple of other languages that enable you to use
lexical scoping.  Gcc extends C to allow function declarations
wherever you can declare variables (which basically means anywhere):

```c
double sqrt(double x) {
    double sqrtIter(double guess, double x) {
        double isGoodEnough(double guess, double x) {
            return fabs(guess * guess - x) < 0.001;
        }

        double improve(double guess, double x) {
            return average(guess, x / guess);
        }

        return isGoodEnough(guess, x) ? guess : sqrtIter(improve(guess, x), x);
    }

    return sqrtIter(1.0, x);
}
```

This looks fairly nice,
apart from the noise of writing <code>double</code> all over the code.

But my favorite is actually JavaScript, because you don't need to
define functions before using them, which you do in Scheme and C, and
it kind of ruins the newspaper article analogy, because the
lowest-level functions occur earlier in the code than they should.

```javascript
function sqrt(x) {
    return sqrtIter(1.0, x);

    function sqrtIter(guess, x) {
        return isGoodEnough(guess, x) ? guess : sqrtIter(improve(guess, x), x);

        function isGoodEnough(guess, x) {
            return Math.abs(guess * guess - x) < 0.001;
        }

        function improve(guess, x) {
            return average(guess, x / guess);
        }
    }
}
```

Lexical scoping is not merely about nesting functions; its real
purpose is to allow nested functions to refer to variables declared in
an outer scope.  Thus we don't need to pass <code>x</code> to the nested
functions:

```javascript
function sqrt(x) {
    return sqrtIter(1.0);

    function sqrtIter(guess) {
        return isGoodEnough(guess) ? guess : sqrtIter(improve(guess));

        function isGoodEnough(guess) {
            return Math.abs(guess * guess - x) < 0.001;
        }

        function improve(guess) {
            return average(guess, x / guess);
        }
    }
}
```

Note that taking this to extremes would mean removing the <code>guess</code>
argument from <code>isGoodEnough</code> and <code>improve</code>, but that would make the
code less readable, which is always a bad thing.