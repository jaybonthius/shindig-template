#lang pollen

◊(define-meta title     "Math showcase")

This page is a showcase of various math elements that can be used in this book. 

◊h2{The Lorentz Equations}

◊$${
    \begin{aligned} 
        \dot{x} & = \sigma(y-x) \\ \dot{y} 
                & = \rho x - y - xz \\ \dot{z} 
                & = -\beta z + xy 
    \end{aligned}
}

◊h2{The Cauchy-Schwarz Inequality}

◊$${\left( \sum_{k=1}^n a_k b_k \right)^2 \leq \left( \sum_{k=1}^n a_k^2 \right) \left( \sum_{k=1}^n b_k^2 \right)}

◊h2{A Cross Product Formula}

◊$${\mathbf{V}_1 \times \mathbf{V}_2 = \begin{vmatrix} \mathbf{i} & \mathbf{j} & \mathbf{k} \\ \frac{\partial X}{\partial u} & \frac{\partial Y}{\partial u} & 0 \\ \frac{\partial X}{\partial v} & \frac{\partial Y}{\partial v} & 0 \end{vmatrix}}

◊h2{The probability of getting ◊${k} heads when flipping ◊${n} coins}

◊$${P(E) = {n \choose k} p^k (1-p)^{ n-k}}

◊h2{An Identity of Ramanujan}

◊$${\frac{1}{\Bigl(\sqrt{\phi \sqrt{5}}-\phi\Bigr) e^{\frac25 \pi}} = 1+\frac{e^{-2\pi}} {1+\frac{e^{-4\pi}} {1+\frac{e^{-6\pi}} {1+\frac{e^{-8\pi}} {1+\ldots} } } }}

◊h2{A Rogers-Ramanujan Identity}

◊$${
    1 + \frac{q^2}{(1-q)}+\frac{q^6}{(1-q)(1-q^2)}+\cdots = \prod_{j=0}^{\infty}\frac{1}{(1-q^{5j+2})(1-q^{5j+3})}, \quad\quad \text{for $|q|<1$}
}

◊h2{Maxwell's Equations}

◊$${
    \begin{aligned} 
        \nabla \times \vec{\mathbf{B}} -\, \frac1c\, \frac{\partial\vec{\mathbf{E}}}{\partial t} & = \frac{4\pi}{c}\vec{\mathbf{j}} \\ 
        \nabla \cdot \vec{\mathbf{E}} & = 4 \pi \rho \\ \nabla \times \vec{\mathbf{E}}\, +\, \frac1c\, \frac{\partial\vec{\mathbf{B}}}{\partial t} & = \vec{\mathbf{0}} \\ 
        \nabla \cdot \vec{\mathbf{B}} & = 0 
    \end{aligned}
}


This is a numbered equation:

◊equation{
    E = mc^2
}

This is a test from the PreText page:

◊equation{
    A\xmapsto[\text{bijection}]{\Phi+\Psi+\Theta}B
}
