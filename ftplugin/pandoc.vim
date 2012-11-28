" ==============================================================================
" Personal filetype commands for pandoc (*.pdc) files...
" latest changes on 2011-03-12...

let b:pdc_tex_template  ="/home/wagner/.pandoc/templates/default.latex"
let b:pdc_odt_template  ="/home/wagner/.pandoc/templates/reference.odt"
let b:pdc_docx_template ="/home/wagner/.pandoc/templates/reference.docx"
" let b:pdc_odt_template  ="/usr/share/pandoc-1.9.4.2/reference.odt"
" let b:pdc_odt_template  ="/usr/share/pandoc-1.9.4.2/reference.docx"
"let b:pdc_csl       =""
let b:pdc_csl       ="/home/wagner/.csl/chicago-author-date-de.csl"
"let b:biblatex_style="style=chicago-authordate"
let b:biblatex_style="citestyle=authoryear-icomp,bibstyle=authoryear"
let b:pdc_bib       ="/home/wagner/Dokumente/uni/Literaturlisten/AW.bib"
let b:pdc_biblatex  ="1"
let b:pdc_class     ="scrartcl"
let b:pdc_lang      ="english,french,ngerman"
let b:pdc_fontsize  ="11pt"
let b:pdc_komaoptions ="DIV=11"
let b:pdc_debug     =""

" Assemble pandoc_options from variables given above ======= {{{

let b:pandoc_binary ="/usr/bin/pandoc"
" let b:pandoc_options=" --xetex --variable=biblatex:true"
let b:viewer_binary="/usr/bin/mupdf"
let b:viewer_options=""

let b:pandoc_options=" "
let b:pandoc_tex_options=" "

if b:pdc_debug != ''
    let b:pandoc_options.="--dump-args -- "
endif

" let b:pandoc_options.="--from=markdown"

if b:pdc_csl != ''
    let b:pandoc_options .=" --csl=" . b:pdc_csl
endif

if b:pdc_bib != ''
    let b:pandoc_options .=" --bibliography=" . shellescape(b:pdc_bib)
endif

let b:pandoc_tex_options=b:pandoc_options

if b:pdc_biblatex != ''
"    let b:pandoc_options .=" --biblatex --variable=biblatex:biblatex"
    let b:pandoc_tex_options .=" --biblatex"
endif

if b:biblatex_style != ''
    let b:pandoc_tex_options .=" --variable=biblatexstyle:" . b:biblatex_style
endif

if b:pdc_class != ''
    let b:pandoc_tex_options .=" --variable=documentclass:" . b:pdc_class
endif

if b:pdc_lang != ''
    let b:pandoc_tex_options .=" --variable=lang:" . b:pdc_lang
endif

if b:pdc_fontsize != ''
    let b:pandoc_tex_options .=" --variable=fontsize:" . b:pdc_fontsize
endif

if b:pdc_komaoptions != ''
    let b:pandoc_tex_options .=" --variable=komaoptions:" . b:pdc_komaoptions
endif

let b:pandoc_tex_options .=" --variable=microtype:true --variable=biblio-title:''"

" }}}

" vim-pandoc support (https://github.com/vim-pandoc/vim-pandoc) ==== {{{
let g:pandoc_bibfiles = ['/home/wagner/Dokumente/uni/Literaturlisten/AW.bib']
let g:pandoc_use_bibtool = 1
" }}}

" Set Formatting and other Variables =============================== {{{

setlocal fo+=wra                    " make it format-flowed: before: (2tcq)
setlocal spell spelllang=de_20      " spell check with new german spellings
setlocal textwidth=120
setlocal ch=1                       " I don't want a commandline that's several lines high

"}}}

" Shortcuts for compiling/viewing pdf/latex/odt {{{

" Shortcut to generate a set of Office files
map <Leader>lo  :lcd %:p:h<CR>
              \ :exe "silent !" . shellescape(b:pandoc_binary) . " "
                       \ . shellescape(expand("%:p")) . " " . b:pandoc_options
                       \ . " --reference-odt=" . shellescape(b:pdc_odt_template)
                       \ . " --output=" . shellescape(expand("%:p:r") . ".odt")<CR>
              \ :exe "silent !" . shellescape(b:pandoc_binary) . " "
                       \ . shellescape(expand("%:p")) . " " . b:pandoc_options
                       \ . " --reference-docx=" . shellescape(b:pdc_docx_template)
                       \ . " --output=" . shellescape(expand("%:p:r") . ".docx")<CR>

" make a shortcut to generate a LaTeX file
map <Leader>lt  :lcd %:p:h<CR>
              \ :exe "silent !" . shellescape(b:pandoc_binary) . " "
                       \ . shellescape(expand("%:p")) . " " . b:pandoc_tex_options
                       \ . " --template=" . shellescape(b:pdc_tex_template)
                       \ . " --to=latex --output=" . shellescape(expand("%:p:r") . ".latex")<CR>

" Shortcut to generate a LaTeX file and compile it, run biber, re-compile the latex to generate a pdf
map <Leader>ll  :lcd %:p:h<CR>
              \ :exe "silent !" . shellescape(b:pandoc_binary) . " "
                       \ . shellescape(expand("%:p")) . " " . b:pandoc_tex_options
                       \ . " --template=" . shellescape(b:pdc_tex_template)
                       \ . " --to=latex --output=" . shellescape(expand("%:p:r") . ".latex")<CR>
              \ :exe "silent !pdflatex -interaction=nonstopmode " . shellescape(expand("%:p:r") . ".latex")<CR>
              \ :exe "silent !biber " . shellescape(expand("%:p:r"))<CR>
              \ :exe "silent !pdflatex -interaction=nonstopmode " . shellescape(expand("%:p:r") . ".latex")<CR>


" Shortcut to open the corresponding pdf file
map <leader>lv  :lcd %:p:h<CR>
              \ :exe "silent !" . shellescape(b:viewer_binary) . " "
              \ . shellescape(expand("%:p:r") . ".pdf") . "&"<CR>

" }}}


" make F8 call aspell {{{
map <F8> 		:w!<CR>:!aspell --lang=de check "%"<CR>:e! "%"<CR><CR>
" }}}

" Text-Ersetzungen: {{{

" {{{ Shortcuts for text-reviews ...
" 1. Unterordnung und -werfung -> ... "~werfung (damit nicht getrennt wird)
" :%s/\(\_s\)-\(\a\)/\1"\~\2/gc

" 2. (Miss-)Verständnis -> (Miss"~)""Verständnis; (Miss)Verständnis -> (Miss)""Verständnis
" :%s/\(\a\)-)\(\_a\)/\1"\~)""\2/gc
" :%s/\(\a\))\(\a\)/\1)""\2/gc

" 3. neben-, hintereinander -> neben"~, hintereinander
" :%s/\(\a\)-,/\1"\~,/gc

" 4. d.h. -> d.\,h.~ -- dgl. fuer i.O.,m.E.,i.A.,u.a.,d.h., z.B., s.o., s.u.
" :%s/\(\a\)\.\(\a\).\_s/\1.\\,\2.\~/gc
" (das deckt nicht folgende ab: m.a.W.)

" 4b. d.\,h.\ -> d.\,h.~
" :%s/\(\a\).\\,\(\a\).\_s\(\a\)/\1.\\,\2.\~\3/gc

" 4c. bzw. -> bzw.~
" :%s/bzw\.\_s/bzw.\~/gc
" :%s/usw\.\_s/usw.\~/gc
" :%s/gl\.\_s/gl.\~/gc
" :%s/cf\.\_s/cf.\~/gc

" 5. x/y -> x\,/\,y
" :%s/\(\a\)\/\(\a\)/\1\\,\/\\,\2/gc

" 6. x / y -> x\,/\,y
" :%s/\(\a\)\_s\/\_s\(\a\)/\1\\,\/\\,\2/gc

" 7. _-_ -> _--_
" :%s/ -\(\_s\)/ --\1/gc

" 8. S. xy -> S.~xy UND (K|Ch)ap. xy -> (K|Ch)ap.~xy
" :%s/\.\_s\(\d\)/.\~\1/gc

" 9.
" 3. Reich -> 3.~Reich
" :%s/\(\d\)\.\_s/\1.\~/gc

" 10. >>_xyc_<< mit kl. Leerzeichen?

" 11. Abkürzungen aus Grossbuchstaben kleiner als norm. Majuskeln, größer als Minuskeln -> SC-Minuskeln?
" /\u\+

" }}}

" Manuell - jeweils Suchdurchgänge für . . . {{{
" /[tz]ial
" /[tz]iell
" /ss       (sollte da ein ß stehen?)
" /ß        (sollte da ein ss stehen?)
" /'
" /\\tab
" /}[\.,;]  (Fußnoten sollen nach die Satzzeichen, nicht davor)
" /cf       (überall vgl.)
" /siehe    (überall vgl.)
" /quot
" /-
" /{(
" /)}
" /\.\.\.
" /\\l?dots ohne []
" }}}

" }}} ------


