#lang pollen

◊(define-meta title     "Page 4")

Hey it's working????

This is a paragraph and all of the sudden ◊div{There's a random div in it, what!!!} and now here is the rest of the paragraph.

Now I'd like to reference the definition I just made: ◊ref[#:type 'definition #:uid "avg-velocity"] And this is the rest of the paragraph here. Yahoo!!

◊theorem[#:title "Second Version of FTC" #:uid "ftc-2"]{
    Suppose ◊${f(x)} is a continuous function. Then
    ◊$${
        \frac{d}{dx}\int_a^x f(t) dt = f(x)\text{.}
    }
}

And now, I'm going to reference the theorem I just made: ◊ref[#:type 'theorem #:uid "ftc-2"] And this is the rest of the paragraph here. Yahoo!!


I'm going to create a definition here:
◊definition[#:uid "avg-velocity-2" #:title "Average Velocity"]{
    For an object moving in a straight line with position function, the average velocity of the object on the interval from ◊${t=a} to ◊${t=b}, denoted ◊${AV_{[a,b]}}, is given by the formula
    ◊$${AV_{[a,b]} = \frac{s(b) - s(a)}{b - a}.}
}

And now here's a lemma 

◊lemma[#:title "1" #:uid "1"]{
    This is a lemma.
}

