import sympy as sp
from lark import Tree
from sympy import (
    Add,
    Eq,
    Mul,
    N,
    Pow,
    Symbol,
    cancel,
    expand,
    factor,
    simplify,
    sympify,
    trigsimp,
)
from sympy.parsing.latex import parse_latex


def tree_to_sympy(tree):
    if isinstance(tree, Tree):
        if tree.data == "_ambig":
            return tree.children
        else:
            return sympify(
                " ".join(str(tree_to_sympy(child)) for child in tree.children)
            )
    else:
        return [tree]


def parse_and_simplify(latex_expr):
    parsed = parse_latex(latex_expr, backend="lark")
    sympy_expr = tree_to_sympy(parsed)
    return sympy_expr


TOLERANCE = 1e-6


def are_latex_expressions_equal(expr1, expr2):
    expr1 = expr1.subs(sp.Symbol("pi"), sp.pi)
    expr2 = expr2.subs(sp.Symbol("pi"), sp.pi)

    if expr1.equals(expr2):
        return True

    difference = expr1 - expr2
    if difference == 0:
        return True

    difference = simplify(difference)
    if difference == 0:
        return True

    difference = expand(difference)
    if difference == 0:
        return True

    difference = trigsimp(difference)
    if difference == 0:
        return True

    difference = factor(difference)
    if difference == 0:
        return True

    difference = cancel(difference)
    if difference == 0:
        return True

    difference = N(difference)
    if difference == 0:
        return True

    return False


def check_if_latex_is_equal(latex_expr1, latex_expr2):
    expressions_1 = parse_and_simplify(latex_expr1)
    expressions_2 = parse_and_simplify(latex_expr2)

    for expr1 in expressions_1:
        for expr2 in expressions_2:
            if are_latex_expressions_equal(expr1, expr2):
                print(f"Expressions are equal: {expr1} == {expr2}")
                return True
    print("Expressions are not equal")
    return False


latex_1 = r"x(x+1) + \sin^2(x) + \cos^2(x)"
latex_2 = r"x^2 + x + 1 + \sin(0)"
check_if_latex_is_equal(latex_1, latex_2)


latex_1 = r"\frac{3}{4}"
latex_2 = r"\frac{6^2}{12*4}"
check_if_latex_is_equal(latex_1, latex_2)
