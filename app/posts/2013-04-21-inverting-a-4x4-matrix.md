---
title: "Inverting a 4×4 matrix"
date: "2013-04-24 14:29"
---

During the past few weeks I've been working on writing a small WebGL
program without any dependencies. The examples I found on the web
were long-winded and loaded with dependencies, so I cloned
[one of them](https://developer.mozilla.org/en-US/docs/WebGL/Lighting_in_WebGL),
trimmed it down to size and removed all dependencies.

I removed loads of dead code so that only the necessary stuff
remained. One thing that I had to keep was that the shader
must be fed with a normal matrix, which it uses to transform the
normals so that they are correct with respect to the current
orientation of the rendered object. The normal matrix is the result
of inverting and transposing the model-view matrix. One of these
operations is computationally trivial, but the other, inverting
a matrix, is not.

There are a few nicely optimized algorithms for doing this. The one I
started out with was an LU decomposition algorithm (at least that's
what I think it is) which can be found in the
[sylvester](https://github.com/jcoglan/sylvester) library.

``` javascript
// Copyright (c) 2007-2013 James Coglan
function inverse(elements) {
    function toRightTriangular(elements) {
        var M = elements.slice(), els;
        var n = elements.length, i, j, np = elements[0].length, p;
        for (i = 0; i < n; i++) {
            if (M[i][i] === 0) {
                for (j = i + 1; j < n; j++) {
                    if (M[j][i] !== 0) {
                        els = [];
                        for (p = 0; p < np; p++) {
                            els.push(M[i][p] + M[j][p]);
                        }
                        M[i] = els;
                        break;
                    }
                }
            }
            if (M[i][i] !== 0) {
                for (j = i + 1; j < n; j++) {
                    var multiplier = M[j][i] / M[i][i];
                    els = [];
                    for (p = 0; p < np; p++) {
                        // Elements with column numbers up to an including the number of the
                        // row that we're subtracting can safely be set straight to zero,
                        // since that's the point of this routine and it avoids having to
                        // loop over and correct rounding errors later
                        els.push(p <= i ? 0 : M[j][p] - M[i][p] * multiplier);
                    }
                    M[j] = els;
                }
            }
        }
        return M;
    }

    function augment(elements, matrix) {
        var T = elements.slice(), cols = T[0].length;
        var i = T.length, nj = matrix[0].length, j;
        while (i--) {
            j = nj;
            while (j--) {
                T[i][cols + j] = matrix[i][j];
            }
        }
        return T;
    }

    var n = elements.length, i = n, j;
    var M = toRightTriangular(augment(elements, [
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1]
    ]));
    var np = M[0].length, p, els, divisor;
    var inverse_elements = [], new_element;
    // Sylvester.Matrix is non-singular so there will be no zeros on the
    // diagonal. Cycle through rows from last to first.
    while (i--) {
        // First, normalise diagonal elements to 1
        els = [];
        inverse_elements[i] = [];
        divisor = M[i][i];
        for (p = 0; p < np; p++) {
            new_element = M[i][p] / divisor;
            els.push(new_element);
            // Shuffle off the current row of the right hand side into the results
            // array as it will not be modified by later runs through this loop
            if (p >= n) {
                inverse_elements[i].push(new_element);
            }
        }
        M[i] = els;
        // Then, subtract this row from those above it to give the identity matrix
        // on the left hand side
        j = i;
        while (j--) {
            els = [];
            for (p = 0; p < np; p++) {
                els.push(M[j][p] - M[i][p] * M[j][i]);
            }
            M[j] = els;
        }
    }
    return inverse_elements;
}
```

I refactored it a bit to try to understand it,
but I didn't get very far,
so I decided to look for something simpler,
if there is such a thing as a simple algorithm for inverting a matrix.
Turns out there is.
I found it in an Intel
["application note"](http://www.intel.com/design/pentiumiii/sml/245043.htm)
from 1999.
It's called Cramer's Rule.
Intel's code is not very DRY (look for yourself if you don't believe me),
so I refactored it and ended up with this:

``` javascript
var invert = (function () {
    function getColumn(n) {
        return n % 4;
    }

    function getRow(n) {
        return (n - getColumn(n)) / 4;
    }

    function getSign(n) {
        return getRow(n) % 2 === getColumn(n) % 2 ? 1 : -1;
    }

    function getIndices(n) {
        var indices = [];
        for (var i = 0; i < 16; i++) {
            if (!(getColumn(i) === getColumn(n) || getRow(i) === getRow(n))) {
                indices.push(i);
            }
        }
        return indices;
    }

    var indices = [];
    var sign = [];
    for (var i = 0; i < 16; i++) {
        indices.push(getIndices(i));
        sign.push(getSign(i));
    }

    return function (flat) {
        function cramer(mat) {
            function cofactors(src, i) {
                function cofactor(j) {
                    return src[i[j[0]]] * src[i[j[1]]] * src[i[j[2]]];
                }

                return cofactor([0, 4, 8]) + cofactor([1, 5, 6]) + cofactor([2, 3, 7]) -
                    cofactor([0, 5, 7]) - cofactor([1, 3, 8]) - cofactor([2, 4, 6]);
            }

            function adjoint(n) {
                return sign[n] * cofactors(src, indices[n]);
            }

            var src = transpose(mat);

            var dst = new Array(16);
            for (var i = 0; i < 16; i++) {
                dst[i] = adjoint(i);
            }

            var det = 0;
            for (var n = 0; n < 4; n++) {
                det += src[n] * dst[n];
            }

            for (var j = 0; j < dst.length; j++) {
                dst[j] /= det;
            }

            return dst;
        }

        timer.start();
        var r = cramer(flat);
        timer.stop();
        return r;
    };
})();
```

I've run some benchmarks on my i7 3840QM running OS X. The LU
decomposition algorithm has a median run time of 22 microseconds, both
in Firefox 20 and in Chrome. The Cramer's algorithm, which by the way
is O(n³), takes 23 microseconds on Firefox and 12 microseconds on
Chrome. This shows that the seemingly stupid but simple algorithm
actually is almost 50% faster in Chrome, and roughly the same speed as
the smart one in Firefox. It should of course be noted that the
problem size is relatively small (4×4 matrices), and the complexity of
LU decomposition algorithm has a lower exponent (somewhere around 2.5
according to Wikipedia), so it will probably be faster for larger
matrices. But then again I'm doing WebGL, so I'm only interested in
4×4 matrices.

*Next week on this blog: Writing Javascript in C-style or in functional style.*
