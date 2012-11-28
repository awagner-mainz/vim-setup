" ========================================================================
" VIM Macros for editing HTML documents
"
" File:		html_set.vim
" Author:	Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>
"		<URL:http://hermitte.free.fr/vim/>
" Last Update:	25th Aug 2003
"
" Dependancies:	ftplugin/ML_set.vim macros/menu-map.vim
"
" NB: this has been designed to use quite the same macros than tex_set.vim
" Todo: 
" * Use local leader
" ========================================================================

" ========================================================================
" Local stuff {{{1
if exists("b:loaded_html_settings_buff") | finish | endif
let b:loaded_html_settings_buff = 1

" line continuation used here ??
let s:cpo_save = &cpo
set cpo&vim

runtime! ftplugin/ML.vim ftplugin/ML_*.vim ftplugin/ML/*.vim

" ------------------------------------------------------------------------
" Options                                        {{{2
" ------------------------------------------------------------------------
"
"setlocal formatoptions=croql
"setlocal cindent
setlocal comments=sr:<!--,mb:-,el:-->
setlocal cinoptions=g0,t0
setlocal tw=79
setlocal ff=unix
setlocal sw=4
setlocal ai
setlocal smarttab

" ------------------------------------------------------------------------
" Map-menu                                       {{{2
" ------------------------------------------------------------------------
command! -nargs=* -buffer MapMenu :call <SID>MapMenu(<f-args>)

" <c-o>, with a normal inside causes the cursor to go left... hence the
" <right>
inoremap <buffer> !close!  <c-o>:call <SID>Close(1)<cr><right>
inoremap <buffer> !close>! <c-o>:call <SID>Close(0)<cr><right>

" Load menu-map.vim {{{3
runtime macros/menu-map.vim 
if !exists("b:loaded_menu_map_local")
  if has('gui')
    call confirm('<macros/menu-map.vim> is not found on your system\n'.
	  \ 'Check for it on <http://hermitte.free.fr/vim/general.php>',
	  \ 'ok')
  else
    echohl ErrorMsg
    echo '<macros/menu-map.vim> is not found on your system'
    echo 'Check for it on <http://hermitte.free.fr/vim/general.php>'
    echohl None
  endif
endif

" ------------------------------------------------------------------------
" Definitions for other plugins                  {{{2
" ------------------------------------------------------------------------
" Matchit stuff -- or order to work fine with php3 as well {{{3
let b:match_ignorecase = 1 
let b:match_words =
      \ '<[ou]l[^>]*\(>\|$\),<li>,</[ou]l>:' .
      \ '<\([^/][^ \t>]*\)[^>]*\(>\|$\),</\1>'


" Definitions needed by µTemplate                          {{{3
let g:author_short="Luc Hermitte <hermitte {at} free {dot} fr>"
let g:author	    ="Luc Hermitte <EMAIL:hermitte {at} free {dot} fr>\<c-m>" .
      \ '-'. "\<tab>\<tab><URL:http://hermitte.free.fr/vim>"

" ------------------------------------------------------------------------
" Display the current buffer into your navigator {{{2
" ------------------------------------------------------------------------
if exists('*FixPathName')
  if exists('g:html_browser')
    " ... into g:html_browser if specified
    nnoremap <buffer> <c-l>v 
	  \ :update<cr>:call system(g:html_browser. " " . 
	  \              FixPathName(expand("%:p"),0,((&sh=~'sh')?"'":'"')))<cr>
    nmenu 50.100 &HTML.&Open\ in\ browser<tab><c-l>v	<C-L>v
    amenu 50.100 &HTML.---open--- <nop>
  elseif has('win32')
    " ... into Ms's Internet Explorer ; for MsWindows only
    nnoremap <buffer> <c-l>v 
	  \ :update<cr>:call system("explorer " . 
	  \              FixPathName(expand("%:p"),0,((&sh=~'sh')?"'":'"')))<cr>
    nmenu 50.100 &HTML.&Open\ in\ browser<tab><c-l>v	<C-L>v
    amenu 50.100 &HTML.---open--- <nop>
  endif
endif

" }}}1
" ========================================================================
" Global stuff -> Functions {{{1
if !exists("g:loaded_html_global") 
  let g:loaded_html_global = 1

  " s:Close() -> Close a '>', and delete the marker if required {{{2
  " a function and its map to close a ">", and that works whatever the
  " activation states of the brackets and marking features are.
  function! s:Close(andJump)
    if     (maparg('<') == "")                  | exe "normal! a>\<esc>"
    elseif exists("b:usemarks") && (b:usemarks==1) 
      if a:andJump 
	normal !jump-and-del!
      endif
    endif
  endfunction

  " s:MapMenu() -> Add a menu                                   {{{2
  "   a:priority = menu priority
  "   a:text     = text displayed in the menu
  "   a:binding  = key binding that will provoque the expansion of the tag
  "   a:tag      = HTML tag that will be produced -> <tag></tag>
  "   a:middle   = facultative middle tag like '<item>' for lists
  "                if this middle string isn't empty, the text produced will
  "                be considered multi-lines
  "                Default : none
  "   a:visual   = facultative command to set the visual selection from
  "                normal mode, typically things like 'vip', 'viw', etc
  "                Default "vip" for multi-lines tags, and "viw" otherwise
  function! s:MapMenu(priority,text,binding, tag, ...)
    if (a:0 > 0) && (a:1 =~ '\S\+')
      let m = '<cr>'.a:1.' <CR>'
      let prev = '==kA'
      let c1 = '!close!'
      let c2 = '!close>!'
      let cr = 1
      let _2visual = (a:0 > 1) ? a:2 : "vip"
      let u='<c-R>=(exists("b:usemarks") && b:usemarks) ? Marker_Txt() : ""<cr>'
    else 
      let m = ''
      let prev = 'F<i'
      let c1 = '!close>!'
      let c2 = '!close!'
      let cr = 0
      let _2visual = (a:0 > 1) ? a:2 : "viw"
      let u = ''
    endif
    let b = '<' . a:tag . '>'  | let e = '</' . a:tag . '>'  
    let t = a:text. ' : '.b.e
    let b = "'" . b . u . "'"      | let e = "'" . e . u . "'"
    call IVN_MenuMake(a:priority, t, a:binding,
	  \ '<'.a:tag.c1.m.'</'.a:tag.c2.'<esc>'.prev, 
	  \ ':VCall InsertAroundVisual('.b. ',' .e.','.cr.',1)'
	  \ .'<cr>/<\/'.a:tag.'>/e',
	  \ _2visual.a:binding,
	  \ 0, 1, 0)
  endfunction

endif
" }}}1    
" ===========================================================================
" Local stuff (again) {{{1
" Help {{{2
" ------------------------------------------------------------------------
" Help.vim support ?  We will use "HTML0" as prefix
if exists("*BuildHelp")
  command! -buffer -nargs=1 HTMLHelp :call BuildHelp("HTML0", <q-args>)
  amenu 50.500 &HTML.---help--- <nop>
  call MenuMake("niv", '50.500', '&HTML.Help', '<C-F1>', '<buffer>', 
	\ ':call ShowHelp("HTML0")<cr>')
else
  command! -buffer -nargs=1 HTMLHelp 
endif
"
HTMLHelp "			---------------------
HTMLHelp "			H T M L   M A C R O S
HTMLHelp "			---------------------
HTMLHelp "
HTMLHelp "
HTMLHelp "  <C-F1>	This Help
HTMLHelp "
"
noremap <C-F1> :call ShowHelp('HTML0')<cr>
inoremap <C-F1> <ESC>:call ShowHelp('HTML0')<cr>a
"
HTMLHelp 'Here are some explanations regarding the following mappins.
HTMLHelp 'In each of them, "^" indicates a special position used to move the cursor
HTMLHelp 'or to insert text.
HTMLHelp '
HTMLHelp 'The `i`, `n` and `v` flags indicates the modes in which the mappings operate.
HTMLHelp '  - `i` stands for "insert mode" 
HTMLHelp '    The text whithin quotes is inserted, and cursor move to the <>
HTMLHelp '  - `n` stands for "normal mode" 
HTMLHelp '    The text whithin quotes is inserted around the inner-word under the
HTMLHelp '    current position of the cursor.
HTMLHelp '  - `N` stands for "normal mode" 
HTMLHelp '    The text whithin quotes is inserted around the inner-paragraph under the
HTMLHelp '    current position of the cursor.
HTMLHelp '  - `v` stands for "visual mode" [Classical or Line]
HTMLHelp '    The text whithin quotes is inserted around selected text
HTMLHelp '
" }}}2
" ------------------------------------------------------------------------
" Font Macros        {{{2
" ------------------------------------------------------------------------
" Help     {{{3
HTMLHelp '--------------------------------------------------- FONT MACROS ----------
HTMLHelp '[inv]	]em	insert "<em>^</em>"			- italic
HTMLHelp '[inv]	]bf	insert "<b>^</b>"			- bold face
HTMLHelp '[inv]	]code	insert "<code>^</code>"			- code
HTMLHelp '[inv]	]bcode	insert "<code><b>^</b></code>"		- bold code
HTMLHelp '[inv]	]sc	insert "<pre>^</pre>"			- pre
"HTMLHelp '[inv]	]O	insert ""
HTMLHelp '[inv]	]U	insert "<U>^</U>"			- Underline
HTMLHelp '

" Mappings {{{3
" amenu 50.370.250 &HTML.&Fonts.-	<nop>
:MapMenu 50.370.300 &HTML.&Fonts.&Emphasize ]em em
:MapMenu 50.370.300 &HTML.&Fonts.&Bold\ Face ]bf b
:MapMenu 50.370.300 &HTML.&Fonts.&Tele\ type ]code code
:MapMenu 50.370.300 &HTML.&Fonts.&Verbatim ]pre pre PARA
":menu 50.370.300 &HTML.&Fonts.B&old\ Tele\ type 
amenu 50.370.350 &HTML.&Fonts.--	<nop>
:MapMenu 50.370.400 &HTML.&Fonts.&Tele\ type\ bis ]tt code
amenu 50.370.450 &HTML.&Fonts.---	<nop>
:MapMenu 50.370.500 &HTML.&Fonts.&Underline ]U U
" call MenuMake("niv", '50.370.400', '&HTML.&Fonts.&code', ']code', '<buffer>', ']tt')

call IVN_MenuMake('50.370.500', '&HTML.&Fonts.bcode : <code><b></b></code>', 
      \ ']bcode', 
      \ ']code]bf!mark!!jump-and-del!!bjump-and-del!', 
      \ ':VCall InsertAroundVisual("<code><b>", "</b></code>",0,1)<cr>'.
      \     '/<\/b><\/code>/e',
      \ 'viw]bcode', 
      \ 0, 1, 0)

" Fonts  
amenu 50.390.600 &HTML.&Fonts.---font--- <nop>
call IVN_MenuMake('50.390.600', '&HTML.&Fonts.&font : <font ></font>', 
      \ ']fnt', 
      \ '<font !mark!!close!</font!bjump-and-del!', 
      \ '<esc>`>a</font><esc>`<i<font ><Left>',
      \ 'viw]fnt', 
      \ 0, 1, 0)
call IVN_MenuMake('50.390.600', '&HTML.&Fonts.&color : <font color=#></font>', 
      \ ']color', ']fntcolor=#', ']fntcolor=#', ']fntcolor=#', 0, 0, 0)

" }}}2
" ------------------------------------------------------------------------
" Environment Macros {{{2
" ------------------------------------------------------------------------
" Help     {{{3
HTMLHelp '--------------------------------------------------- Environment MACROS----
HTMLHelp '[inv]	]ei ]ul	insert "<ul>^M<li> ^^M</ul>"		- bullet list
HTMLHelp '[inv]	]it ]li	insert "<li>"				- item
HTMLHelp '[inv]	]ee ]ol	insert "<ol>^M<li> ^^M</ol>"		- ordered list
HTMLHelp '[inv]	]ed ]dd	insert "<dd>^M<dt> ^^M</dd>"		- description list
HTMLHelp '
HTMLHelp '[inv]	]td    	insert "<td>^</td>"			- table element
HTMLHelp '[inv]	]tr    	insert "<tr>^M^^M</tr>"			- table line
HTMLHelp '[inv]	]et ]table insert "<table>^M^^M</table>"	- table
HTMLHelp '
HTMLHelp '[inv]	]ec    	insert "<center>^</center>"		- center
HTMLHelp '[inv]	]eC    	insert "<center>^M^^M</center>"		- center
HTMLHelp '[inv]	]ind   	insert "<ul>^M<p>^M<tab>^^M</ul>"	- indentation w/ UL
HTMLHelp '
" Mappings {{{3
"  - Lists
:MapMenu 50.370.200 &HTML.&Environments.&itemize ]ul ul <li!close!
imap <buffer> ]ei ]ul
vmap <buffer> ]ei ]ul
nmap <buffer> ]ei ]ul
:MapMenu 50.370.200 &HTML.&Environments.&enumerate ]ol ol <li!close!
imap <buffer> ]ee ]ol
vmap <buffer> ]ee ]ol
nmap <buffer> ]ee ]ol
:MapMenu 50.370.200 &HTML.&Environments.&description ]dd dd <dt!close!
imap <buffer> ]ed ]dd
vmap <buffer> ]ed ]dd
nmap <buffer> ]ed ]dd
inoremenu 50.370.200 &HTML.&Environments.&item\ :\ <li><tab>]li <li><space>
inoremap ]it <li><space>
inoremap ]li <li><space>
"  - Center      
:MapMenu 50.370.200 &HTML.&Environments.&center ]ec center
:MapMenu 50.370.200 &HTML.&Environments.&center\ Ne&wline ]eC center PARA

"  - Table
amenu 50.370.250 &HTML.&Environments.- <nop>
:MapMenu 50.370.300 &HTML.&Environments.&table ]table table PARA
:MapMenu 50.370.300 &HTML.&Environments.table\ &line ]tr tr PARA
:MapMenu 50.370.300 &HTML.&Environments.table\ &cell ]td td PARA
imap <buffer> ]et ]table 
vmap <buffer> ]et ]table 
nmap <buffer> ]et ]table 

"  - Indent
amenu 50.370.350 &HTML.&Environments.-- <nop>
" inoremap <buffer> ]ind <ul> <!-- Indentation --><cr><p><cr></ul><esc>O<c-t>
" vnoremap <buffer> ]ind >gvS<c-d><ul> <!-- Indentation --><cr><p><cr></ul><esc>P
" nmap <buffer> ]ind vip]ind

call IVN_MenuMake('50.370.350', '&HTML.&Environments.Indent', 
      \ ']ind', 
      \ '<ul> <!-- Indentation --><cr><p><cr></ul><esc>O<c-t>', 
      \ '>gvS<c-d><ul> <!-- Indentation --><cr><p><cr></ul><esc>P',
      \ 'vip]ind', 
      \ 1, 1, 0)
" }}}2
" ------------------------------------------------------------------------
" Headers Macros     {{{2
" ------------------------------------------------------------------------
" Help     {{{3
HTMLHelp '--------------------------------------------------- Headers MACROS--------
HTMLHelp '[i  ]	]head  	insert a template for the HEAD section
HTMLHelp '[i  ]	]body  	insert "<body>^M</body>"		- body
HTMLHelp '[in ]	]html  	insert a template for HTML files
HTMLHelp '
"
" Mappings {{{3
" Insert Mode Macros
inoremap <buffer> ]mt_cnt <META http-equiv="content-type" 
      \ content="text/html;charset=iso-8859-1"><CR>
inoremap <buffer> ]mt_auth <META name="AUTHOR" content="<c-r>=g:author_short<cr>"><CR>
inoremap <buffer> ]mt_gen <META name="GENERATOR" 
      \ content="VIM/<c-r>=version<cr> [VI iMproved]"><CR>
inoremap <buffer> ]mt_key <META name="KeyWords" content=""><CR>
inoremap <buffer> ]mt_tit <cr><title></title><CR>

imap <buffer> ]mt_all ]mt_cnt]mt_auth]mt_gen]mt_key]mt_tit

imap <buffer> ]head <HEAD><cr><C-T>]mt_all<C-D></HEAD>
inoremap <buffer> ]body <BODY><cr></BODY>
imap <buffer> ]html <HTML><cr>]head<cr><cr>]body<cr></HTML><ESC>?<title>?e<cr>a
"
" Normal Mode Macros 
nmap <buffer> ]html i]html
" }}}2
" ------------------------------------------------------------------------
" Sections Macros    {{{2
" ------------------------------------------------------------------------
" Help     {{{3
HTMLHelp '--------------------------------------------------- Sections MACROS-------
HTMLHelp '[ivn]	]body  	insert "<h1>^M</h1>"			- h1
HTMLHelp '[ivn]	]body  	insert "<h2>^M</h2>"			- h2
HTMLHelp '[ivn]	]body  	insert "<h3>^M</h3>"			- h3
HTMLHelp '[ivn]	]body  	insert "<h4>^M</h4>"			- h4
HTMLHelp '[ivn]	]body  	insert "<h5>^M</h5>"			- h5
HTMLHelp '[ivn]	]body  	insert "<h6>^M</h6>"			- h6
HTMLHelp '
" Mappings {{{3
:MapMenu 50.380.200 &HTML.&Sections.h&1 ]h1 h1 \  V
:MapMenu 50.380.200 &HTML.&Sections.h&2 ]h2 h2 \  V
:MapMenu 50.380.200 &HTML.&Sections.h&3 ]h3 h3 \  V
:MapMenu 50.380.200 &HTML.&Sections.h&4 ]h4 h4 \  V
:MapMenu 50.380.200 &HTML.&Sections.h&5 ]h5 h5 \  V
:MapMenu 50.380.200 &HTML.&Sections.h&6 ]h6 h6 \  V
" }}}2
" ------------------------------------------------------------------------
" Misc. Macros       {{{2
" ------------------------------------------------------------------------
" Help     {{{3
HTMLHelp '--------------------------------------------------- Misc. MACROS----------
HTMLHelp '[ivn]	]href  	insert "<A HREF="^"></A>"		- links
HTMLHelp '[ivn]	]url  	insert "<A HREF="http://^"></A>"	- urls
HTMLHelp '[ivn]	]mail  	insert "<A HREF="mailto:^"></A>"	- mails
HTMLHelp '[ivn]	]name 	insert "<A NAME=""></A>"		- anchors
HTMLHelp '
HTMLHelp '[ivn]	]fig  	insert "<IMG SRC="^">"			- images
HTMLHelp '[ivn]	]img  	insert "<IMG SRC="^">"			- images
HTMLHelp '[ivn]	]0img  	insert "<IMG BORDER=0 SRC="^">"		- images no border
HTMLHelp '
HTMLHelp '[ivn]	]fnt  	insert "<FONT ^></FONT>"		- FONT
HTMLHelp '[ivn]	]color 	insert "<FONT COLOR=#^></FONT>"		- color
HTMLHelp '
HTMLHelp '[i  ]	]&& 	insert "&amp;"				- context dep ampersand
HTMLHelp '[i  ]	]&~ 	insert "&nbsp;"				- non breakable space
HTMLHelp '[i  ]	]&c 	insert "&copy;"				- context dep copyright
HTMLHelp '
"
" Mappings {{{3
" HREF  
call IVN_MenuMake('50.390.200', '&HTML.&Misc.href : <a href=""></a>', 
      \ ']href', 
      \ '<a href="!mark!"!close!</a>!bjump-and-del!', 
      \ '<esc>`>a</a><esc>`<i<a href=""><Left><Left>',
      \ 'viw]href', 
      \ 0, 1, 0)
call IVN_MenuMake('50.390.200', '&HTML.&Misc.url : <a href="http://"></a>', 
      \ ']url', 
      \ ']hrefhttp://', ']hrefhttp://', ']hrefhttp://', 0, 0, 0)
call IVN_MenuMake('50.390.200', '&HTML.&Misc.mailto : <a href="mailto:"></a>', 
      \ ']mail', 
      \ ']hrefmailto:', ']hrefmailto:', ']hrefmailto:', 0, 0, 0)

" A NAME
call IVN_MenuMake('50.390.200', '&HTML.&Misc.name : <a name=""></a>', 
      \ ']name', 
      \ '<a name="!mark!"!close!</a>!bjump-and-del!', 
      \ '<esc>`>a</a><esc>`<i<a name=""><Left><Left>',
      \ 'V]href', 
      \ 0, 1, 0)

" Images
amenu 50.390.300 &HTML.&Misc.---fig--- <nop>
call IVN_MenuMake('50.390.300', '&HTML.&Misc.figure : <img src="">', 
      \ ']fig', 
      \ '<img src=""<Left>', 
      \ ':VCall InsertAroundVisual("<img src=\"", "\">",0,1)<cr>/>/e',
      \ 'viW]fig', 
      \ 0, 1, 0)
call IVN_MenuMake('50.390.300', '&HTML.&Misc.image : <img src="">', 
      \ ']img', ']fig', ']fig', ']fig', 0, 0, 0)

call IVN_MenuMake('50.390.300', 
      \ '&HTML.&Misc.Image No Border : <img border=0 src="">', 
      \ ']0img', 
      \ '<img border=0 src=""<Left>', 
      \ ':VCall InsertAroundVisual("<img border=0 src=\"", "\">",0,1)<cr>/>/e',
      \ 'viW]0img', 
      \ 0, 1, 0)

" }}}2
" ------------------------------------------------------------------------
" Groups Macros {{{2
" ------------------------------------------------------------------------
call MenuMake('i', '50.400.200', '&HTML.S&ymbols.Ampersand : &&amp;', 
      \ '&&', '<buffer>', '<C-R>=MapNoContext("&&", "&amp;")<CR>')
call MenuMake('i', '50.400.200', '&HTML.S&ymbols.Non breaking space : &nbsp;', 
      \ '&~', '<buffer>', '<C-R>=MapNoContext("&~", "&nbsp;")<CR>')

call MenuMake('i', '50.400.200', '&HTML.S&ymbols.Copyright : &&copy;',
      \ '&c', '<buffer>', '<c-r>=MapNoContext("&c", "&copy;")<cr>')
call MenuMake('i', '50.400.200', '&HTML.S&ymbols.Trade : &&trade;',
      \ '&tm', '<buffer>', '<C-R>=MapNoContext("&tm", "&trade;")<CR>')

amenu 50.400.250 &HTML.S&ymbols.---thin-arrows--- <nop>

call MenuMake('i', '50.400.300', '&HTML.S&ymbols.Left arrow : &&larr;',
      \ '&<-', '<buffer>', '<c-r>=MapNoContext("&<-", "&larr;")<cr>')

call MenuMake('i', '50.400.300', '&HTML.S&ymbols.Up arrow : &&uarr;',
      \ '&^-', '<buffer>', '<c-r>=MapNoContext("&^-", "&uarr;")<cr>')
call MenuMake('i', '50.400.300', '&HTML.S&ymbols.Right arrow : &&rarr;',
      \ '&->', '<buffer>', '<c-r>=MapNoContext("&->", "&rarr;")<cr>')
call MenuMake('i', '50.400.300', '&HTML.S&ymbols.Down arrow : &&darr;',
      \ '&v-', '<buffer>', '<c-r>=MapNoContext("&v-", "&darr;")<cr>')
call MenuMake('i', '50.400.300', '&HTML.S&ymbols.Left-right arrow : &&harr;',
      \ '&<>', '<buffer>', '<c-r>=MapNoContext("&<>", "&harr;")<cr>')

amenu 50.400.350 &HTML.S&ymbols.---bold-arrows--- <nop>

call MenuMake('i', '50.400.400', '&HTML.S&ymbols.Left double arrow : &&lArr;',
      \ '&<=', '<buffer>', '<c-r>=MapNoContext("&<=", "&lArr;")<cr>')
call MenuMake('i', '50.400.400', '&HTML.S&ymbols.Up double arrow : &&uArr;',
      \ '&^=', '<buffer>', '<c-r>=MapNoContext("&^=", "&uArr;")<cr>')
call MenuMake('i', '50.400.400', '&HTML.S&ymbols.Right double arrow : &&rArr;',
      \ '&=>', '<buffer>', '<c-r>=MapNoContext("&=>", "&rArr;")<cr>')
call MenuMake('i', '50.400.400', '&HTML.S&ymbols.Down double arrow : &&dArr;',
      \ '&v=', '<buffer>', '<c-r>=MapNoContext("&v=", "&dArr;")<cr>')
call MenuMake('i', '50.400.400', '&HTML.S&ymbols.Left-right double arrow : &&hArr;',
      \ '&=<>', '<buffer>', '<c-r>=MapNoContext("&=<>", "&hArr;")<cr>')
"
"--- Commentaires automatiques -------------------------------------------
"--/* insert <!--
"              - <curseur>
"              -->
inoreab <buffer> /*  <!--<CR>  --><ESC>kA

"--/*- insert <!-----[  ]-------->
inoreab <buffer> /*- 0<C-D><!-- <ESC>70a-<ESC>a --><ESC>46<left>R[

"--/*= insert /*=====[  ]=======*/
inoreab <buffer> /*0 0<C-D><!-- <ESC>70a=<ESC>a --><ESC>46<left>R[


" }}}2
" ------------------------------------------------------------------------
" control structs. {{{2
" ------------------------------------------------------------------------
function! Def_AbbrHTML(key,expr1js_php,expr2js_php,expr1vb,expr2vb)
  let expr = "\<c-r>=MapContext('".a:key."', 'javaScript'"
  if exists('b:usemarks') && b:usemarks
    let expr = expr.",BuildMapSeq('".a:expr2js_php."')"
    let expr = expr.", 'php', BuildMapSeq('".a:expr2js_php."')"
    let expr = expr.", 'vb', BuildMapSeq('".a:expr2vb."')"
  else
    let expr = expr.",'".a:expr1js_php."'"
    let expr = expr.", 'php', '".a:expr1js_php."'"
    let expr = expr.", 'vb', '".a:expr1vb."'"
  endif
    let expr = expr. ", '".a:key."' )\<cr>"
  return expr
endfunction

" :Inoreab if <c-r>=MapContext('if ', 
      " \ 'javaScript', 'if () {}\<esc\>?)\<cr\>i', 
      " \ 'vb', 'If\<CR\>Then\<CR\>Endif\<esc\>?If\<CR\>o', 
      " \ 'if ')<cr>
" :Inoreab <buffer> if <c-r>=Def_AbbrHTML('if ', 
      \ 'if () {}\<esc\>?)\<cr\>i', 
      \ 'if () {!mark!}!mark!\<esc\>?)\<cr\>i', 
      \ 'If \<CR\>Then\<CR\>Endif\<esc\>?If \<CR\>a',
      \ 'If \<CR\>Then!mark!\<CR\>Endif!mark!\<esc\>?If \<CR\>a'
      \ )<cr>
"
  let &cpo = s:cpo_save
" }}}1
" ========================================================================
" Functions and global definitions
" ========================================================================
" vim600: set fdm=marker:
