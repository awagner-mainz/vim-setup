" ==============================================================================
" Additions by me, Andreas Wagner <A.Wagner@stud.uni-frankfurt.de>...  {{{
" latest changes on 070301...

" make it format-flowed: before: (2tcq)
set fo+=wra

" I don't want a commandline that's several lines high
set ch=1

" Enable spell checking
setlocal spell spelllang=de_20	" spell check with new german spellings

" filetype indent off

" re-enable e-acute key as per FAQ. and this works with Alt-i... {{{
imap <buffer> <leader>item <Plug>Tex_InsertItemOnThisLine
" }}}

" External commands and additional functions {{{

" set up aliases {{{
iab ::: [\punkte]
call IMAP (':::', '[\punkte]', "tex")

" }}}
"
" make F8 call aspell {{{
map <F8> :w!<CR>:!aspell --lang=de --mode=tex check "%"<CR>:e! "%"<CR><CR>

" }}}

" make a shortcut for rmligs {{{
map <Leader>rml		:%!rmligs -q -f<CR>
" }}}

" make a shortcut for cleaning tex temporary files {{{
if has('unix')
    map <Leader>cl		:lcd %:p:h<CR>:!cleantexfiles.sh<CR>
endif
" }}}

" Source aux2tags, a tool to make a tags base from the current aux file... {{{
if !exists('g:aux2tags_loaded')
    if has('unix')
	exec 'so $HOME/.vim/macros/aux2tags.vim'
    else
	exec 'so $HOME/.vim/macros/aux2tags.vim'
    endif
endif
" }}}

" {{{ Section Jumping
" Here is a snippet I found on vim.org's tips, where section jumping works with count:
" The search() function is used rather than // command to avoid the
" wrap-arounds and end-of-file messages. Also, if you want to keep the
" original search pattern, just comment out the "let @/ = pat" line.
noremap <buffer> <silent> ]] :<c-u>call TexJump2Section( v:count1, '' )<cr>
noremap <buffer> <silent> [[ :<c-u>call TexJump2Section( v:count1, 'b' )<cr>
function! TexJump2Section( cnt, dir )
    let i = 0
    let pat = '^\\\(part\|chapter\|\(sub\)*section\|paragraph\)\>\|\%$\|\%^'
    let flags = 'W' . a:dir
    while  i < a:cnt && search( pat, flags ) > 0
	let i = i+1
    endwhile
"   let @/ = pat
endfunction
" }}}

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
" :%s/\(\a\)\.\(\a\)\.\_s/\1.\\,\2.\~/gc
" :%s/\(\a\)\.\(\a\)\./\1.\\,\2./gc
" :%s/\(\a\)\.\(\a\)\.\(\a\)\./\1.\\,\2.\\,\3./gc

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

" BELEGUNGS-REFERENZ: {{{

" Vim i. A.: Digraphen: Strg-K {Char1}{Char2} (oder Strg-V (Windows: Strg-Q) {Dezimalcode})
" wobei für {Char2} z.B.:
"   ! -> Grave          (è)
"   ' -> Akut           (é)
"   > -> Zirconflex     (ê)
"   , -> Cedilla        (ç)
"   : -> Diarese        (ë)
"   ? -> Tilde          (ñ)
"   - -> Über-/Durchstrich (ē/ð)
"   < -> Hacek          (ě)
"
"    _C     für copy to tempfile
"
" zz move window so that cursor is in the middle, then 8 Ctl-E to move window 8 lines downw.
" or zt to move window so that cursor is on top, then 8 Ctrl-Y to move window 8 lines upw.
"
" LaTeX-Suite i.Bes.:
" Environments: ,qe im Visual Mode wird zu EQE im Insert Mode und umgekehrt
" Formate:      `it im Visual Mode wird zu FIT im Insert Mode und umgekehrt
" (daran denken: in windows ist "`" ein dead key, d.h. "`em" = "`<SPACE>em")
" v: ,qe    für quote
"    ,qn    für quotation
"    ,ct    für cite
"    ,fn    für in Fussnote
"    `it    für textit
"    `em    für emph
"
" n: za, '-', <space> für folds öffnen/schließen
"    F5     für Environment / package einfügen
"    F7     für Kommando einfuegen
"    F6     für Referenz?
"    \rml   für das Entfernen falscher Ligaturen (:%!rmligs -q -f<CR>)
"    _P     für paste from tempfile
"
" i: F9     für eine Liste von Referenzen in ref{xxx}/cite{xxx}, ansonsten 'custom command completion'
"    EQE    für quote
"    EQN    für quotation
"    FFN    für footnote
"    FFC    für footcite
"    FCT    für cite
"    FEM    für emph
"    FIT    für textit
"    FFX    für fixme{}
"    FFx    für fixme[inline]{}
"    S-F1   für Anf.Z.
"    S-F2   für Quote
"    S-F3   für Footcite
"    `CC    für öffnende Anf.z.
"    `CT    für schließende Anf.z.
"
" BIB
" ---
" i:    BBb     erstellt einen Bucheintrag
"       BBa     erstellt einen Artikeleintrag
"       BBic    erstellt einen InCollection-Eintrag
"       BBib    erstellt einen InBook-Eintrag
"       BBB     erstellt einen beliebigen Eintrag mit   minimalen Feldern
"       BBL         "       "       "           "       mehr
"       BBH         "       "       "           "       noch mehr
"       BBX         "       "       "           "       allen
"
"
" n  \rf          @<Plug>Tex_RefreshFolds
" n  \ls          @<Plug>Tex_ForwardSearch
" n  \lv          @<Plug>Tex_View
" n  \ll          @<Plug>Tex_Compile
" n  <S-F7>       @<Plug>Tex_FastCommandChange
" n  <F7>         @<Plug>Tex_FastCommandInsert
" n  <S-F5>       @<Plug>Tex_FastEnvironmentChange
" n  <F5>         @<Plug>Tex_FastEnvironmentInsert
" n  <F1>        *@:call <SNR>32_TexHelp()
" n  ì           *@:call <SNR>41_PutLeftRight()
" n  <NL>          <Plug>IMAP_JumpForward

" o  <NL>          <C-W>j<C-W><Right>

"    <C-H>         <C-W>h<C-W>
"    <C-K>         <C-W>k<C-W><Right>
"    <C-L>         <C-W>l<C-W>
"    <C-P>         :vsplit<CR><CR>:bn<CR><CR>:set scrollbind<CR><CR><C-W><C-W>:set scrollbind<CR><CR><C-W><C-W>
"    <C-S>         :if expand("%") == ""<CR>:browse confirm W<CR>:else<CR>:confirm W<CR>:endif<CR>
"    N             :w <CR>
" v  ,pg        '\paragraph{', '}', '', '')
" v  ,s2        '\subsubsection{', '}', '', '')
" v  ,ss        '\subsection{', '}', '', '')
" v  ,se        '\section{', '}', '', '')
" v  ,ch        '\chapter{', '}', '', '')
" v  ,pa        '\part{', '}', '', '')
" v  ,sl        '\begin{slide}', '\end{slide}')
" v  ,ov        '\begin{overlay}', '\end{overlay}')
" v  ,no        '\begin{note}', '\end{note}')
" v  ,tb        '\begin{thebibliography}', '\end{thebibliography}')
" v  ,ve        '\begin{verse}', '\end{verse}')
" v  ,vm        '\verb|', '|', '\begin{verbatim}', '\end{verbatim}')
" v  ,tp        '\begin{titlepage}', '\end{titlepage}')
" v  ,sb        '\begin{sloppybar}', '\end{sloppybar}')
" v  ,fr        '{\raggedright ', '}', '\begin{flushright}', '\end{flushright}')
" v  ,fl        '\begin{flushleft}', '\end{flushleft}')
" v  ,fc        '\begin{filecontents}', '\end{filecontents}')
" v  ,do        '\begin{document}', '\end{document}')
" v  ,ce        '\centerline{', '}', '\begin{center}', '\end{center}')
" v  ,ap        '\begin{appendix}', '\end{appendix}')
" v  ,ab        '\begin{abstract}', '\end{abstract}')
" v  ,ma        '\begin{math}', '\end{math}')
" v  ,eq        '\begin{equation}', '\end{equation}')
" v  ,ea        '\begin{eqnarray}', '\end{eqnarray}')
" v  ,dm        '\begin{displaymath}', '\end{displaymath}')
" v  ,ar        '\begin{array}', '\end{array}')
" v  ,tr        '\begin{tabular}', '\end{tabular}')
" v  ,tg        '\begin{tabbing}', '\end{tabbing}')
" v  ,te        '\begin{table}', '\end{table}')
" v  ,tl        '\begin{trivlist}', '\end{trivlist}')
" v  ,ti        '\begin{theindex}', '\end{theindex}')
" v  ,it        '\begin{itemize}', '\end{itemize}')
" v  ,en        '\begin{enumerate}', '\end{enumerate}')
" v  ,de        '\begin{description}', '\end{description}')
" v  ,li        '\begin{list}', '\end{list}')

" }}}
