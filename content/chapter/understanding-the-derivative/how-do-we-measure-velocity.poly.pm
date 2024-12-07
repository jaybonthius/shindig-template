#lang pollen

◊(define-meta title     "How do we measure velocity?")

◊motivating-questions{
    How is the average velocity of a moving object connected to the values of its position function?

    
    How do we interpret the average velocity of an object geometrically on the graph of its position function?
    
    
    How is the notion of instantaneous velocity connected to average velocity?
}

Calculus can be viewed broadly as the study of change. A natural and important question to ask about any changing quantity is “how fast is the quantity changing?”

We begin with a simple problem: a ball is tossed straight up in the air. How is the ball moving? Questions like this one are central to our study of differential calculus.

◊preview-activity[#:title "Position of a ball thrown straight up" #:uid "position-of-ball-thrown-straight-up"]{
    Suppose that the height of a ball at time (in seconds) is given in feet by the formula .

    ◊numbered-list{
        Construct a graph of ◊${y = s(t)} on the time interval ◊${0 \le t \le 3}. Label at least six distinct points on the graph, including the three points showing when the ball was released, when the ball reaches its highest point, and when the ball lands.
        
        
        Describe the behavior of the ball on the time interval ◊${0 < t < 1} and on time interval ◊${1 < t < 3}. What occurs at the instant ◊${t = 1}?


        Consider the expression

        ◊$${
            \mathrm{AV}_{[0.5, 1]} = \frac{s(1) - s(0.5)}{1 - 0.5}.
        }

        Compute the value of ◊${\mathrm{AV_{[0.5, 1]}}}. What does this value measure on the graph? What does this value tell us about the motion of the ball? In particular, what are the units on ◊${\mathrm{AV_{[0.5, 1]}}}?
    }
}

◊subsection{Position and average velocity}

Any moving object has a position that can be considered a function of time. When the motion is along a straight line, the position is given by a single variable, which we denote by .
 
For example, might give the mile marker of a car traveling on a straight highway at time in hours. Similarly, the function described in ◊ref[#:type 'preview-activity #:uid "position-of-ball-thrown-straight-up"] is a position function, where position is measured vertically relative to the ground.

On any time interval, a moving object also has an average velocity. For example, to compute a car's average velocity we divide the number of miles traveled by the time elapsed, which gives the velocity in miles per hour. Similarly, the value of in ◊ref[#:type 'preview-activity #:uid "position-of-ball-thrown-straight-up"] gave the average velocity of the ball on the time interval, measured in feet per second.

In general, we make the following definition:
◊sidenote{
    Note well: the units on ◊${\mathrm{AV}_{[a,b]}} are “units of ◊${s} per unit of ◊${t},” such as “miles per hour” or “feet per second.”
}

◊definition[#:title "Average velocity"]{
    For an object moving in a straight line with position function ◊${s(t)}, the average velocity of the object on the interval from ◊${t=a} to time ◊${t=b}, denoted ◊${\mathrm{AV}_{[a,b]}} is given by the formula
    ◊$${
        \mathrm{AV}_{[a,b]} = \frac{s(b) - s(a)}{b-a}.
    }
}

◊activity[#:title "Blah" #:uid "blah"]{
    The following questions concern the position function given by ◊${s(t) = 64 - 16(t-1)^2}, considered in ◊ref[#:type 'preview-activity #:uid "position-of-ball-thrown-straight-up"].

    ◊numbered-list{
        Compute the average velocity of the ball on each of the following time intervals: ◊${[0.4, 0.8]}, ◊${[0.7, 0.8]}, ◊${[0.79, 0.8]}, ◊${[0.799, 0.8]}, ◊${[0.8, 1.2]}, ◊${[0.8, 0.9]}, ◊${[0.8, 0.81]}, ◊${[0.8, 0.801]}. Include units for each value.


        On the graph provided in Figure 1.1.1, sketch the line that passes through the points ◊${A = (0.4, s(0.4))} and ◊${B = (0.8, s(0.8))}. What is the meaning of the slope of this line? In light of this meaning, what is a geometric way to interpret each of the values computed in the preceding question?


        Use a graphing utility to plot the graph of ◊${s(t) = 64 - 16(t-1)^2} on an interval containing the value ◊${t = 0.8}. Then, zoom in repeatedly on the point ◊${(0.8, s(0.8))}. What do you observe about how the graph appears as you view it more and more closely?


        What do you conjecture is the velocity of the ball at the instant ◊${t = 0.8}? Why?

        ◊image["figure-1-1-1.png" #:width 0.45]{A partial plot of ◊${s(t) = 64 - 16(t - 1)^2}}
    }
}

◊subsection{Instantaneous Velocity}

Whether we are driving a car, riding a bike, or throwing a ball, we have an intuitive sense that a moving object has a velocity at any given moment -- a number that measures how fast the object is moving ◊emph{right now}. For instance, a car's speedometer tells the driver the car's velocity at any given instant. In fact, the velocity on a speedometer is really an average velocity that is computed over a very small time interval. If we let the time interval over which average velocity is computed become shorter and shorter, we can progress from average velocity to ◊tag{instantaneous velocity}.

Informally, we define the instantaneous velocity of a moving object at time ◊${t=a} to be the value that the average velocity approaches as we take smaller and smaller intervals of time containing ◊${t=a}. We will develop a more formal definition of instantaneous velocity soon, and this definition will be the foundation of much of our work in calculus. For now, it is fine to think of instantaneous velocity as follows: take average velocities on smaller and smaller time intervals around a specific point. If those average velocities approach a single number, then that number will be the instantaneous velocity at that point.

◊; Activity 1.1.3

At this point we have started to see a close connection between average velocity and instantaneous velocity. Each is connected not only to the physical behavior of the moving object but also to the geometric behavior of the graph of the position function. We are interested in computing average velocities on the interval ◊${[a,b]} for smaller and smaller intervals. In order to make the link between average and instantaneous velocity more formal, think of the value ◊${b} as ◊${a + h}, where ◊${h} is a small (non-zero) number that is allowed to vary. Then the average velocity of the object on the interval ◊${a, a + h} is 

◊$${
    \mathrm{AV}_{[a,a+h]} = \frac{s(a+h) - s(a)}{h}.
}

with the denominator being simply ◊${h} because ◊${(a+h) - a = h}. Note that when ◊${h < 0}, ◊${\mathrm{AV}_{[a, a+h]}} measures the average velocity on the interval ◊${[a+h, a]}.

To find the instantaneous velocity at time ◊${t=a}, we investigate what happens as the value of ◊${h} approaches 0.

◊; Example 1.1.2

◊; Activity 1.1.4

◊; TODO: make a special summary tag
◊subsection{Summary}

◊bullet-list{
    For an object moving in a straight line with position function ◊${s(t)}, the average velocity of the object on the interval from ◊${t=a} to ◊${t=b}, denoted ◊${\mathrm{AV}_{[a,b]}}, is given by the formula 

    ◊$${
        \mathrm{AV}_{[a,b]} = \frac{s(b) - s(a)}{b-a}.
    }


    The average velocity on ◊${[a,b]} can be viewed geometrically as the slope of the line between the points ◊${(a, s(a))} and ◊${(b, s(b))} on the graph of ◊${y = s(t)}, as shown in Figure 1.1.3.
    ◊; Figure 1.1.3


    Given a moving object whose position at time ◊${t} is given by a function ◊${s},  the average velocity of the object on the time interval ◊${[a,b]} is given by ◊${\mathrm{AV}_{[a,b]} = \frac{s(b) - s(a)}{b-a}}. Viewing the interval as having the form ◊${[a, a+h]}, we equivalently compute average velocity by the formula ◊${\mathrm{AV}_{[a,a+h]} = \frac{s(a+h) - s(a)}{h}}.


    The instantaneous velocity of a moving object at a fixed time is estimated by considering average velocities on shorter and shorter time intervals that contain the instant of interest.
}