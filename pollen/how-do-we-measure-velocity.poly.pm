#lang pollen

◊(define-meta title "How do we measure velocity?")
◊(define-meta section "1.1")

◊motivating-questions{
    How is the average velocity of a moving object connected to the values of its position function?

    How do we interpret the average velocity of an object geometrically on the graph of its position function?
    
    How is the notion of instantaneous velocity connected to average velocity?
}

Calculus can be viewed broadly as the study of change. A natural and important question to ask about any changing quantity is “how fast is the quantity changing?”

We begin with a simple problem: a ball is tossed straight up in the air. How is the ball moving? Questions like this one are central to our study of differential calculus.

◊preview-activity[#:name "1.1"]{
    This is a preview actviity! Wahooo!!
}

◊section{Position and average velocity}

Any moving object has a ◊index{position} that can be considered a function of ◊emph{time}. When the motion is along a straight line, the position is given by a single variable, which we denote by ◊${s(t)}.

For example, ◊${s(t)} might give the mile marker of a car traveling on a straight highway at time ◊${t} in hours. Similarly, the function ◊${s} described in ◊xref[#:type 'preview-activity #:uid "1.1"]{} is a position function, where position is measured vertically relative to the ground.

In general, we make the following definition:

◊definition[#:name "Average Velocity"]{
    For an object moving in a straight line with position function, the average velocity of the object on the interval from ◊${t=a} to ◊${t=b}, denoted ◊${AV_{[a,b]}}, is given by the formula

    ◊$${AV_{[a,b]} = \frac{s(b) - s(a)}{b - a}.}
}