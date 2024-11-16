\NeedsTeXFormat{LaTeX2e}
\ProvidesFile{shindig_book.cls}[2020/03/24 v1.00a Shindig book]
% Load the amsmath and the mhchem package before loading microtype
\RequirePackage{amsmath}% better math handling
\LoadClassWithOptions{book}% this is derived from the book class
\RequirePackage{sidenotes}% put annotations, tables and figures in the margin
\captionsetup{font=footnotesize, skip=4pt}
\RequirePackage[maxfloats=45]{morefloats}% a lot of marginals need more float 'memory'
\RequirePackage{marginfix}% automatically adjust the side-floats nicely 
\newcommand{\shindig@letterspace}[1]{#1}% allow LuaLaTeX, LaTeX letterspacing
\RequirePackage{microtype}% microtypography
%
% Set page layout geometry -- default is science-book format
% this means a (portrait) paper size of 170mm x 240mm
%
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
% \renewcommand{\normalsize}{\fontsize{11pt}{14pt}\selectfont}%
% \renewcommand{\footnotesize}{\fontsize{8pt}{10pt}\selectfont}%
% % fullwidth environment, text across textwidth+marginparsep+marginparwidth
% \newlength{\overhang}
% \setlength{\overhang}{\marginparwidth}
% \addtolength{\overhang}{\marginparsep}
% \newenvironment{fullwidth}
%   {\ifthenelse{\boolean{@twoside}}%
%      {\begin{adjustwidth*}{}{-\overhang}}%
%      {\begin{adjustwidth}{}{-\overhang}}%
%   }%
%   {\ifthenelse{\boolean{@twoside}}%
%     {\end{adjustwidth*}}%
%     {\end{adjustwidth}}%
%   }
% \IfFileExists{mathpazo.sty}{\RequirePackage[osf,sc]{mathpazo}}{}% palatino clone for math
% \IfFileExists{helvet.sty}{\RequirePackage[scaled=0.90]{helvet}}{}% helvetica is sans serif font
% \IfFileExists{beramono.sty}{\RequirePackage[scaled=0.85]{beramono}}{}% beramono is tt font
% \RequirePackage[T1]{fontenc}% finally load fontenc
% % nice headings and TOC
% \RequirePackage{titlesec,titletoc}% load the helper package
% \setcounter{secnumdepth}{2}
% \titleformat{\chapter}[display]{\relax\itshape\huge}{}{0pt}{\huge\rmfamily\itshape}[]
% \titleformat{\section}[hang]{\normalfont\Large\itshape}{}{0pt}{}[]
% \titleformat{\subsection}[hang]{\normalfont\large\itshape}{}{1em}{}[]
% \titleformat{\paragraph}[runin]{\normalfont\itshape}{}{1em}{}[]
% \renewcommand*\descriptionlabel[1]{\hspace\labelsep\normalfont\em #1}% italic description instead of bold)

% \RequirePackage{ragged2e} % \RaggedRight works better than \raggedright
% \newcommand{\marginparstyle}{\footnotesize\RaggedRight} % initialize style with start value
% \long\def\@ympar#1{% redefine margin par to avoid too many macros in the document
%   \@savemarbox\@marbox{\marginparstyle#1}% marginparstyle is a prefix to the marginpar text now
%   \global\setbox\@currbox\copy\@marbox % the rest of the definition is taken from original LaTeX
%   \@xympar}
% \renewcommand*{\marginfont}{\marginparstyle}
% % setup itemize and enumerate  
% \RequirePackage{enumitem}
% \setlist[itemize]{leftmargin=*}
% %\renewcommand{\labelitemi}{}
% % compatibility with T-L
% %
% % titlepage
% \RequirePackage{ifthen}
% \RequirePackage{textcase} % provides \MakeTextUppercase and \MakeTextLowercase
% \RequirePackage{color} % the title is too black, define gray
% \definecolor{darkgray}{rgb}{0.25,0.25,0.25}
% \newcommand{\maketitlepage}{%
%   \maketitle
%   \thispagestyle{empty}% Makes the title page unnumbered
%   \cleardoublepage
%   \thispagestyle{empty}% Makes the blank verso page unnumbered too
%   \clearpage
%   \pagestyle{plain}% Reset to normal page numbering
%   \thispagestyle{plain}% FORCE the next page to have a number
% }
\newcommand{\maketitlepage}{%
  \maketitle
  \thispagestyle{empty}
  \clearpage
  \pagestyle{plain}
}
% \ExplSyntaxOn
% \NewDocumentCommand \sidecite { o o m }
% { 
%   \IfNoValueOrEmptyTF{#1}
%   {
%     \IfNoValueOrEmptyTF{#2}
%     {
%       \sidenote{\fullcite{#3}}
%     }
%     {
%       \sidenote{\fullcite[#2]{#3}}
%     }
%   }
%   {
%     \IfNoValueOrEmptyTF{#2}
%     {
%       \sidenote{\fullcite[#1]{#3}}
%     }
%     {
%       \sidenote{\fullcite[#1][#2]{#3}}
%     }
%   }
% }
% \ExplSyntaxOff


