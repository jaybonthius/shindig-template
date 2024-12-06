#lang pollen

◊(define-meta title     "Typography showcase")

This document demonstrates various typographic elements and their styling in a structured document. Each section will showcase different aspects of typography and document structure.

This is a tag: ◊tag{integral}.

This is a manual tag: ◊tag[#:entry "derivative"]{derivatives}.

This is a manual tag with subentry: ◊tag[#:entry "theorems" #:subentry "Central Limit Theorem"]{CLT}.

This is the same tag, but with no subentry: ◊tag[#:entry "theorems"]{blah}.

This is a duplicated tag: ◊tag[#:entry "integral"]{integrals, baby!}.

◊h2{Basic Text Elements}

Regular paragraphs form the foundation of any document. They should be easily readable with appropriate spacing. Sometimes we need to emphasize text using ◊emph{italics} or add ◊strong{strong emphasis} to certain phrases.

Here's a simple blockquote demonstrating block-level formatting: 

◊h2{Figures}

Figures are an important part of any document. They should be clearly labeled and referenced in the text. Here's an example:

◊; ◊image["frogu-original.png"]{This is a placeholder image.}

◊youtube-iframe["https://youtu.be/SXOHCiukZPw?si=VegHYqE-JDLm5nAy"]

◊h2{Geogebra}

◊geogebra["d66jmqv2"]{blah}

◊iframe["https://www.xkcd.com"]

◊sage-cell{
# This is a simple example of a Sage cell
plot(sin(x), (x, 0, 2*pi))
}

Blah

◊blockquote{
    Typography is the art and technique of arranging type to make written language legible, readable, and appealing when displayed.
}

◊h2{Sidenotes}

Sidenotes are a useful way to provide additional context or information without interrupting the main flow of text. ◊sidenote{This is a sidenote. It provides additional information related to the main text.} They should be clearly distinguished from regular text.

◊h2{Lists and Structure}

Lists help organize information in a clear hierarchy. Here are some examples:

◊numbered-list{
    First ordered item!


    Second ordered item


    Third ordered item with longer text to demonstrate wrap behavior
}

Unordered lists are equally important:

◊bullet-list{
    Basic list item


    List item with ◊emph{emphasized text}


    List item with ◊code{inline code}
}

◊h2{Code Formatting}

Code blocks should be clearly distinguished from regular text:

◊code-block{
function example() {
    return {
        title: "Typography Demo",
        author: "Documentation Team",
        date: new Date()
    };
}
}

◊h3{Nested Structures}

Complex documents often require nested elements:

◊numbered-list{
    Primary item
    ◊bullet-list{
        Secondary item one


        Secondary item two
    }


    Another primary item
    ◊bullet-list{
        More nested content


        Additional nested content
    }
}

◊h2{Tables}

Tables should be clear and well-formatted:

◊quick-table{
heading left | heading center | heading right
upper left   | upper center   | upper right
lower left   | lower center   | lower right
}

◊h3{Additional Elements}

Links should be clearly visible, like this ◊link["https://example.com"]{example link}.

◊; ◊hr{}

◊; This document ends with a horizontal rule above and a final paragraph to demonstrate spacing and margins at document close.