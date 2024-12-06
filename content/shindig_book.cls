\NeedsTeXFormat{LaTeX2e}
\ProvidesFile{shindig_book.cls}[2020/03/24 v1.00a Shindig book]
% Load the amsmath package before loading microtype
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
\RequirePackage{listings}
\RequirePackage{makeidx}
\renewcommand{\shindig@letterspace}[1]{\textls{#1}}
%
% Set page layout geometry
%
\RequirePackage{geometry}
\geometry{
  left=60pt, % this controls both side margins
  top=60pt, 
  bottom=60pt,
  textwidth=320pt, 
  marginparsep=20pt, 
  marginparwidth=152pt, 
  footskip=40pt,
  letterpaper
}
\RequirePackage{parskip}  % Added this package
\setlength{\parindent}{0pt}  % Remove paragraph indentation
\setlength{\parskip}{1em}    % Add space between paragraphs

%
% fontsize
%
\renewcommand{\normalsize}{\fontsize{12pt}{15pt}\selectfont}%
\renewcommand{\footnotesize}{\fontsize{10pt}{12pt}\selectfont}%
% fullwidth environment, text across textwidth+marginparsep+marginparwidth
\newlength{\overhang}
\setlength{\overhang}{\marginparwidth}
\addtolength{\overhang}{\marginparsep}
%
\newenvironment{fullwidth}
  {\ifthenelse{\boolean{@twoside}}%
     {\begin{adjustwidth*}{}{-\overhang}}%
     {\begin{adjustwidth}{}{-\overhang}}%
  }%
  {\ifthenelse{\boolean{@twoside}}%
    {\end{adjustwidth*}}%
    {\end{adjustwidth}}%
  }

% set up the fonts
\IfFileExists{mathpazo.sty}{\RequirePackage[osf,sc]{mathpazo}}{}% palatino clone for math
\IfFileExists{helvet.sty}{\RequirePackage[scaled=0.90]{helvet}}{}% helvetica is sans serif font
\IfFileExists{beramono.sty}{\RequirePackage[scaled=0.85]{beramono}}{}% beramono is tt font
\RequirePackage[T1]{fontenc}% finally load fontenc

\RequirePackage{titlesec,titletoc}% load the helper package
\RequirePackage{ragged2e} % \RaggedRight works better than \raggedright
\newcommand{\marginparstyle}{\footnotesize\RaggedRight} % initialize style with start value
\long\def\@ympar#1{% redefine margin par to avoid too many macros in the document
  \@savemarbox\@marbox{\marginparstyle#1}% marginparstyle is a prefix to the marginpar text now
  \global\setbox\@currbox\copy\@marbox % the rest of the definition is taken from original LaTeX
  \@xympar}
\renewcommand*{\marginfont}{\marginparstyle}
% setup itemize and enumerate  
\RequirePackage{enumitem}
\setlist[itemize]{leftmargin=*}

% titlepage
\newcommand{\maketitlepage}{%
  \maketitle
  \thispagestyle{empty}
  \clearpage
  \pagestyle{plain}
}
\newcommand\newthought[1]{%
   \addvspace{1.0\baselineskip plus 0.5ex minus 0.2ex}%
   \noindent\textsc{#1}%
}%
\ExplSyntaxOn
\NewDocumentCommand \sidecite { o o m }
{ 
  \IfNoValueOrEmptyTF{#1}
  {
    \IfNoValueOrEmptyTF{#2}
    {
      \sidenote{\fullcite{#3}}
    }
    {
      \sidenote{\fullcite[#2]{#3}}
    }
  }
  {
    \IfNoValueOrEmptyTF{#2}
    {
      \sidenote{\fullcite[#1]{#3}}
    }
    {
      \sidenote{\fullcite[#1][#2]{#3}}
    }
  }
}
\ExplSyntaxOff

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
\tcbuselibrary{breakable,skins,theorems,listings}

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

% Define clean, modern colors
\definecolor{pythonblue}{RGB}{32,128,180}
\definecolor{pythongreen}{RGB}{64,128,128}
\definecolor{pythonstring}{RGB}{206,145,120}
\definecolor{pythongray}{RGB}{128,128,128}
\definecolor{codebg}{RGB}{250,250,250}

% Basic listing style setup
\lstset{
    language=Python,
    basicstyle=\ttfamily\normalsize,
    backgroundcolor=\color{codebg},
    breaklines=true,
    breakatwhitespace=true,
    showspaces=false,
    showstringspaces=false,
    numberstyle=\small\color{pythongray},
    numbers=left,
    numbersep=15pt,
    frame=l,
    framesep=8pt,
    framerule=2pt,
    xleftmargin=20pt,
    rulecolor=\color{pythongray!40},
    commentstyle=\color{pythongreen},
    keywordstyle=\color{pythonblue},
    stringstyle=\color{pythonstring},
    morekeywords={self,def,class,return,yield,lambda,try,except,finally,raise,with,as}
}

% Simple tcolorbox wrapper
\newtcblisting{pythoncode}[1][]{
    listing only,
    breakable,
    enhanced,
    colback=codebg,
    boxrule=0pt,
    left=2mm,
    right=2mm,
    top=2mm,
    bottom=2mm,
    #1
}