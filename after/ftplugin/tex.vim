" Since as of now, these are being overwritten in ~/.vim/vimfiles/ftplugin/tex/texrc, here they come again:

" make EFN add a footnote, make EFC add a footcite, ECT adds a cite {{{
call IMAP('EFN',"\\footnote{<++>}<++>",'tex')
call IMAP('EFC',"\\footcite[<++>][<++>]{<++>}<++>",'tex')
call IMAP('ECT',"\\cite[<++>][<++>]{<++>}<++>",'tex')
" }}}

" make `CC and `CT in insert mode insert frqq{} and flqq{} {{{
call IMAP('`CC',"\\enquote*{}",'tex')
call IMAP('`CT',"\\enquote{}",'tex')
" }}}

