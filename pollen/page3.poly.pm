#lang pollen

◊(require math)

◊(define-meta title     "Page 3")

◊new-question[#:uuid "dbcf89c7-839c-424c-ba8e-048267c5e305" #:multichoice #t]{
    This is a multiple-choice question

    ◊option[#:id "1" #:correct #t]{
        Lorem ipsum dolor sit amet
    }
    ◊option[#:id "2"]{
        Lorem ipsum dolor sit amet
    }
    ◊option[#:id "3"]{
        Lorem ipsum dolor sit amet
    }
    ◊option[#:id "4" #:correct #t]{
        Lorem ipsum dolor sit amet
    }
}

◊new-question[#:uuid "33050d6d-05ff-4c6c-8b93-b84b3f8c0dcd"]{
    This is a multiple-choice question

    ◊option[#:id "1" #:correct #t]{
        Lorem ipsum dolor sit amet
    }
    ◊option[#:id "2"]{
        Lorem ipsum dolor sit amet
    }
    ◊option[#:id "3"]{
        Lorem ipsum dolor sit amet
    }
    ◊option[#:id "4"]{
        Lorem ipsum dolor sit amet
    }
}
