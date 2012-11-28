" bib.vim
" bibtex-specific adjustments for latex-suite.
" To reside in $HOME/.vim/ftplugin
" Andreas Wagner

" Character	Field Type	
" w	address	
" a	author	
" b	booktitle	
" c	chapter
" x	crossref
" d	edition	
" e	editor	
" g	gender
" h	howpublished	
" i	institution	
" k	isbn	
" j	journal	
" m	month	
" z	note	
" n	number	
" o	organization	
" p	pages	
" q	publisher	
" r	school	
" s	series
" l	shorttitle	
" t	title	
" u	type	
" v	volume	
" y	year

set nowrap
set textwidth=0
set wrapmargin=0

" let g:Bib_article_options="glvnp"
" let g:Bib_incollection_options="x"
" let g:Bib_inbook_options="x"
" let g:Bib__options=""

call IMAP ('BBb', "\<C-r>=BibT('book', '', 0)\<CR>", 'bib')
call IMAP ('BBa', "\<C-r>=BibT('article', '', 0)\<CR>", 'bib')
call IMAP ('BBic', "\<C-r>=BibT('incollection', '', 0)\<CR>", 'bib')
call IMAP ('BBib', "\<C-r>=BibT('inbook', '', 0)\<CR>", 'bib')
" call IMAP ('BBxc', "\<C-r>=BibT('incollection', 'o', 0)\<CR>", 'bib')
" call IMAP ('BBxb', "\<C-r>=BibT('inbook', 'o', 0)\<CR>", 'bib')

" BibT: function to generate a formatted bibtex entry {{{
" three sample usages:
"   :call BibT()                    will request type choice
"   :call BibT("article")           preferred, provides most common fields
"   :call BibT("article","ox")      more optional fields (o) and extras (x)
"
" Input Arguments:
" type: is one of the types listed above. (this should be a complete name, not
"       the acronym).
" options: a string containing 0 or more of the letters 'oOx'
"          where
"          o: include a bib entry with first set of options
"          O: include a bib entry with extended options
"          x: incude bib entry with extra options
" prompt: whether the fields are asked to be filled on the command prompt or
"         whether place-holders are used. when prompt == 1, then comman line
"         questions are used.
"
" Returns:
" a string containing a formatted bib entry

" re-enable e-acute key as per FAQ. and this work with Alt-i...
imap <buffer> <leader>item <Plug>Tex_InsertItemOnThisLine

" make F8 call aspell
" map <F8> :w!<CR>:!aspell --lang=de --mode=tex check "%"<CR>:e! "%"<CR><CR>

" make `CC and `CT in insert mode insert frqq{} and flqq{}
call IMAP('`CC',"\\frqq{}",'bib')
call IMAP('`CT',"\\flqq{}",'bib')

" make ,ct enclose visually selected text in citation marks, ,fn in a footnote
" vmap <silent> ,ct 	<C-\><C-N>:call VEnclose('\frqq{}', '\flqq{}', '\frqq{}', '\flqq{}')<CR>
" vmap <silent> ,fn 	<C-\><C-N>:call VEnclose('\footnote{', '}', '\footnote{', '}')<CR>

" make a shortcut for rmligs
" map <Leader>rml		:%!rmligs -q -f<CR>

syn keyword bEntryType  article book inbook booklet conference incollection manual masterthesis phdthesis techreport unpublished misc

syn keyword bOpt optional
syn keyword bReq required

syn keyword bType Bibtype CiteID Author Title Journal Volume Number Pages Month Year Key Abstract Note Editor Publisher Series Address Chapter How published Book title Organisation School Institution Type Miscellanious

highlight bEntryType    term=underline ctermfg=6 guifg=brown gui=bold
highlight bType         term=underline ctermfg=6 guifg=blue gui=bold
highlight bOpt          term=underline ctermfg=6 guifg=green4   gui=bold
highlight bReq          term=underline ctermfg=6 guifg=red   gui=bold

