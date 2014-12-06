---
title: "Project Lambda - it was worth the wait"
date: "2013-10-01 20:47"
---

Today at [GOTO Aarhus](http://gotocon.com/aarhus-2013) Brian Goetz spoke about the future of Java.
Of course I've heard about Project Lambda,
but I've been rather sceptical although there have been some talk lately hinting that they might have got some of it right.
Brian's talk today taught me two things:

1. Project Lambda is a big change. Huge.
1. They've gone to extraordinary lengths to make it feel built in and not bolted on.

As I had seen that there is an [early access download of JDK8](https://jdk8.java.net/download.html) and that [my favorite IDE](http://www.jetbrains.com/idea) already has support for lambda expressions it was an easy decision to go ahead and try it out.
I decided to start with [Project Euler problem 1](http://projecteuler.net/problem=1).
As a baseline I wrote a C-style implementation which should be fairly fast on the JVM:

```java
public long iterative(long limit) {
    long sum = 0;
    for (long i = 1; i < limit; i++) {
        if (i % 3 == 0 || i % 5 == 0) {
            sum += i;
        }
    }
    return sum;
}
```

Running this on my 2.8 GHz quad-core using 6×10<sup>9</sup> as limit takes 12.660 seconds.

The lambda support in [my IDE](http://www.jetbrains.com/idea) worked nicely,
so it didn't take me too long to come up with this:

```java
public long functional(long limit) {
    return LongStream
            .range(1, limit)
            .filter(i -> i % 3 == 0 || i % 5 == 0)
            .sum();
}
```

Run-time 15.823 seconds.
25% slowdown.
Certainly not worse than you would expect.
But wait.
There's one more thing.
Brian mentioned something in his talk;
you can switch from the default sequential stream to a parallel stream by just adding the <code>parallel()</code> method in the beginning of the chain:

```java
public long parallel(long limit) {
    return LongStream
            .range(1, limit)
            .parallel()
            .filter(i -> i % 3 == 0 || i % 5 == 0)
            .sum();
}
```

Run-time 4.401 seconds.
To get an almost linear performance improvement here is certainly impressive but not completely unexpected,
given that the problem is ridiculously simple,
but what completely blows me away is the fact that you don't need to rewrite anything at all;
it's enough to just add the extra step in the filter chain.
Contrast this with how much rewriting you would need to do to get the C-style version parallelized.

Seems that Java isn't dead after all.
