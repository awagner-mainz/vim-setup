" {{{1 added from Bram Molenaar's mail.vim ftplugin, which I have disabled otherwise ------

" Vim filetype plugin file
" Language:	Mail
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2004 Feb 20

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1
let b:undo_ftplugin = "setl modeline< tw< fo<"

" Don't use modelines in e-mail messages, avoid trojan horses
setlocal nomodeline

" Add mappings, unless the user didn't want this.
" if !exists("no_plugin_maps") && !exists("no_mail_maps")
"  " Quote text by inserting "> "
"  if !hasmapto('<Plug>MailQuote')
"    vmap <buffer> <LocalLeader>q <Plug>MailQuote
"    nmap <buffer> <LocalLeader>q <Plug>MailQuote
"  endif
"  vnoremap <buffer> <Plug>MailQuote :s/^/> /<CR>:noh<CR>``
"  nnoremap <buffer> <Plug>MailQuote :.,$s/^/> /<CR>:noh<CR>``
" endif

" }}} ------------------------------------------------------------------------------------


setlocal nomore		" don't pause when screen is full of messages
" setlocal cmdheight=2	" try and suppress hit-enter prompts
setlocal spell spelllang=de_20	" spell check with new german spellings


" {{{1	source special macros - - - - - - - - - - - - - - - - - - -

" source ~/.vim/macros/lhVimSpell.vim


" {{{1 check if attachments should be added -------------------------------------------
" by Hugo Haas <hugo@larve.net> - 20 June 2004
" based on an idea by The Doctor What explained at
" <mid:caq406$rq4$1@FreeBSD.csie.NCTU.edu.tw>
" added german language - Andreas Wagner 2005-03-22
"

autocmd BufUnload mutt-* call CheckAttachments()
function! CheckAttachments()
  let l:english = 'attach\(ing\|ed\|ment\)\?'
  let l:french = 'attach\(e\|er\|ée\?s\?\|ement\|ant\)'
  let l:geman = 'an\(ge\)\?h\[aä\]ng\(\[et\]|end\(e|es|en|em|er\)'
  let l:ic = &ignorecase
  if (l:ic == 0)
    set ignorecase
  endif
  if (search('^\([^>|].*\)\?\<\(re-\?\)\?\(' . l:english . '\|' . l:french . '\|' . l:german . '\)\>', "w") != 0)
    let l:temp = inputdialog("Do you want to attach a file? [Hit return] ")
  endif
  if (l:ic == 0)
    set noignorecase
  endif
  echo
endfunction


" {{{1 add a message header for an attachment (with ,A)  -------------------------------------------
" by Stefan 'Sec' Zehl on Wed, 25 Jan 2006
" http://blogmal.42.org/tidbits/vim-attach.story
"
" Gestartet wird des ganze mit ,a und beendet mit Escape.
" Tab macht wie gewohnt die Filename-Completion;
" wenn man in Subdirectories hinein will, muss man noch 
" einen / dazutippen, damit die Completion neu gestartet wird.

map __a_start :imap <C-V><CR> <C-O>__a_cmd\|imap <C-V><ESC> <C-V><ESC>__a_end\|imap <C-V><C-V><C-V><C-I> <C-V><C-N>\|imap <C-V><C-N> <C-V><C-X><C-V><C-F><CR>
noremap __a_end :iunmap <C-V><CR>\|iunmap <C-V><ESC>\|iunmap <C-V><C-V><C-V><C-I>\|iunmap <C-V><C-V><C-V><C-N><CR>dd`a:"ended.<CR>
noremap __a_cmd oAttach:<Space>
noremap __a_scmd 1G/^$/<CR>:noh<CR>OAttach:<Space>
map ,a ma__a_start__a_scmd



" {{{1 handle format-flowed text ---------------------------------------------------------

set textwidth=72
set fo+=tcqwra
" set ai
" set expandtab
" set updatetime=100

let MAIL_flowed = 0

function! s:flowed_context()
  if g:MAIL_flowed
    if (getline(line(".")) =~ "^-- $") || (getline(line((".")-1)) =~ "^-- $")
      set formatoptions-=aw
    else
      set formatoptions+=aw
    endif
  endif
endfunc

function! s:ft_mail()
  if &formatoptions =~# '\(w.*a\)\|\(a.*w\)'
    let g:MAIL_flowed = 1
  else
    let g:MAIL_flowed = 0
  endif
  augroup Mail
    au!
    au CursorHold * call <SID>flowed_context()
  augroup END
endfunc

" augroup Mail
"    au!
"    au CursorHold * call <SID>flowed_context()
" augroup END

function! Fixflowed()
   " save position
   let l = line(".")
   let c = col(".")
   normal G$
   " whiles are used to avoid nasty error messages
   " add spaces to the end of every line
   while search('\([^]> :]\)\n\(>[> ]*[^> ]\)','w') > 0
      silent s/\([^]> :]\)\n\(>[> ]*[^> ]\)/\1 \r\2/g
   endwhile
   " now, fix the wockas spacing from the text
   while search('^\([> ]*>\)\([^> ]\)','w') > 0
      silent s/^\([> ]*>\)\([^> ]\)/\1 \2/
   endwhile
  " now, compress the wockas
   while search('^\(>>*\) \(>>*\( [^>]\)*\)', 'w') > 0
      silent s/^\(>>*\) \(>>*\( [^>]\)*\)/\1\2/
   endwhile
   " restore the original location, such as it is
   execute l . " normal " . c . "|"
endfunction

" call s:ft_mail()
" call Fixflowed()

"{{{1 Fold Quotations - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

set foldlevel=5
set foldmethod=expr
set foldexpr=strlen(substitute(substitute(getline(v:lnum),'\\s','',\"g\"),'[^>].*','',''))

" You can try it out on this text:
"
" > quoted text he wrote
" > quoted text he wrote
" >> double quoted text I wrote
" >> double quoted text I wrote
"
" Explanation for the 'foldexpr' used in the example (inside out):
"  getline(v:lnum)gets the current line
"  substitute(...,'\\s','','g')removes all white space from the line
"  substitute(...,'[^>].*','',''))removes everything after leading '>'s
"  strlen(...)counts the length of the string, which is the number of '>'s found
"
" Note that a backslash must be inserted before every space, double quote and
" backslash for the ":set" command.  If this confuses you, do
"  set foldexpr
"
" to check the actual resulting value.  To correct a complicated expression, use the command-line completion:
"  set foldexpr=<Tab>
" Where <Tab> is a real Tab.  Vim will fill in the previous value, which you can then edit.
"
" When the expression gets more complicated you should put it in a function and set 'foldexpr' to call that function.
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


"{{{1 Clear (makes empty) all lines which start with '>' - - - - - - - - - - -
"     and any amount of following spaces.
"     cqel = "clear quoted empty lines"

" nmap ,cqel :%s/^[> ]*$//
" vmap ,cqel  :s/^[> ]*$//
" nmap ,cqel :%s/^[><C-I> ]\+$//
" vmap ,cqel  :s/^[><C-I> ]\+$//
  nmap ,cqel :%s/^[>]\+$//<cr>
  vmap ,cqel  :s/^[><C-I> ]\+$//<cr>
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


"{{{1 d-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
"     use d--, y--, to handle everything up to the signature. (from luc hermitte's
"     mail ftplugin)

" Operator Pending Mode Mapping:
onoremap -- /\n^-- \=$\\|\%$/+0<cr>/€<cr>
" explanation of the pattern :
" 1- either match a new line (\n) followed by the double dashes alone on a
"    line
" 2- or match the last line (\%: line ; $:last)
"    the {offset} of '+0' permit to match the end of the new line or the 
"    very end of the file.
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


"{{{1 Hooks - - - - - - - - - - - - - - - - - - - - - -

autocmd! FileWritePre   *
autocmd! FileAppendPre  *
autocmd! FilterWritePre *
autocmd! BufWritePre    *

" setlocal cmdheight=1