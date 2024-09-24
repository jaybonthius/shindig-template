from sympy.parsing.latex import parse_latex
from sympy.parsing.sympy_parser import (
    parse_expr,
    standard_transformations,
    implicit_multiplication,
)
from sympy import simplify, expand, factor, cancel, trigsimp, N, Symbol, Mul, Pow, Add
from sympy.parsing.latex import parse_latex_lark
from sympy.core.function import UndefinedFunction
import numpy as np
import sympy as sp


# def handle_implicit_multiplication(expr):
#     if isinstance(expr, (Symbol, int, float)):
#         return expr
#     elif isinstance(expr, UndefinedFunction):
#         # Convert f(x) to f*x if f is not a known function
#         return Mul(*[handle_implicit_multiplication(arg) for arg in expr.args])
#     elif isinstance(expr, (Mul, Add, Pow)):
#         return expr.__class__(*[handle_implicit_multiplication(arg) for arg in expr.args])
#     else:
#         # For other types (like known functions), return as is
#         return expr


def are_latex_expressions_equal(latex_expr1, latex_expr2):
    expr1 = parse_latex(latex_expr1, backend="lark")
    expr2 = parse_latex(latex_expr2, backend="lark")

    print(f"Expression 1: {expr1}")
    print(f"Expression 2: {expr2}")

    # expr1 = expr1.subs(sp.Symbol('pi'), sp.pi)
    # expr2 = expr2.subs(sp.Symbol('pi'), sp.pi)

    # if expr1.equals(expr2):
    #     return True

    # difference = expr1 - expr2
    # if difference == 0:
    #     return True

    # difference = simplify(difference)
    # if difference == 0:
    #     return True

    # difference = expand(difference)
    # if difference == 0:
    #     return True

    # difference = trigsimp(difference)
    # if difference == 0:
    #     return True

    # difference = factor(difference)
    # if difference == 0:
    #     return True

    # difference = cancel(difference)
    # if difference == 0:
    #     return True

    # difference = N(difference)
    # if difference == 0:
    #     return True

    # print(f"Expressions are not equal. Difference: {difference}")
    return False


latex1 = r"x\left(x+1\right)"
latex2 = r"x^2 + x"

print(f"Checking equality of {latex1} and {latex2}:")
result = are_latex_expressions_equal(latex1, latex2)
print(f"Expressions are equal: {result}")
