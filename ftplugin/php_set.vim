" ========================================================================
" VIM Macros for editing PHP documents
"
" File:		php_set.vim
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://hermitte.free.fr/vim/>
" Last Update:	03rd Aug 2003
"
" Dependancies:	ML.set, HTML.set
"
" ========================================================================
if exists("b:loaded_php3_set_vim") | finish | endif
let b:loaded_php3_set_vim = 1

" ------------------------------------------------------------------------
" Dependancies
" ------------------------------------------------------------------------
"
if exists("g:BuffOptions2Loaded")
  let file = expand("<sfile>:p:h") . "/html.set"
  call ReadFileTypeMap( "html,php3", file)
else
  ""so <sfile>:p:h/html.set
endif

" add other brackets pairs for {}, () and []
let b:cb_acco		= 1
let b:cb_parent		= 1
let b:cb_bracket	= 1
call Brackets()

" Mappings
inoremap <buffer> ? <c-r>=<sid>Insert_interrogation()<cr>

" ======================================================================
if exists("g:loaded_php3_set_vim") | finish | endif
let g:loaded_php3_set_vim = 1

" ------------------------------------------------------------------------
" Functions
" ------------------------------------------------------------------------
"
" Function: s:Insert_interrogation()
" Purpose:	Adds '?'s within '<>' when a '?' is entered just after the
" 		first '<'.
function! s:Insert_interrogation()
  let c = col('.')
  let lig = getline(line('.'))
  if lig[c-2] == '<' 
    let d = c-1
    while lig[d] =~ '\s' | let d = d + 1 | endwhile
    if lig[d] == '>'
      let e = 2 + d - c
      return "?\<esc>".e."\<right>i?\<esc>".e."\<left>a"
    endif
  endif
  return '?'
endfunction


