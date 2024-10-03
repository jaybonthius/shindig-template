#lang pollen

☉(require math)

☉(define-meta title     "Page 3")

☉new-question[#:uuid "dbcf89c7-839c-424c-ba8e-048267c5e305" #:multichoice #t]{
    This is a multiple-choice question

    ☉option[#:id "1" #:correct #t]{
        Lorem ipsum dolor sit amet
    }
    ☉option[#:id "2"]{
        Lorem ipsum dolor sit amet
    }
    ☉option[#:id "3"]{
        Lorem ipsum dolor sit amet
    }
    ☉option[#:id "4" #:correct #t]{
        Lorem ipsum dolor sit amet
    }
}

☉free-response[#:uid "d5902827-5929-4347-a6b3-21499a5ecd03"]{
    What is the square-root of 9?

    ☉fr-field[#:uid "zZWCtZ7J3FGeC7l2awieT" #:answer "3"]{}

    And here is more content

    ☉fr-field[#:uid "__T1P_BblhsXJSHHsRMzP" #:answer "7"]{}
    
    And here is even more!
}

This is other information.

☉span[#:class "text-red-500"]{This should be red}
