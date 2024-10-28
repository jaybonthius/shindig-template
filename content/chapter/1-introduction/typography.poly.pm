#lang pollen

◊(define-meta title     "Typography showcase")

This document demonstrates various typographic elements and their styling in a structured document. ◊ref[#:type 'theorem #:uid "ftc-2"] Each section will showcase different aspects of typography and document structure.

◊h2{Basic Text Elements}

Regular paragraphs form the foundation of any document. They should be easily readable with appropriate spacing. Sometimes we need to emphasize text using ◊em{italics} or add ◊strong{strong emphasis} to certain phrases.

Here's a simple blockquote demonstrating block-level formatting:

◊blockquote{
    Typography is the art and technique of arranging type to make written language legible, readable, and appealing when displayed.
}

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


    List item with ◊em{emphasized text}


    List item with ◊code{inline code}
}

◊h2{Code Formatting}

Code blocks should be clearly distinguished from regular text:

◊pre{
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

◊ol{
    ◊li{◊strong{Primary item}
    ◊ul{
        ◊li{Secondary item one}
        ◊li{Secondary item two}
    }
    }
    ◊li{◊strong{Another primary item}
    ◊ul{
        ◊li{More nested content}
        ◊li{Additional nested content}
    }
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

Links should be clearly visible, like this ◊a[#:href "https://example.com"]{example link}.

◊hr{}

This document ends with a horizontal rule above and a final paragraph to demonstrate spacing and margins at document close.