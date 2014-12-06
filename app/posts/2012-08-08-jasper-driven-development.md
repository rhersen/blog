---
title: "Jasper-driven development"
date: "2012-08-08 21:44"
---
How do you develop a Java-based webapp without using `mvn`?
Without `ant`?
Without `javac`?
Or even without any of them?
Of course,
you can use JRebel.
But if you don't want to shell out the money for that,
you can use scriptlets.
Remember them from the nineties?
These days,
they are the symbol of mindless spaghetti web app hacking.
But it doesn't have to be that way.
One thing I've learned during my professional life is that
you can write good code in almost any language.

All you have to do is create a new subdirectory (you can call it `myapp`) under `$TOMCAT_HOME/webapps/`,
create a file called `index.jsp` in your new subdirectory and put something like this in it:
``` html
    <html>
    <head><title>JDD</title></head>
    <% int x = Integer.parseInt(request.getParameter("x")); %>
    <body>
    <p>
        the square root of <%= x %> is <%= sqrt(x) %>
    </p>
    </body>
    </html>
    <%!
        double sqrt(double x) {
            return sqrtIter(1.0, x);
        }

        double sqrtIter(double guess, double x) {
            return isGoodEnough(guess, x) ?
                    guess :
                    sqrtIter((guess + x / guess) / 2, x);
        }

        boolean isGoodEnough(double guess, double x) {
            return Math.abs(guess * guess - x) < 0.001;
        }
    %>
```

Then you can let [Jasper](http://en.wikipedia.org/wiki/Apache_Tomcat#Jasper)
handle all the recompilation and redeployment for you:  
`10` point your browser at `http://localhost:8080/myapp?x=2`,  
`20` edit and save the <small>JSP</small> file,  
`30` reload the page in the browser and  
`40` `GOTO 20`.
