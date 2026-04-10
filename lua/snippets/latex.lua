local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local extras = require("luasnip.extras")
local rep = extras.rep

local function math()
    return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end
local function env(name)
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end
local function tikz()
    return env("tikzpicture")
end

ls.add_snippets("tex", {
s({ trig = "beg", snippetType = "snippet", descr = "begin env"}, fmt([[
    \begin{<>}
        <>
    \end{<>}]],
    { i(1, "env"), i(0), rep(1) },
    { delimiters = "<>" }
)),
s({ trig = "...", wordTrig = false, snippetType = "autosnippet", descr = "ldots" }, { t("\\ldots") }),
s("template", fmt([[
    \documentclass[a4paper]{article}

    \usepackage[T1]{fontenc}
    \usepackage[utf8]{inputenc}
    \usepackage{mlmodern}

    \usepackage[parfill]{parskip}
    \usepackage[colorlinks=true,naturalnames=true,plainpages=false,pdfpagelabels=true]{hyperref}
    \usepackage[parfill]{parskip}
    \usepackage{lipsum}

    \usepackage{amsmath, amssymb}
    \usepackage{subcaption}
    \usepackage[shortlabels]{enumitem}
    \usepackage{amsthm}
    \usepackage{mathtools}
    \usepackage{braket}
    \usepackage{bbm}

    \usepackage{graphicx}
    \usepackage{geometry}
    \geometry{a4paper, top=15mm}

    % figure support
    \usepackage{import}
    \usepackage{xifthen}
    \pdfminorversion=7
    \usepackage{pdfpages}
    \usepackage{transparent}
    \newcommand{\incfig}[1]{%
        \def\svgwidth{\columnwidth}
        \import{./figures/}{#1.pdf_tex}
    }

    \pdfsuppresswarningpagegroup=1

    %\usepackage[backend=biber, sorting=none]{biblatex}
    %\addbibresource{uni.bib}

    \title{<>}
    \author{Milutin Popović}

    \begin{document}
    %\tableofcontents
        \maketitle
        <>
    %\printbibliography
    \end{document}
    ]],
    { i(1, "Title"), i(0) },
    {
        delimiters = "<>",
    })),
s({ trig = "document", descr = "document environment", snippetType = "snippet" },
    fmt([[
     \begin{document}
     \tableofcontents
         <>
     \printbibliography
     \end{document}
        ]],
    { i(0) },
    { delimiters = "<>" }
    )),
s({ trig = "table", descr = "table environment" , snippetType = "snippet" },
    fmt([[
     \begin{table}[htb]
        \centering
        \caption{<>}
        \label{tab:<>}
        \begin{tabular}{<>}
            <>
        \end{tabular}
     \end{table}
        ]],
    { i(1, "caption"), i(2, "label"), i(3, "c"), i(0) },
    { delimiters = "<>" }
    )),
s({ trig = "fig", descr = "figure environment" },
    fmt([[
     \begin{figure}[htb!]
        \centering
        \includegraphics[width=0.8\textwidth]{<>}
        \caption{<>}
        \label{fig:<>}
     \end{figure}
        ]],
    { i(1, "path"), i(2, "caption"), i(3, "0") },
    { delimiters = "<>" }
    )),
s({ trig = "align", descr = "align", snippetType = "autosnippet" },
    fmt([[
    \begin{align}
        <>
    \end{align}
        ]],
    { i(1) },
    { delimiters = "<>" }
    )),
s({ trig = "enumerate", descr = "enumerate", snippetType = "autosnippet" },
    fmt([[
    \begin{enumerate}
        \item <>
    \end{enumerate}
        ]],
    { i(1) },
    { delimiters = "<>" }
    )),
s({ trig = "itemize", descr = "itemize", snippetType = "autosnippet" },
    fmt([[
    \begin{itemize}
        \item <>
    \end{itemize}
        ]],
    { i(1) },
    { delimiters = "<>" }
    )),
s({ trig = "frame", descr = "frame", snippetType = "snippet" },
    fmt([[
    \begin{frame}{<>}
        <>
    \end{frame}
        ]],
    { i(1), i(0) },
    { delimiters = "<>" }
    )),
s({ trig = "desc", descr = "description", snippetType = "snippet" },
    fmt([[
    \begin{description}
        \item[<>] <>
    \end{description}
        ]],
    { i(1), i(0) },
    { delimiters = "<>" }
    )),
s({ trig = "pac", descr = "package", snippetType = "snippet" },
    fmt([[\usepackage[<>]{<>}<> ]],
    { i(1, "options"), i(2, "package"), i(0) },
    { delimiters = "<>" }
    )),
s({ trig = "=>", wordTrig = false, descr = "implies", snippetType = "autosnippet" },
    { t("\\implies") },
    { condition = math, show_condition = math }
    ),
s({ trig = "=<", wordTrig = false, descr = "impliedby", snippetType = "autosnippet" },
    { t("\\impliedby") },
    { condition = math, show_condition = math }
    ),
s({ trig = "iff", wordTrig = false, descr = "iff", snippetType = "autosnippet" },
    { t("\\iff") },
    { condition = math, show_condition = math }
    ),
s({ trig = "//", wordTrig = false, descr = "Fraction", snippetType = "autosnippet" },
    fmt([[\frac{<>}{<>}<>]], { i(1), i(2), i(0) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "==", wordTrig = false, descr = "equals", snippetType = "autosnippet" },
    fmt([[
    &= <> \\
    ]], { i(1) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "!=", wordTrig = false, descr = "not equals", snippetType = "autosnippet" },
    { t("\\neq") },
    { condition = math, show_condition = math }
    ),
s({ trig = "ceil", wordTrig = false, descr = "ceiling function", snippetType = "autosnippet" },
    fmt([[\left\lceil <> \right\rceil <>]], { i(1), i(0) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "floor", wordTrig = false, descr = "floor function", snippetType = "autosnippet" },
    fmt([[\left\lfloor <> \right\rfloor <>]], { i(1), i(0) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "pmat", wordTrig = false, descr = "pmatrix", snippetType = "autosnippet" },
    fmt([[\begin{pmatrix} <> \end{pmatrix} <>]], { i(1), i(0) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "bmat", wordTrig = false, descr = "pmatrix", snippetType = "autosnippet" },
    fmt([[\begin{bmatrix} <> \end{bmatrix} <>]], { i(1), i(0) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "lr", wordTrig = false, descr = "left* right*", snippetType = "snippet" },
    fmt([[\left<> <> \right<>]], { i(1), i(0), rep(1) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "lr(", wordTrig = false, descr = "left( right)", snippetType = "autosnippet" },
    fmt([[\left( <> \right)]], { i(1) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "lr|", wordTrig = false, descr = "left| right|", snippetType = "autosnippet" },
    fmt([[\left| <> \right|]], { i(1) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "lr{", wordTrig = false, descr = "left{ right}", snippetType = "autosnippet" },
    fmt([[\left\{ <> \right\}]], { i(1) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "lr[", wordTrig = false, descr = "left{ right}", snippetType = "autosnippet" },
    fmt([[\left[ <> \right] ]], { i(1) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "lra", wordTrig = false, descr = "left< right>", snippetType = "autosnippet" },
    fmt([[\left\langle <> \right\rangle] ]], { i(1) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "conj", descr = "conjugate", snippetType = "autosnippet" },
    fmt([[\overline{<>}<>]], { i(1), i(0) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "sum", wordTrig = false, descr = "sum", snippetType = "autosnippet" },
    fmt([[\sum_{<>}^{<>} <>]], { i(1), i(2), i(0) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "lim", wordTrig = false, descr = "lim", snippetType = "autosnippet" },
    fmt([[\lim_{<> \to <>} <>]], { i(1), i(2, "\\infty"), i(0) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "limsup", wordTrig = false, descr = "limsup", snippetType = "autosnippet" },
    fmt([[\limsup_{<> \to <>} <>]], { i(1), i(2, "\\infty"), i(0) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "prod", wordTrig = false, descr = "product", snippetType = "autosnippet" },
    fmt([[\prod_{<>}^{<>} <>]], { i(1), i(2), i(0) }, { delimiters = "<>" }),
    { condition = math, show_condition = math }
    ),
s({ trig = "part", wordTrig = false, descr = "d/dx", snippetType = "snippet" },
    fmt(
            [[\frac{\partial <>}{\partial <>} <>]],
            { i(1, "f"), i(2, "x"), i(0) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "sqrt", wordTrig = false, descr = "sqrt", snippetType = "autosnippet" },
    fmt(
            [[\sqrt{<>} <>]],
            { i(1), i(0) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "hat", wordTrig = false, descr = "hat", snippetType = "autosnippet" },
    fmt(
            [[\hat{<>}<>]],
            { i(1), i(0) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "tilde", wordTrig = false, descr = "tilde", snippetType = "autosnippet" },
    fmt(
            [[\tilde{<>}<>]],
            { i(1), i(0) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "td", wordTrig = false, descr = "to the .. power", snippetType = "autosnippet" },
    fmt(
            [[^{<>} <>]],
            { i(1), i(0) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "rd", wordTrig = false, descr = "to the .. (power)", snippetType = "autosnippet" },
    fmt(
            [[^{(<>)} <>]],
            { i(1), i(0) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "rd", wordTrig = false, descr = "to the .. (power)", snippetType = "autosnippet" },
    fmt(
            [[^{(<>)} <>]],
            { i(1), i(0) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "__", wordTrig = false, descr = "subscript", snippetType = "autosnippet" },
    fmt(
            [[_{<>}<>]],
            { i(1), i(0) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "ooo", wordTrig = false, descr = "infty", snippetType = "autosnippet" },
    { t("\\infty") },
    { condition = math, show_condition = math }
    ),
s({ trig = "<=", wordTrig = false, descr = "leq", snippetType = "autosnippet" },
    { t("\\le") },
    { condition = math, show_condition = math }
    ),
s({ trig = ">=", wordTrig = false, descr = "geq", snippetType = "autosnippet" },
    { t("\\ge") },
    { condition = math, show_condition = math }
    ),
s({ trig = "EE", wordTrig = false, descr = "exists", snippetType = "autosnippet" },
    { t("\\exists") },
    { condition = math, show_condition = math }
    ),
s({ trig = "AA", wordTrig = false, descr = "forall", snippetType = "autosnippet" },
    { t("\\forall") },
    { condition = math, show_condition = math }
    ),
s({ trig = "xnn", wordTrig = false, descr = "x_n", snippetType = "autosnippet" },
    { t("x_{n}") },
    { condition = math, show_condition = math }
    ),
s({ trig = "ynn", wordTrig = false, descr = "y_n", snippetType = "autosnippet" },
    { t("y_{n}") },
    { condition = math, show_condition = math }
    ),
s({ trig = "xii", wordTrig = false, descr = "x_i", snippetType = "autosnippet" },
    { t("x_{i}") },
    { condition = math, show_condition = math }
    ),
s({ trig = "yii", wordTrig = false, descr = "y_i", snippetType = "autosnippet" },
    { t("y_{i}") },
    { condition = math, show_condition = math }
    ),
s({ trig = "xjj", wordTrig = false, descr = "x_j", snippetType = "autosnippet" },
    { t("x_{j}") },
    { condition = math, show_condition = math }
    ),
s({ trig = "yjj", wordTrig = false, descr = "y_j", snippetType = "autosnippet" },
    { t("y_{j}") },
    { condition = math, show_condition = math }
    ),
s({ trig = "mcal", wordTrig = false, descr = "mathcal", snippetType = "autosnippet" },
    fmt(
            [[\mathcal{<>}<>]],
            { i(1), i(0) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "lll", wordTrig = false, descr = "l", snippetType = "autosnippet" },
    { t("\\ell") },
    { condition = math, show_condition = math }
    ),
s({ trig = "nabl", wordTrig = false, descr = "nabla", snippetType = "autosnippet" },
    { t("\\nabla") },
    { condition = math, show_condition = math }
    ),
s({ trig = "xx", wordTrig = false, descr = "cross", snippetType = "autosnippet" },
    { t("\\times") },
    { condition = math, show_condition = math }
    ),
s({ trig = "**", wordTrig = false, descr = "cdot", snippetType = "autosnippet" },
    { t("\\cdot") },
    { condition = math, show_condition = math }
    ),
s({ trig = "pi", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\pi") },
    { condition = math, show_condition = math }
    ),
s({ trig = "arcsin", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\arcsin") },
    { condition = math, show_condition = math }
    ),
s({ trig = "sin", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\sin") },
    { condition = math, show_condition = math }
    ),
s({ trig = "cos", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\cos") },
    { condition = math, show_condition = math }
    ),
s({ trig = "arccot", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\arrcot") },
    { condition = math, show_condition = math }
    ),
s({ trig = "cot", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\cot") },
    { condition = math, show_condition = math }
    ),
s({ trig = "csc", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\csc") },
    { condition = math, show_condition = math }
    ),
s({ trig = "ln", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\ln") },
    { condition = math, show_condition = math }
    ),
s({ trig = "log", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\log") },
    { condition = math, show_condition = math }
    ),
s({ trig = "exp", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\exp") },
    { condition = math, show_condition = math }
    ),
s({ trig = "star", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\star") },
    { condition = math, show_condition = math }
    ),
s({ trig = "perp", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\perp") },
    { condition = math, show_condition = math }
    ),
s({ trig = "int ", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\int") },
    { condition = math, show_condition = math }
    ),
s({ trig = "zeta", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\zeta") },
    { condition = math, show_condition = math }
    ),
s({ trig = "arccos", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\arccos") },
    { condition = math, show_condition = math }
    ),
s({ trig = "actan", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\arctan") },
    { condition = math, show_condition = math }
    ),
s({ trig = "tan", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\tan") },
    { condition = math, show_condition = math }
    ),
s({ trig = "arccsc", wordTrig = false, descr = "fill", snippetType = "autosnippet" },
    { t("\\arcsc") },
    { condition = math, show_condition = math }
    ),
s({ trig = "dint", wordTrig = false, descr = "integral", snippetType = "autosnippet" },
    fmt(
            [[\int_{<>}^{<>} <> <>]],
            { i(1), i(2), i(3), i(4) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "->", wordTrig = false, descr = "to", snippetType = "autosnippet" },
    { t("\\to") },
    { condition = math, show_condition = math }
    ),
s({ trig = "<->", wordTrig = false, descr = "leftrightarrow", snippetType = "autosnippet" },
    { t("\\leftrightarrow") },
    { condition = math, show_condition = math }
    ),
s({ trig = "!>", wordTrig = false, descr = "mapsto", snippetType = "autosnippet" },
    { t("\\mapsto") },
    { condition = math, show_condition = math }
    ),
s({ trig = "ivs", wordTrig = false, descr = "inverse", snippetType = "autosnippet" },
    { t("^{-1}") },
    { condition = math, show_condition = math }
    ),
s({ trig = "compl", wordTrig = false, descr = "compliment", snippetType = "autosnippet" },
    { t("^{c}") },
    { condition = math, show_condition = math }
    ),
s({ trig = "\\\\\\", wordTrig = false, descr = "setminus", snippetType = "autosnippet" },
    { t("\\setminus") },
    { condition = math, show_condition = math }
    ),
s({ trig = ">>", wordTrig = false, descr = ">>", snippetType = "autosnippet" },
    { t("\\gg") },
    { condition = math, show_condition = math }
    ),
s({ trig = "<<", wordTrig = false, descr = "<<", snippetType = "autosnippet" },
    { t("\\ll") },
    { condition = math, show_condition = math }
    ),
s({ trig = "~~", wordTrig = false, descr = "~", snippetType = "autosnippet" },
    { t("\\sim") },
    { condition = math, show_condition = math }
    ),
s({ trig = "sub", wordTrig = false, descr = "~", snippetType = "autosnippet" },
    { t("\\subseteq") },
    { condition = math, show_condition = math }
    ),
s({ trig = "set", wordTrig = false, descr = "set", snippetType = "autosnippet" },
    fmt(
            [[\{<>\} <>]],
            { i(1), i(0) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "||", wordTrig = false, descr = "mid", snippetType = "autosnippet" },
    { t("\\mid") },
    { condition = math, show_condition = math }
    ),
s({ trig = "cc", wordTrig = false, descr = "subseet", snippetType = "autosnippet" },
    { t("\\subset") },
    { condition = math, show_condition = math }
    ),
s({ trig = "notin", wordTrig = false, descr = "not in", snippetType = "autosnippet" },
    { t("\\not\\in") },
    { condition = math, show_condition = math }
    ),
s({ trig = "inn", wordTrig = false, descr = "in", snippetType = "autosnippet" },
    { t("\\in") },
    { condition = math, show_condition = math }
    ),
s({ trig = "Nn", wordTrig = false, descr = "cap", snippetType = "autosnippet" },
    { t("\\cap") },
    { condition = math, show_condition = math }
    ),
s({ trig = "UU", wordTrig = false, descr = "cup", snippetType = "autosnippet" },
    { t("\\cup") },
    { condition = math, show_condition = math }
    ),
s({ trig = "uuu", wordTrig = false, descr = "bigcup", snippetType = "autosnippet" },
    fmt(
            [[\bigcup_{<>} <>]],
            { i(1), i(0) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "nnn", wordTrig = false, descr = "bigcap", snippetType = "autosnippet" },
    fmt(
            [[\bigcap_{<>} <>]],
            { i(1), i(0) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "OO", wordTrig = false, descr = "emptyset", snippetType = "autosnippet" },
    { t("\\O") },
    { condition = math, show_condition = math }
    ),
s({ trig = "<!", wordTrig = false, descr = "normal", snippetType = "autosnippet" },
    { t("\\triangleleft") },
    { condition = math, show_condition = math }
    ),
s({ trig = "<>", wordTrig = false, descr = "hokje", snippetType = "autosnippet" },
    { t("\\diamond") },
    { condition = math, show_condition = math }
    ),
s({ trig = "tt", wordTrig = false, descr = "text", snippetType = "autosnippet" },
    fmt(
            [[\text{<>} <>]],
            { i(1), i(0) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "case", wordTrig = false, descr = "cases", snippetType = "autosnippet" },
    fmt([[
    \begin{cases}
        <>
    \end{cases}
        ]],
        { i(1) },
        { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "cvec", wordTrig = false, descr = "column vector", snippetType = "autosnippet" },
    fmt(
            [[\begin{pmatrix} <>_<> \\ \vdots \\ <>_<> \end{pmatrix}]],
            { i(1, "x"), i(2, "1"), i(3, "x"), i(4, "n") },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "bar", wordTrig = false, descr = "bar", snippetType = "autosnippet" },
    fmt(
            [[\overline{<>}<>]],
            { i(1), i(0) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "dL", wordTrig = false, descr = "double letter", snippetType = "autosnippet" },
    fmt(
            [[ \mathbb{<>}<> ]],
            { i(1), i(0) },
            { delimiters = "<>" }
    ),
    { condition = math, show_condition = math }
    ),
s({ trig = "eps", wordTrig = false, descr = "varepsilon", snippetType = "autosnippet" },
    { t("\\varepsilon") },
    { condition = math, show_condition = math }
    ),
s({ trig = "vrho", wordTrig = false, descr = "varrho", snippetType = "autosnippet" },
    { t("\\varrho") },
    { condition = math, show_condition = math }
    ),
s({ trig = "vphi", wordTrig = false, descr = "varphi", snippetType = "autosnippet" },
    { t("\\varphi") },
    { condition = math, show_condition = math }
    ),
})
