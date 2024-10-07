- multiple choice: mc
- free response: fr
- true/false: tf
- matching: mat
- ordering/sequencing: ord



# Pollen markup

```clojure
◊fr-container[#:uid "0J2wX6Wuwp5vIIW_H0WTZ"]{
    What's the square-root of 9?
    ◊fr-field[#:uid "APUbroK3gLBO6WEPqBYvD" #:answer "3"]{}

    Simplify the following fraction:
    ◊fr-field[#:uid "8dZyR_-8HQPlPCaen8Koj" #:placeholders (hash-ref "numerator" "5" "denominator" "4")]{
        \frac{15}{12} = \frac{\placeholder[numerator]{?}}{\placeholder[denominator]{?}}
    }
}
```
