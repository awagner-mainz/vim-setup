" /***************************************************
" * Filename:    ~.vimrc
" * Description: Setup file for the editor vim
" * Author:      Andreas Wagner
" * Date:        Apr 21 2005
" * *************************************************/
" Header {{{ -----------------------------------------

" In this file, there are the following sections
" - OPTIONS
" - My variables
" - ABBREVIATIONS
" - COMMANDS (+ AUTOCOMMANDS)
" - MAPPINGS
"   - Movements
"   - Appearance
"   - Buffers
"   - Saving
"   - Formatting
"   - Screen
"   - Misc
"   - Vimrc Editing
"   - Spellchecking
" - SOME DOCUMENTATION

" General TODO:
" Add DrChip Menu support to other thingies.
"   and rename it back to DrChip again.
" Add TeX thingies (to ftplugin?)
" }}}
" =============================================================================
" OPTIONS {{{
" =============================================================================
"
"

" First, fix path:
" set runtimepath=HOME/vimfiles,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after,$HOME/vimfiles/after

" then, in alphabetical order

set autoindent					" always set autonidenting on
set autoread					" reload if file changed on disc
set autowrite					" saves buffer before launching shellcommands etc.
set nobackup					" don't use backups (use versions?)
if has ('gui_running')
	set background=light		" my gvim uses bright background
	let psc_style = 'warm'
	colo ps_color
"	colo peachpuff
else
	set background=dark			" my xterm/screen is dark.
"	let psc_style = 'cool'
"	colo ps_color
    let xterm16_colormap	= 'soft'
    let xterm16_brightness	= 'high'		" 'high' is default
    colo xterm16
endif
set backspace=indent,eol,start	" backspace over everything in insert mode
set browsedir=buffer			" use dir of current buffer in file open dialog
set ch=1			" no special height of command line (as has been set by ARCH's /etc/gvimrc)
set cinoptions=>s,{0,}0,?0,^0,:0,=s,p0,t0,+s,(0,)20,*30
if &diff     " If comparing files side-by-side, then ...
    let &columns = ((&columns*2 > 191)? 191: &columns*2)    " double the width up to a reasonable maximum
endif
set nocompatible				" relax vi compatibility
set confirm						" ask about unsaved buffers rather than fail on quit etc.
set cursorline					" highlight cursor line
" set hl-CursorLine='term=underline cterm=underline guibg=LightCyan'
set nocursorcolumn
set nodigraph                   " for strange chars, allowing to enter {char1}<BS>{char2}
set encoding=utf-8
set noerrorbells
set errorformat=%f:%l:%c:%m		" that's the way tex-wrapper reports
" set errorformat=%f:%l:%m,\"%f\"\\,\ line\ %l\:\ %m
set esckeys						" allow cursor keys in insert mode
set noexpandtab
set fenc=utf-8
" set filetype					" use filetype auto-recognition
set fileformat=unix				" use unix linebreaks (not dos cr/lf)
" set foldcolumn=4				" display markers for folds in a small column of its own
set foldmethod=marker			" use braces as folding markers
" set foldtext=MyFoldText()		" TODO: Check it out!
set formatoptions=2tcq			" format text using indentation of the second line
if has("unix")
    set grepprg=grep\ -nH\ $*   " make grep always generate a filename
endif
set guicursor=a:blinkon0
if has("unix")
"	set guifont=Luxi\ Mono\ 10	" Monospaced Roman
"	set guifont=Consolas\ 10
	set guifont=Consolas\ 11			" in 12 schöner als Vera Sans
"	set guifont=Bitstream\ Vera\ Sans\ Mono\ 10	" ist id. mit DejaVu Sans, aber diese hat mehr unicode
" 	set guifont=DejaVu\ Sans\ Mono\ 10
else
"	set guifont=Bitstream_Vera_Sans_Mono:h10:cDEFAULT
"	set guifont=Luxi_Mono:h10:cDEFAULT
	set guifont=Consolas:h10:cDEFAULT
endif
set guioptions+=a				" use gui tabline, if at all
set guioptions+=b      			" Add bottom scroll bar 'go'
set guioptions-=r
set guioptions-=R
set guioptions+=l				" always have left-hand toolbar
" set guioptions-=T				" don't display toolbar
" set guitablabel=%N/\ %t\ %M		" buffer number etc. in tab label (check tablineset.vim)
set history=50
set nohlsearch					" don't always highlight the last used search pattern (toggle with C-F3)
set ignorecase					" ignore case in searching
set incsearch					" do incremental searching
set isfname+=32                 " allow spaces in filenames
set nojoinspaces				" have only one space when lines are joined at the end of phrases
set keymodel=startsel,stopsel	" use windows' selection keys (Ctrl+Shift+Right etc.)
set keywordprg=pinfo
set laststatus=2				" always have a status line (1-only if 2 or more windows; 0-never)
set linebreak					" display-wrap lines at 'breakat' characters, not at the last character that fits into the line
set matchpairs=(:),{:},[:],<:>
set nomodeline
" set modeline
" set modelines=1
set mouse=ar					" mouse in all modes
" set mousefocus				" no real reason for this
set mousehide					" hides mouse after characters are typed
set mousemodel=popup_setpos		" Right mouse button moves the cursor and pops up a menu there. Shift-left extends selection
" set mousemodel=popup			" Right mouse button pops up a menu. Shift-left extends selection
set number						" number my lines
set pastetoggle=<F11>			" toggle paste/formatting
set report=0					" show report when >=N lines have changed (0 -> always)
set ruler						" show the cursor position all the time
set scrolljump=1				" scroll in one line at a time when moving out of the screen
set scrolloff=0					" don't scroll in any context at top/bottom of screen
set selection=exclusive			" don't include last character of selection, e.g. in delete commands (but allow to select past end-of-line)
set sessionoptions-=curdir
set sessionoptions+=resize,winpos	" remember vim window size and pos. in :mksession
set sessionoptions+=slash,unix		" always assume unix format of filenames/paths, even if in windows (for sharing, doesn't work the other way round)
set sessionoptions+=localoptions,sesdir
if !has("unix")
    set shellslash
endif
set shiftround					" indent on rounds of shiftwidth
set shiftwidth=4				" number of spaces for autoindenting
set shortmess=aI				" abbreviate (all) status messages and skip intro
set showbreak=">>> "			" character to signify the continuation of a wrapped line
set showcmd						" display incomplete commands
set showfulltag					" show more info in insert mode completion
set noshowmatch					" don't jump to matching braces (but we have the matchparen plugin active...)
set showmode					" display current mode
set showtabline=2				" display tabline always (2), never (0) or only if necessary (1)
set sidescroll=1				" scroll sideways in single-column steps
set sidescrolloff=20			" keep large horiz. context scrolled in
set smartcase					" override ignorecase when search pattern contains UpperCase letters
set smarttab					" chose wisely between tabwidth and indent-width
set nosmartindent				" don't, or we end up with indented lines in plain text
" We're setting spelling options/mappings etc. all below...
set softtabstop=4               " how many spaces is a tab to count for and vice versa
set nostartofline				" keep cursor at column on page commands
" Statuslines
"       One favourite:
" set   statusline=[%n]\ %f\ %(\ %M%R%H)%)\=Pos=<%l\,%c%V>\ %P\=ASCII=%b\ HEX=%B)%=(c)\ Michael\ Prokop
"       My favourite statusline is:
" set statusline=%<[%n]\ %f\ %y\ %r\ %1*%m%*%w%=%(Column:\ %c%V%)%4(%)%-10(Line:\ %l%)\ %4(%)%p%%\ %P\ \ \ \ \ \ ASCII=%b\ HEX=%B\ \ \ \ \ %=(c)\ Michael\ Prokop
"
" 040519 $HOME/.vim/plugin/minibufexpl.vim - see: http://www.vim.org/scripts/script.php?script_id=159
" Thomas Winkler modified this script and wrote an own function (see below):
"
set statusline=%<\ %{GetBufferList()}\ %y\ %1*%*%w%=%(Col:\ %c%V%)%2(%)%-1(Line:\ %l/%L%)\ \ \ %p%%\ \ \ ASCII=%b\ HEX=%B\ %=
set suffixes=.bak,~,.o,.h,.info,.swp,.aux,.bbl,.blg,.dvi,.idx,.lof,.log,.lot,.pdf,.ps,.toc      " set suffixes to ignore in command-line completion
if has("terminfo")
    set t_Co=8
    set t_Sf=[3%p1%dm
    set t_Sb=[4%p1%dm
else
    set t_Co=8
    set t_Sf=[3%dm
    set t_Sb=[4%dm
endif
" let g:tex_flavor = "latex"
set tabstop=8
if has("unix")
    set tags=$VIMRUNTIME/../vim.tags,~/.vim/vim.tags,~/tags,./tags;/    " where are tags files
else
    set tags=$VIMRUNTIME/../vim.tags,$VIM\tags,.\tags;
endif
" if &term =~ "xterm"
"   set term=xterm-16color
" endif
" set textwidth=72
set title						" display information in the title
" set ttyfast					" yes - local terminal is fast.
"       ttybuiltin: default value is on
"       When on, the builtin termcaps are searched before the external ones.
"       When off the builtin termcaps are searched after the external ones.
" set ttybuiltin
set whichwrap=b,s,<,>,[,]		" allow cursor keys to wrap to next line
set wildcharm=<C-Z>				" define char to be used as esc in macros etc.
set wildmenu					" use navigation in tab-opened auto-completion "menus"
set wildmode=longest,list
set winminheight=0				" don't display any lines of minimized windows
set winminwidth=0				" the same
set writebackup
set wrapmargin=10


" }}}
" =============================================================================
" My variable settings {{{
" =============================================================================
"

" TAGLIST {{{ - - - - -
if has("unix")
    let Tlist_Ctags_Cmd='/usr/bin/ctags'      " Taglist's variable denoting ctags executable
endif
" }}}

" sys-utils {{{ - - - - -
if has("unix")
else
  let g:unix_layer_installed=1
endif
" }}}

" modeliner {{{ - - - - -
" provides :Modeline command to insert a modeline next to the current line
let g:Modeliner_format = 'fenc= ts= sts= sw= et'
" }}}

" MUTT {{{ - - - - - - -
if has("unix")
    let g:aliases_file='~/.mutt/aliases'            " In order to work with mutt aliases in email-editing
endif
" }}}

" MRU {{{ - - - - -
" I am using "MRU" by Gergely Kontra <kgergely@mcl.hu>, not "mru" by
" Yegappan Lakshmanan.
" It is older, but I like it having the MRU list in the file dialogue, not
" generating a separate window. I have added the Exclusion Feature of
" "mru" to it, tho, so:
" By default, all the edited file names will be added to the MRU list. If you
" want to exclude file names matching a list of patterns, you can set the
" MRU_Exclude_Files variable to a list of Vim regular expressions. By default,
" this variable is set to an empty string. For example, to not include files
" in the temporary (/tmp, /var/tmp and d:\temp) directories, you can set the
" MRU_Exclude_Files variable to

let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*\|^/home/wagner/.w3m/w3mtmp.*|^d:\\temp\\.*\|c:\\temp\\.*'
" if has("unix")
"    let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*\|^/home/wagner/.w3m/w3mtmp.*'		" For Unix
" else
"    let MRU_Exclude_Files = '^d:\\temp\\.*\|c:\\temp\\.*'       " For MS-Windows
" endif
let MRU_num = 6
" }}}

 " Tabs {{{ - - - - - -
if has('gui_running')
  " general control variable
  let g:toggleTabs = 1
  " use tabs in mru and favmenu (undefine it to not open in tabs)
  let g:openInTabs = 1
else
  " general control variable
  let g:toggleTabs = 0
  let g:no_load_TabLineSet = 1
endif

" }}}

" SNIPPETS {{{ - - - - - - -
    let g:snips_author = "Andreas Wagner"
" }}}

" }}}
" =============================================================================
" Abbreviations {{{
" =============================================================================
"

"  Moved the abbreviations *before* the mappings as
"  some of the abbreviations get used with some mappings.
"
"  Let's start of with some standard strings
"  like the alphabet and the digits:
"
"     Yalpha : The lower letter alphabet.
  iab Yalpha abcdefghijklmnopqrstuvwxyz
"
"     YALPHA : The upper letter alphabet.
  iab YALPHA ABCDEFGHIJKLMNOPQRSTUVWXYZ
"
"     Ydigit: The ten digits.
  iab Ydigit  1234567890
"
"     Yruler: A "ruler" - nice for counting the length of words.
  iab Yruler  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

" Abbreviations for some important numbers:
"  iab Npi 3.1415926535897932384626433832795028841972
"  iab Ne  2.7182818284590452353602874713526624977573

" Abbreviations for some classic long words:
" and now a word with all three umlauts and the 'ß', too:
  iab YHRA "Heizölrückstoßabdämpfung"
"
"     Phrases.
"     Yanfs: Changing the Subject within a message.  (Hi, Monty Python!)
  iab Yanfs  And now for something completely different...

"     Ybtdt:  It's been dejavu all over again.
  iab Ybtdt   Been there, done that, got the tshirt.

"     Ywyot:  people who use the browser for email and news...
  iab Ywyot when your only tool is a hammer - every problem looks like a nail.

" classic pangrams (which include every letter of the alphabet):
  iab Ypangram Bei jedem klugen Wort von Sokrates rief Xanthippe zynisch: Quatsch!

" Inserting an ellipsis to indicate deleted text
"  iab  Yell  [...]
  iab  Yel  [...]<CR>

" Use when posting in newsgroup or writing mail-replies
  iab  Ysc <C-O>o[schnipp]<CR><C-O>k$
"  vmap ,ell c[...]<ESC>

" Often used filenames - only needed these on the command line:
if has("unix")
  cab Mrc	~/.mutt/main
"  cab Vrc	~/.vim/.vimrc
else
"  cab Vrc	d:\daten\aw\vim\.vimrc
endif
cab Vrc 	$HOME/.vim/.vimrc'

" read my 'autocorrection' list...
" source $HOME/.vim/.abbreviations
if has("unix")
    source $HOME/.vim/.abbreviations
else
    source $HOME/vimfiles/.abbreviations
endif


" }}}
" =============================================================================
" COMMANDS {{{
" =============================================================================

"  Source general files {{{ ---------------------------------------------------
source $VIMRUNTIME/menu.vim
source $VIMRUNTIME/syntax/syntax.vim

" }}}

" Load Pathogen to handle bundles in .vim/bundle {{{ ---

" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = ["vim-supertab"]

execute pathogen#infect()
execute pathogen#helptags()

" }}}

filetype plugin indent on      " launch plugins and indentation based on filetype

"  Autocommands {{{ -----------------------------------------------------------

" init empty
autocmd!

" For all text files set 'textwidth' to 78 characters.
" autocmd FileType text setlocal textwidth=78
autocmd FileType text 	let b:show_doublons_active = 0

" Detect mutt tempfiles
if has("unix")
    au! BufRead,BufNewFile /tmp/mutt*   setfiletype mail
endif

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
" }}}

hi CursorLine guibg=Cyan

" Syntax Hightlighting ON {{{ ------------------------------------------------

syntax on       " Add syntax highlighting

" }}}

" }}}
" =============================================================================
" MAPPINGS {{{
" =============================================================================
"
" -----------------------------------------------------------------------------
" info about all those mapping commands {{{
" -----------------------------------------------------------------------------
" :map      Normal, Visual and Operator-pending
" :vmap     Visual
" :nmap     Normal
" :omap     Operator-pending
" :map!     Insert and Command-line
" :imap     Insert
" :cmap     Command-line

" :noremap  Normal, Visual and Operator-pending
" :vnoremap Visual
" :nnoremap Normal
" :onoremap Operator-pending
" :noremap! Insert and Command-line
" :inoremap Insert

" }}}
" -----------------------------------------------------------------------------
" MOVEMENTS {{{
" -----------------------------------------------------------------------------
"

" remap escape key to <jj> so it can be typed faster
  imap jj <esc>

" in normal mode, use backspace to go a word backwards
"  nmap  b

" let "G" go to the END of the last line
  map G G$

" move to the next on-screen line on wrapped lines
imap <silent> <Down> <C-O>gj
imap <silent> <Up> <C-O>gk
nmap <silent> <Down> gj
nmap <silent> <Up> gk

" windows navigation - - - - - - - - - - -
" move between split windows with <Ctrl-j> and <Ctrl-k> (horiz.) and <Ctrl-h>, <Ctrl-l> (vert.)
" map <C-H> <C-W>h
" map <C-J> <C-W>j
" map <C-K> <C-W>k
" map <C-L> <C-W>l
" imap <C-H> <C-O><C-H>
" imap <C-J> <C-O><C-J>
" imap <C-K> <C-O><C-K>
" imap <C-L> <C-O><C-L>

" or do it with Alt-Arrow keys
 map <silent> <M-Up> :wincmd k<CR>
 map <silent> <M-Down> :wincmd j<CR>
 map <silent> <M-Left> :wincmd h<CR>
 map <silent> <M-Right> :wincmd l<CR>
imap <silent> <M-Up> <C-O><M-Up>
imap <silent> <M-Down> <C-O><M-Down>
imap <silent> <M-Left> <C-O><M-Left>
imap <silent> <M-Right> <C-O><M-Right>

" - - - - - - - - - - - - - - - - - - - - - - - -
" move back in history with <C-[>
" nmap <C-[> <C-O>          " breaks insert and cursor keys somehow - FIXME.

" - - - - - - - - - - - - - - - - - - - - - - - -
" mode search for visually selected text with <g/> (forward) and <g?> (backw.)
function! VsearchPatternSave()
   let l:temp = @@
   normal gvy
   let @/ = substitute(escape(@@, '/'), "\n", "\\\\n", "g")
   let @@ = l:temp
   unlet l:temp
endfunction
vmap g/ :call VsearchPatternSave()<CR>/<C-R>/<CR>
vmap g? :call VsearchPatternSave()<CR>?<C-R>/<CR>

" Open a search for the word under the cursor in a second window
map ,s2 :let @/=expand("<cword>") <BAR> split <BAR> execute 'normal n'<CR>


" - - - - - - - - - - - - - - - - - - - - - - - -
" Visualmap plugin to toggle/move visible (book)marks as in UEdit
" I've left the defaults, but mention them here to be able to quickly
" look them up...
"
" map something	<Plug>Vm_toggle_sign
" default: <c-F2>
"
" map something	<Plug>Vm_goto_next_sign
" default: <F2>
"
" map something	<Plug>Vm_goto_prev_sign
" default: <s-F2>

imap <C-F2> <ESC><Plug>Vm_toggle_sign

" }}}
" -----------------------------------------------------------------------------
" APPEARANCE {{{
" -----------------------------------------------------------------------------
"

"  F11 toggles Paste in Insert mode (see above, set pastetoggle)

" C-F7 toggles Menu and Toolbar
function! ToggleMenuToolbar()
	if &guioptions=~'T'
		set guioptions-=T
	else
		set guioptions+=T
	endif
	if &guioptions=~'m'
		set guioptions-=m
	else
		set guioptions+=m
	endif
endfunction
 map <C-F7> :call ToggleMenuToolbar()<cr>
imap <C-F7> <C-O><C-F7>

" Switch between nlsearch and nohlsearc
   map <C-F3> :set hlsearch!<CR>
  imap <C-F3> <C-O><C-F3>

" toggle wrapping TODO: make this affect sidescroll settings.
   map <C-F4> :set wrap!<CR>
  imap <C-F4> <C-O><C-F4>

" Paralleles Editieren TODO: FIXME
" map <C-P> :vsplit<CR><C-M>:bn<CR><C-M>:set scrollbind<CR><C-M><C-W><C-W>:set scrollbind<CR><C-M><C-W><C-W>
  map <C-P> :vsplit<CR>:bn<CR>:set scrollbind<CR><C-W><C-W>:set scrollbind<CR><C-W><C-W>

" Set background dark. TODO: Switch dark/light
  map ,bg :if &background=="light"<CR>:set background=dark<CR>:else<CR>:set background=light<CR>:endif<CR><CR>

" Highlight always some keywords
  syn keyword TODO FIXME XXX


" Folds ------------------------------------------------------------------------

" FoldDigest - open a digest of folds in a new buffer - use folddigest.
imap ,fd <Plug>FoldDigest

" Toggle fold state between closed and opened.
"
" If there is no fold at current line, just moves forward.
" If it is present, reverse it's state.
fun! ToggleFold()
  if foldlevel('.') == 0
    normal! l
  else
    if foldclosed('.') < 0
      . foldclose
    else
      . foldopen
    endif
  endif
  " Clear status line
  echo
endfun
" Map this function to Space key.
nnoremap <space> :call ToggleFold()<CR>
" ...and to the dash as well.
nnoremap - :call ToggleFold()<CR>

" This will select a whole line of text or it will select everything in a fold.
  nmap ,y <S-v>y

" in-/decrease foldlevel (zoom out/in)
  map  ,zo          :set foldlevel-=1<CR>
  map  ,zi          :set foldlevel+=1<CR>

" TODO: Map something to save the foldview
" :mkview

" TODO: Map something to restore the foldview
" :loadview

" TODO: FIXME
function! MyFoldText()
  let line = getline(v:foldstart)
  let vlines = v:foldendline-v:foldstartline
  let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')		" }}}
  return  sub . "level: " . v:foldlevel . " [" . v:foldstartline . "-" .
			  \ v:foldendline . " (" . vlines . "lines)]"
endfunction


" }}}
" -----------------------------------------------------------------------------
" BUFFERS {{{
" -----------------------------------------------------------------------------

" Buffer Navigation
map <C-N> :wnext<CR>
imap <C-N> <C-O><C-N>
map <C-P> :wprev<CR>
imap <C-P> <C-O><C-P>

" }}}
" -----------------------------------------------------------------------------
" TABS {{{
" -----------------------------------------------------------------------------

" If I have a particular buffer I want to open in a tab, after I've loaded it, I use ':tabfind filename'
" and vim opens that buffer in a tab. Or, I just open a blank tab (':tabnew') then do a :bu to pull that file into the tab.
" Alternative way to move current window to a new tab is: <Ctrl-w> T
" When you use :tab ball - it makes out of all buffers a tab

" http://www.vim.org/tips/tip.php?tip_id=1313
" Show tabs by pressing alt down, hide tabs by pressing alt up
" map <M-Up> :tabo<CR>:set lines+=1<CR>:let g:toggleTabs = 0<CR>
" map <M-Down> :set lines-=1<CR>:tab ball<CR>:let g:toggleTabs = 1<CR>

function! EnableTabs()
  if g:toggleTabs==1
    tabo
    set lines+=1
    let g:toggleTabs = 0
  endif
endfunction

function! DisableTabs()
  if g:toggleTabs==0
    set lines-=1
    tab ball
    let g:toggleTabs = 1
  endif
endfunction

map <M-Up> 	 :call EnableTabs()<CR>
map <M-Down> :call DisableTabs()<CR>

" tab navigation (next tab or next buffer) with alt left / alt right
map <silent><M-Right> :if g:toggleTabs == 1<CR>:tabnext<CR>:else<CR>:bn<CR>:endif<CR>
map <silent><M-Left> :if g:toggleTabs == 1<CR>:tabprevious<CR>:else<CR>:bp<CR>:endif<CR>

" move the current tab to back or front
" map <silent><A-S-Right> :if g:toggleTabs == 1<CR>:tabm<CR>:endif<CR>
" map <silent><A-S-Left> :if g:toggleTabs == 1<CR>:tabm 0<CR>:endif<CR>
" or rather like this: move current tab to left or right
" http://www.vim.org/tips/tip.php?tip_id=1233
noremap <silent> <M-S-Left>  :if g:toggleTabs == 1<CR>:exe "silent! tabmove " . (tabpagenr() - 2)<CR>:endif<CR>
noremap <silent> <M-S-Right> :if g:toggleTabs == 1<CR>:exe "silent! tabmove " . tabpagenr()<CR>:endif<CR>

" when pressing F3, open all buffer in tabs / close all tabs
" map <silent><F3> :if g:toggleTabs == 1<CR>:tabo<CR>:set lines+=3<CR>:let g:toggleTabs = 0<CR>:else<CR>:set lines-=3<CR>:tab ball<CR>:let g:toggleTabs = 1<CR>:endif<CR>

" after closing a tab, go to left tab, not to the right
" http://www.vim.org/tips/tip.php?tip_id=1333
noremap <silent><C-S-w> :if tabpagenr() != tabpagenr('$')<cr>:tabclose<cr>:if tabpagenr() > 1<cr>:tabprev<cr>:endif<cr>:else<cr>:tabclose<cr>:endif<cr>

" CTRL+] that jumps to tag under the cursor, so it opens file with tag but in new tab
" http://www.vim.org/tips/tip.php?tip_id=1221
map <C-W>] <C-W>]:tab split<CR>gT:q<CR>gt

" TabLineSet.vim customization
" http://www.vim.org/scripts/script.php?script_id=1507
" Change this to let tabs grow into GUI tab scrolling buttons:
let g:TabLineSet_max_cols=10

" control the verbose settings on the fly
" This one toggles all indicators off (TabView):
nmap <silent> <Leader>tv :call TabLineSet_verbose_toggle()<CR>

" This one rotates through a list of option settings defined in TabLineSet.vim:
nmap <silent> <Leader>tr :call TabLineSet_verbose_rotate()<CR>



" }}}
" -----------------------------------------------------------------------------
" SAVING {{{
" -----------------------------------------------------------------------------
"

" When I let Vim write the current buffer I frequently mistype the
" command ":w" as ":W" - so I have to remap it to correct this typo:
nmap :W :w
nmap :W! :w!

" just so with q
nmap :Q :q
nmap :Q! :q!

" save with <Ctrl-S>
map <silent> <C-S> :w<CR>
imap <silent> <C-S> <C-O><C-S>

" Save function for interaction with ROX-savebox
" unmapped as of yet
function! Save()
 let tmpname = tempname()
 let fname = expand('%')
 if fname == ''
      let fname = 'TextFile'
 endif
 silent exec 'write !savebox ' . fname . ' &gt; ' . tmpname
 let newname = system('cat ' . tmpname)
 let tmp = system('rm ' . tmpname)
 if tmpname != ''
      exec 'file ' . escape(newname, ' ')
      set nomodified
 endif
endfunction
" map <F3> :call Save()<CR>

" A mapping to make a backup of the current file.
fun! WriteBackup()
        let _modified = &modified
        let fname = expand("%:p:r") . "." . strftime("%Y%m%d-%H%M") . "." . expand("%:e")
        silent exe ":w " . fnameescape(fname)
        let &modified = _modified
        echo "Wrote " . fname
endfun
map ,bck :call WriteBackup()<CR>


function! DissSessionSave()
    wall
    if has("unix")
      mksession! $HOME/.vim/sessions/Diss-Session.vim
      wviminfo! $HOME/.vim/sessions/Diss-Session.viminfo
    endif
endfunction
map ,dss :call DissSessionSave()<CR>
map ,dsq :call DissSessionSave()<CR>:q<CR>


" }}}
" -----------------------------------------------------------------------------
" FORMATTING {{{
" -----------------------------------------------------------------------------
"

" Paragraph auto-formatting - - - - - - - - - - - - - - - - - - - - - - -

" Format current paragraph with Ctrl-Q and go back to previous position.
" It inserts CTRL-Z at the current position to enable to rebound to the
" previous position within the text.  [Hello, Y. K. Puckett!]
 map Q i<C-Z><ESC>gqip?<C-Z><CR>x
imap <C-Q>  <C-O>Qi

" reformat the paragraph taking textwidth from current cursor position
" map ,tw :set textwidth=<C-R>=col(".")<CR><C-Q>
" TODO: test my remembering version
 map ,tw :let temptw=&tw<CR>:set tw=<C-R>=col(".")<CR><C-Q>:set tw=temptw<CR>:unlet temptw<CR>

" Narrow/Widen current paragraph by adjusting the current textwidth
" and using internal formatting (TODO: try out, possibly use other keybindings?):
  map  ,<          :set tw-=2<CR>gqip
  vmap ,<     <esc>:set tw-=2<CR>gvgqgv
  map  ,>          :set tw+=2<CR>gqip
  vmap ,>     <esc>:set tw+=2<CR>gvgqgv



" ANDERES - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Quick insertion of an empty line in normal mode:
  nmap <CR> O<ESC>

" "tal" is the "trailer alignment" filter program  http://thomasjensen.com/software/tal/
if has("unix")
  vmap ,tal !tal -p 1<CR>
endif

" Remove <CR> that disturb
"  map ,w2u :%s///g
  map ,w2u :%s/\r$/\r/g<CR>

" Substitute runs of two or more space to a single space:
" ksr = "kill space runs"
nmap ,ksr  :%s/  \+/ /g
vmap ,ksr   :s/  \+/ /g

" Convert all blocks of blank lines (containing whitespace only)
"   into *one* empty line (within current visual):
" sqz = "squeeze blank lines"
"  map ,Sbl :g/^\s*$/,/[^ <C-I>]/-j
"  map ,Sbl :g/^\s*$/,/[^ \t]/-j
   map ,sqz :g/^\s*$/,/\S/-j

" Show or Trim Spaces at ends of lines or before tabstops
function! ShowSpaces( ...)
 let @/="\\v(\\s+$)|( +\\ze\\t)"
 let oldhlsearch=&hlsearch
 if !a:0
   let &hlsearch=!&hlsearch
 else
   let &hlsearch=a:1
 end
 return oldhlsearch
endfunction

function! TrimSpaces() range
 let oldhlsearch=ShowSpaces( 1)
 execute a:firstline.",".a:lastline."substitute /\\(^--\\)\\@<!\\s*$//ge"
 let &hlsearch=oldhlsearch
endfunction

command! -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
command! -bar -nargs=0 -range=% TrimSpaces execute "normal i\<C-Z\>\<C-O\>:<line1>,<line2>call TrimSpaces()\<CR\>\<C-O\>?\<C-Z\>\<CR\>\<C-O\>x"
nnoremap ,sws     :ShowSpaces 1<cr>
nnoremap ,tws     :TrimSpaces<cr>
vnoremap ,tws     :TrimSpaces<cr>

set list listchars=tab:»-,trail:¬,extends:>,precedes:<
" autocmd FileWritePre   * :call TrimSpaces()
" autocmd FileAppendPre  * :call TrimSpaces()
" autocmd FilterWritePre * :call TrimSpaces()
" autocmd BufWritePre    * :call TrimSpaces()
" autocmd FileWritePre   * :TrimSpaces
" autocmd FileAppendPre  * :TrimSpaces
" autocmd FilterWritePre * :TrimSpaces
" autocmd BufWritePre    * :TrimSpaces

" un-quoted-printable a range
function! s:FromQuoPri( ) range
  exec a:firstline.",".a:lastline.'s/=\(\x\x\|\n\)/\=submatch(1)=="\n"?"":nr2char("0x".submatch(1))/ge'
endfunc
nnoremap <silent> ,qp  :0/^$/+1,$call <SID>FromQuoPri()<cr>
vnoremap <silent> ,qp  :call <SID>FromQuoPri()<cr>


" Swapping words and character - - - - - - - - - - - - - - -

" swap characters:
    nmap <silent> ,swc    xph

" TODO: make sure this works with umlauts, accents etc.!!
" swap a word with the next word. Works even across punctuation ("abc = def")
"    nmap <silent> ,sw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<CR><C-O><C-L>
" Making vim handle word swapping across a newline is fairly straightforward:
    nmap <silent> ,sww    "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-O><C-L>

" swap a word to-the-left and to-the-right:
    nnoremap <silent> ,swl \"_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-O><C-L>
    nnoremap <silent> ,swr \"_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-O>/\w\+\_W\+<CR><C-L>

" swap paragraphs:
  nnoremap ,swp  {dap}p{


" Pasting - - - - - - - - - - - - - - - - - - -
"
" Make shift-insert work like in Xterm
    map! <S-Insert> <MiddleMouse>

" Make p in Visual mode replace the selected text with the "" register.
    vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

" Occasionally I later want already written text parts to put in parenthesis.
" I use the following macro, which brackets previously visually selected text.
" I mapped it with ,(. TODO: Check it out.
"    vnoremap ,( <ESC>`>a)<ESC>`<i(<ESC>

" map <Alt-a> to fix an indent-broken paste
    imap <silent> <M-A> <C-O>u<C-O>:set paste<CR><C-O>.<C-O>:set nopaste<CR>

" TODO: make it platform-neutral
" copy text from one file to a different one
    nmap    _C      :!echo ""> ~/.vi_tmp<CR><CR>:w! ~/.vi_tmp<CR>
    vmap    _C      :w! ~/.vi_tmp<CR>
    nmap    _P      :r ~/.vi_tmp<CR>

" }}}
" -----------------------------------------------------------------------------
" SPELLCHECKING {{{ - - - - - -
" -----------------------------------------------------------------------------
"
" builtin from vim7 onwards.

" here is (parts of) Reinhard Wobst's script
" (http://www.sax.de/unix-stammtisch/docs/misc/vim7.pdf#search=%22wobst%20stammtisch%20vim7%22):
function! Sel_lang()
  let g:langcnt = (g:langcnt+1) % len(g:spellst)
  let lang = g:spellst[g:langcnt]
  echo "language " . lang . " selected"
  exe "set spelllang=" . lang
endfunction

set nospell
set spelllang=de_20,en
set spellsuggest=fast,10
hi SpellBad ctermfg=Red ctermbg=Gray cterm=underline
hi SpellCap ctermfg=blue ctermbg=Gray cterm=underline
let spellst = ["de,en,fr", "de_20", "de", "en", "fr", "de_20,en", "de_20,en,fr", "de,en", "en,fr"]
let langcnt = 0

" nmap <Esc>A :set spell<CR>
" nmap <Esc>q :set nospell<CR>
" nmap <Esc>l :call Sel_lang()<CR>
" nmap <Esc>? z=
" nmap <Esc>a zg
" nmap <Esc>i	zG

" Here are my mappings inspired by Clabaudt's vimspell (script_id=465):
" \sA : start/stop spell mode
" \sq : stop spell mode
" \sl : switch languages
" \sn : move cursor to the next     spelling error
" \sp : move cursos to the previous spelling error
" \sa : add word into user dict.
" \si : ignore/accept for this session only
" \s? : look for alternative spellings of word under cursor
" (in insert mode, get suggestions with Ctrl-x s, and cancel with Ctrl-e)

map 	<leader>sA 	:setlocal spell!<CR>
imap 	<leader>sA	<C-o>:setlocal spell!<CR>
map 	<leader>sq 	:setlocal nospell<CR>
imap 	<leader>sq	<C-o>:setlocal nospell<CR>
map 	<leader>sl 	:call Sel_lang()<CR>
imap	<leader>sl	<C-o>:call Sel_lang()<CR>
map 	<leader>sn 	]s
imap	<leader>sn	<C-O>]s
map 	<leader>sp 	[s
imap	<leader>sp	<C-O>[s
map 	<leader>sa 	zg
imap	<leader>sa	<C-O>zg
map 	<leader>si 	zG
imap	<leader>si	<C-O>zG
map 	<leader>s? 	z=
imap	<leader>s?	<C-O>z=

" highlight double occurrencies of words {{{ - - - - -
" (from an idea of Ajit Thakkar - http://vim.sourceforge.net/tips/tip.php?tip_id=206)
syn match texDoubledWord "\c\<\(\a\+\)\_s\+\1\>"
function! ShowDoublons()
  if b:show_doublons_active == 1
	let b:show_doublons_active = 0
    hi def link texDoubledWord NONE
  else
	let b:show_doublons_active = 1
    hi def link texDoubledWord Error
  endif
endfunction
map ,dbl :call ShowDoublons()<CR>

" }}}

" map f8 to aspell {{{ - - - - -

map <f8> :w<CR>:!aspell -c --encoding=utf-8 --lang=de_DE %<CR>
imap <f8> <C-o><f8>

" }}}

" }}}
" -----------------------------------------------------------------------------
" OMNICOMPLETION {{{
" -----------------------------------------------------------------------------
"
" invoke with Ctrl-x Ctrl-o, cancel with Ctrl-e

" }}}
" -----------------------------------------------------------------------------
" SCREEN (the program) settings {{{
" -----------------------------------------------------------------------------
"

" Disable the suspend for ^Z.
" I use Vim under "screen" where a suspend would lose the
" connection to the terminal - which is what I want to avoid.
  map <C-Z> :shell

" Ctrl-A is not available when running screen, so map it to ";A"
  map ;A <C-A>

" edit screen-temporary file (exchange)
  map   ## :e /tmp/screen-exchange

" }}}
" -----------------------------------------------------------------------------
" MISC OTHER FUNCTIONS/ROUTINES {{{
" -----------------------------------------------------------------------------
"

" Vimfootnotes
    nmap ,fnh :FootnoteComs<CR>             " get help
    imap ,fni <Plug>AddVimFootnote
    imap ,fnr <Plug>ReturnFromFootnote

" Cream-Multireplace - prompted search and replace across multiple files...
    imap ,sr <C-o>:call Cream_replacemulti()<CR>
    vmap ,sr :<C-u>call Cream_replacemulti()<CR>
    nmap ,sr      :call Cream_replacemulti()<CR>

" A macro which allows you to open a "shell" in a new window
" - enable it with :vish
map ,sh :so $HOME/.vim/macros/vish.vim<CR>

" The following code will add a function heading and position your
" cursor just after Description so that one can document as one proceeds with
" code. TODO: another keybinding?
function! FileHeading()
  let s:line=line(".")
  call setline(s:line,"/***************************************************")
  call append(s:line,"* Filename:    ")
  call append(s:line+1,"* Description: ")
  call append(s:line+2,"* Author:      Andreas Wagner")
  call append(s:line+3,"* Date:        ".strftime("%b %d %Y"))
  call append(s:line+4,"* *************************************************/")
  unlet s:line
endfunction
map ,fh mz:execute FileHeading()<CR>`zjA
imap ,fh <C-O>,fh

" Insert TimeStamp into files - very usefull!
" first add a function that returns a time stamp in the desired format
if !exists("*TimeStamp")
  fun TimeStamp()
    return "Time-stamp: <" . strftime("%d %b %Y %X") . " Andreas Wagner>"
  endfun
endif

" this function searches for an existing time stamp and updates it using the
" function declared above
if !exists("*UpdateTimeStamp")
  fun UpdateTimeStamp()
    if (match(getline(1),"Time-stamp: <.*>")) > 1
      exe "1,1 s/Time-stamp: <.*>/" . TimeStamp()
    endif
  endfun
endif

" add an autocommand to update an existing time stamp when writing the file
" It uses the functions above to replace the time stamp and restores cursor
" position afterwards (this is from the FAQ)
autocmd BufWritePre,FileWritePre *   ks|call UpdateTimeStamp()|'s

" abbreviation to manually enter a timestamp. Just type YTS in insert mode
iab YTS <C-R>=TimeStamp()<CR>
" finally a key mapping to manually insert a TimeStamp
map ,ts :call UpdateTimeStamp()<CR>

" open url in current line in browser (or current file)
function! Browser ()
  let line = getline (".")
  let line = matchstr (line, "http[^ ]*")
  execute "!opera ".line
" execute "!opera "%:p
endfunction
map ,www :call Browser ()<CR>

" function for bufferlist in statusline - written by Thomas Winkler
  function! GetBufferList()
    let l:numBuffers = bufnr('$')
    let l:i = 0
    let l:bufferList = ''
    while(l:i <= l:numBuffers)
	let l:i = l:i + 1
	" check if buffer is listed
	if(getbufvar(l:i, '&buflisted') == 1)
	    let l:bufName = bufname(l:i)
	    if(strlen(l:bufName))
		if bufwinnr(l:i) != -1
			let l:shortBufName = fnamemodify(l:bufName, ":p:~")
		else
			let l:shortBufName = fnamemodify(l:bufName, ":t")
		endif
		let l:shortBufName = substitute(l:shortBufName, '[][()]', '', 'g')
		" check if buffer is readonly
		if (getbufvar(l:i, '&readonly'))
		    let l:shortBufName = l:shortBufName . '|RO'
		endif
		" check if buffer is currently open in a window
		if bufwinnr(l:i) != -1
		    let l:bufferList = l:bufferList . '[' . l:i . ':' . l:shortBufName . ']*'
		else
		    let l:bufferList = l:bufferList . '|' . l:i . ':' . l:shortBufName . '|'
		endif
		" check if buffer is modified
		if(getbufvar(l:i, '&modified') == 1)
		    let l:bufferList = l:bufferList . '+'
		endif
		let l:bufferList = l:bufferList  . ' '
	    endif
	endif
    endwhile
    return bufferList
  endfunction

" }}}
" -----------------------------------------------------------------------------
" VIMRC-EDITING {{{
" -----------------------------------------------------------------------------
"
"

" use VV to display VIMRUNTIME (which :version doesn't do)
  nmap VV :echo $VIMRUNTIME<CR>

  let vimrc=$HOME . '.vim/.vimrc'
  nn  ,lrc :source <C-R>=vimrc<CR><CR>
  nn  ,erc :edit   <C-R>=vimrc<CR><CR>

" }}}

"
" END OF MAPPINGS
"
" }}}



" =============================================================================
" MORE DOCUMENTATION {{{
" =============================================================================
"

" =============================================================================
" foldmethod:
"  {Visual}zf => Operator to create a fold
"  zi => enable/disable folds
"  zf => create fold
"  zv => view cursor-line
"  zd => delete one fold at the cursor
"  zD => delete all folds
"  za => toggle fold (open or close)
"  zc => close fold
"  zm => close more folds
"  zM => close all folds: set foldlevel to 0 (zero)
"  zo => open fold
"  zr => open more folds
"  zR => open all folds
"  zx => update folds: close manually opend folds

" =============================================================================
"
"        %               current file name
"        %<              current file name without extension
"        #               alternate file name for current window
"        #<              idem, without extension
"        #31             alternate file number 31
"        #31<            idem, without extension
"        <cword>         word under the cursor
"        <cWORD>         WORD under the cursor (see |WORD|)
"        <cfile>         path name under the cursor
"        <cfile><        idem, without extension
" =============================================================================
"
" Der aktuelle Status von vim, inklusive aller Optionen, der Commandhistory
" und der editierten Dateien, kann mit:
"         :mksession sessiondatei
" in die Datei sessiondatei gesichert werden. Mit dem Aufruf:
"         vim -S sessiondatei
" kann dieser Status restauriert werden, inklusive Cursorposition.


" }}}

"eof
