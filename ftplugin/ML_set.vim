" ========================================================================
" VIM Macro for editing HTML, XML, SGML, etc. documents
"
" File:		ML.set
" Author:	Luc Hermitte <EMAIL:hermitte at free.fr>
"		<URL:http://hermitte.free.fr/vim/>
" Last Update:	31st oct 2002
"
" Dependancies:	Triggers.vim
"
" ========================================================================
if exists("b:loaded_ML_settings_buff") | finish | endif
let b:loaded_ML_settings_buff = 1
  "
  " single-quote needed with VimSpell plugin
  setlocal isk+='

" A little function to ease the mode switching process
let b:usemarks   = 1
let b:cb_cmp 	 = 1
let b:cb_ltFn    = "Insert_lt_gt(0)"
let b:cb_gtFn    = "Insert_lt_gt(1)"
let b:cb_quotes  = 0
let b:cb_Dquotes = 0
let b:cb_parent  = 0
let b:cb_bracket = 0
let b:cb_acco    = 0
let b:cb_mathMode= 0
""so $VIMRUNTIME/settings/common_brackets.vim
"call Brackets()


" ========================================================================
" Global definitions likes functions
" ========================================================================
if exists("g:loaded_ML_global") | finish | endif
let g:loaded_global = 1

" ================= Tags Macros ========================
" <F9> will activate or desactivate the redefinition of '<' and '>'
" '<' automatically inserts its counter part
" '>' reach the next '>' 
" While '<'+'<' inserts '&lt;' and '<'+'>' inserts '&gt;'
"
" And '<' + '/' will insert the closing tag associated to the previous one
" not already closed.

" Which==0 <=> '<'; 
function! Insert_lt_gt(which)
  let column = col(".")
  let lig = getline(line("."))
  if lig[column-2] == '<'
    let ret = "\<BS>&". ((a:which == 0) ? 'lt;' : 'gt;')
    if lig[column-1] == '>'
      let ret = "\<Right>\<BS>" . ret
    endif
    if lig[column].lig[column+1] == Marker_Txt()
      let ret = ret . "\<del>\<del>"
    endif
    return ret
  else
    if a:which == 0 
      if exists("b:usemarks") && b:usemarks == 1
	return "<>\<c-r>=Marker_Txt()\<cr>\<esc>F>i"
      else
	return "<>\<left>"
      endif
    else            | return "\<esc>/>\<CR>a"
    endif
  endif
endfunction
" 
"
function! s:CloseTag()
  let ret = '/'
  let column = col(".")
  let lig = getline(line("."))
  if lig[column-2] == '<'
    " find the previous match ... perhaps thanks to matchit
    let ret = "\<BS>&lt;"
    if lig[column-1] == '>'
      let ret = "\<Right>\<BS>" . ret
    endif
  endif
  return ret;
endfunction

""fun! HTMLTag()  
    """"inoremap < <><Left>
    ""inoremap < <C-R>=Insert_lt_gt(0)<CR>
    ""vnoremap < <esc>`>a><esc>`<i<<esc>%l
    " keep '}' for php
    ""inoremap > <C-R>=Insert_lt_gt(1)<CR>
    """nnoremap > /><CR>a
""endf  

" Defines a command and the mode switching mappings (with <F9>)
""call Trigger_Function('<F9>', 'HTMLTag', '$VIMRUNTIME/settings/ML.set' )
" Activates it by default
""call HTMLTag()
"

" ===========================================================================
" In response to a question of Marc Chantreux in the ML vimfr : how to
" generate a tag and its closing tag named after the current word under the
" cursor.
" 
" First Solution, but there are problems with letter tags
" inoremap <F8> <esc>bcw<><esc>PF<y/>/e/<cr>Pa<right>/<left><left>
"
" Other solution that works fine :
if mapcheck('¡mark!', 'i') != ""
  inoremap <buffer> ]>
		\ <esc>viW<esc>`>a><C-R>=Marker_Txt()<CR><esc>`<i<<esc>y/>/e/<cr>Pa<right>/<left><left><CR><cr><up>
  inoremap <buffer> ]<
		\ <esc>viw<esc>`>a><C-R>=Marker_Txt()<CR><esc>`<i<<esc>y/>/e/<cr>Pa<right>/<left><left>
else
  inoremap <buffer> ]>
		\ <esc>viW<esc>`>a><esc>`<i<<esc>y/>/e/<cr>Pa<right>/<left><left><CR><cr><up>
  inoremap <buffer> ]<
		\ <esc>viw<esc>`>a><esc>`<i<<esc>y/>/e/<cr>Pa<right>/<left><left>
endif
" ===========================================================================
