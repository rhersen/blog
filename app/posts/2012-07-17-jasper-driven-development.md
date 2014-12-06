---
title: "JSTL sucks"
date: "2012-07-17 21:20"
---
JSTL.
The worst web technology ever invented.
To be honest I've never worked with PHP or ASP.
But they can't be worse than JSTL and its ugly cousin with the inane name "Unified Expression Language".

Why do I hate it?
Firstly, because it's ugly.
Secondly, because it's XML.
Thirdly, because it's *really* ugly.
Just look at how you write a simple if-else:

    <c:choose>
      <c:when test="${condition1}">
        ...
      </c:when>
      <c:otherwise>
        ...
      </c:otherwise>
    </c:choose>

That's eight lines of code.
Eight.
Not pretty.
But of course you can use Velocity or Freemarker instead.
They're supposedly a little bit better.
[Haml](http://haml.info/) seems nice too,
if only for the bold statement "Markup should be beautiful".
But the [Java implementation](https://github.com/raymyers/JHaml) has a pretty long list of stuff that's not yet implemented.

And suddenly it hit me.
Like the proverbial ton of bricks.
Scriptlets.
That's how it was done in the old days.
If it was good for enough for them it's good enough for me.
And don't give me any crap about business logic in the template.
That should be handled by discipline, not by syntactic shackles.
And it's perfectly possible to write business logic in JSTL too.
It's just more difficult.
And uglier.
