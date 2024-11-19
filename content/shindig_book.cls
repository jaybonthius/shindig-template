\NeedsTeXFormat{LaTeX2e}
\ProvidesFile{shindig_book.cls}[2020/03/24 v1.00a Shindig book]
\RequirePackage{amsmath}% better math handling
\RequirePackage{amssymb}% better math symbols
\LoadClassWithOptions{book}% this is derived from the book class
\RequirePackage{sidenotes}% put annotations, tables and figures in the margin
\captionsetup{font=footnotesize, skip=4pt}
\RequirePackage[maxfloats=45]{morefloats}% a lot of marginals need more float 'memory'
\RequirePackage{marginfix}% automatically adjust the side-floats nicely 
\newcommand{\shindig@letterspace}[1]{#1}% allow LuaLaTeX, LaTeX letterspacing
\RequirePackage{microtype}% microtypography
\RequirePackage{threeparttable}
\RequirePackage{enumitem}
\RequirePackage{caption}
\RequirePackage{xcolor}
\RequirePackage{array}

\RequirePackage{geometry}
\geometry{
  left=60pt, % this controls both side margins
  top=60pt, 
  bottom=60pt,
  textwidth=320pt, 
  % marginparsep=20pt, 
  % marginparwidth=100pt, 
  footskip=40pt,
  letterpaper
}
\RequirePackage{parskip}  % Added this package
\setlength{\parindent}{0pt}  % Remove paragraph indentation
\setlength{\parskip}{1em}    % Add space between paragraphs

\IfFileExists{mathpazo.sty}{\RequirePackage[osf,sc]{mathpazo}}{}% palatino clone for math
\IfFileExists{helvet.sty}{\RequirePackage[scaled=0.90]{helvet}}{}% helvetica is sans serif font
\IfFileExists{beramono.sty}{\RequirePackage[scaled=0.85]{beramono}}{}% beramono is tt font
\RequirePackage[T1]{fontenc}% finally load fontenc

\newcommand{\maketitlepage}{%
  \maketitle
  \thispagestyle{empty}
  \clearpage
  \pagestyle{plain}
}

% Table styling
\RequirePackage{booktabs}
\RequirePackage{threeparttable}
\renewcommand{\arraystretch}{1.2}
\newcolumntype{C}[1]{>{\centering\arraybackslash}p{#1}}

% Custom quote environment
\RequirePackage{quoting}
\quotingsetup{
    font=itshape,
    leftmargin=2em,
    rightmargin=2em,
    vskip=1em
}

% Load tcolorbox and its required libraries
\RequirePackage[many]{tcolorbox}
\tcbuselibrary{breakable,skins,theorems}

% Define tcolorbox styles
\tcbset{
  theorem/.style={
    enhanced,
    colback=blue!5,
    colframe=blue!75!black,
    fonttitle=\bfseries,
    attach boxed title to top left={yshift=-2mm},
    boxed title style={colback=blue!75!black, coltext=white},
    separator sign={.}
  },
  definition/.style={
    enhanced,
    colback=green!5,
    colframe=green!75!black,
    fonttitle=\bfseries,
    attach boxed title to top left={yshift=-2mm},
    boxed title style={colback=green!75!black, coltext=white},
    separator sign={.}
  },
  lemma/.style={
    enhanced,
    colback=red!5,
    colframe=red!75!black,
    fonttitle=\bfseries,
    attach boxed title to top left={yshift=-2mm},
    boxed title style={colback=red!75!black, coltext=white},
    separator sign={.}
  },
  codebox/.style={
    enhanced,
    breakable,
    colback=gray!5,
    colframe=gray!50!black,
    boxrule=0.5pt,
    arc=0pt,
    outer arc=0pt,
    left=5mm,
    right=5mm,
    top=2mm,
    bottom=2mm
  },
  quotebox/.style={
    enhanced,
    breakable,
    colback=white,
    colframe=gray!30,
    boxrule=0.4pt,
    left=10pt,
    right=10pt,
    top=6pt,
    bottom=6pt
  }
}

% Redefine environments
\RequirePackage{fvextra}  % Enhanced version of fancyvrb
\fvset{
    fontsize=\small,
    frame=single,
    numbers=left,
    breaklines=true,
    framesep=3mm,
    baselinestretch=1,
    commandchars=\\\{\}
}

\renewenvironment{quote}{%
  \begin{tcolorbox}[quotebox]%
}{%
  \end{tcolorbox}%
}

% List styling
\setlist[enumerate]{
  leftmargin=*,
  itemsep=0.5em,
  topsep=0.5em,
  parsep=0pt
}

\setlist[itemize]{
  leftmargin=*,
  itemsep=0.5em,
  topsep=0.5em,
  parsep=0pt
}

% Table styling
\renewcommand{\arraystretch}{1.2}
\newcolumntype{C}[1]{>{\centering\arraybackslash}p{#1}}

% Load hyperref last
\RequirePackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=blue!70!black,
    urlcolor=blue!70!black,
    citecolor=green!50!black,
    breaklinks=true
}

\endinput