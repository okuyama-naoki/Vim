" view
set number
set laststatus=2
set list
set listchars=tab:‣\ ,eol:↲,trail:-
" set statusline=%(%q%m%r%f%)%=%(%c,%l/%L%Y,%{&fileformat},%{&fileencoding}%#Keyword#%{fugitive#statusline()}%)
set statusline=%(%q%m%r%f%)%=%(%c,%{&fileformat},%{&fileencoding}%#Keyword#%{fugitive#statusline()}%)
colorscheme koehler
set title

"find
set smartcase
set incsearch
set hlsearch
set ignorecase
set nowrapscan

" code reading
set tags=./tags,~/tags
nnoremap <C-]> g<C-]>
nnoremap <Space>gl :vim /\C<C-r><C-w>/ **/*.%:e \| copen<CR>
nnoremap <Space>ga :vim /\C<C-r><C-w>/ **/* \| copen<CR>

" indent
set autoindent
set smartindent

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.lua setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.coffee setlocal noexpandtab list
augroup END

" file
set nobackup
set noswapfile

" diff
set diffopt=filler,vertical
highlight DiffAdd term=NONE cterm=NONE ctermfg=NONE ctermbg=darkgray gui=NONE guifg=NONE guibg=NONE
highlight DiffText term=NONE cterm=NONE ctermfg=NONE ctermbg=darkgray gui=NONE guifg=NONE guibg=NONE
highlight DiffDelete term=NONE cterm=NONE ctermfg=black ctermbg=NONE gui=NONE guifg=NONE guibg=NONE
highlight DiffChange term=NONE cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE

"NeoBundle Scripts-----------------------------
if &compatible
      set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/dev/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('/home/dev/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
"NeoBundle 'Shougo/neosnippet.vim'
"NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'kmnk/vim-unite-giti'
"NeoBundle 'ctrlpvim/ctrlp.vim'
"NeoBundle 'flazz/vim-colorschemes'

" You can specify revision/branch/tag.
"NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

NeoBundle 'kchmck/vim-coffee-script' "this should come between filetype off-on

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

"Tlist configuration
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Close_On_Select = 1
let Tlist_GainFocus_On_ToggleOpen = 1

" Unite configuration
let g:unite_enable_start_insert = 1

" Function Key ShortCuts
nnoremap <silent> <F4> :Tlist<CR>
nnoremap <silent> <F5> :Gstatus<CR>
nnoremap <silent> <F8> :Unite buffer file<CR>

nnoremap [c [czz
nnoremap ]c ]czz

" Source Code Formatter
function! NumMax(lhs, rhs)
    if a:lhs < a:rhs
        return a:rhs
    endif
    return a:lhs
endfunction

function! Myformatter(preinsertchar, sepalator, postinsertchar) range
    let SEPARATOR = a:sepalator
    " a   , b
    " aaaa, bbb, c
    "
    " lines = [
    "   ['a', 'b'],
    "   ['aaaa', 'bbb', 'c']
    " ]
    " 
    " a   , b
    " aaaa, bbb, c
    let lines = []
    
    " get max column
    let maxcolumn = 0
    for i in range(a:firstline, a:lastline)
        let line = getline(i)
        let columns = split(line, '\s*' . SEPARATOR . '\s*')
        call add(lines, columns)
        let maxcolumn = NumMax(maxcolumn, len(columns))
    endfor
   
    let i = 0
    while i < maxcolumn     " for each column
        " get max column length of all lines
        let maxitemlen = 0
        for column in lines
            if i < len(column)
                let maxitemlen = NumMax(maxitemlen, strdisplaywidth(column[i]))
            endif
        endfor
        " format
        for column in lines
            if i < len(column)
                let column[i] = column[i] . repeat(' ', maxitemlen - strdisplaywidth(column[i]))
            endif
        endfor
        let i += 1
    endwhile

    " replace original lines
    for lineNo in range(a:firstline, a:lastline)
        let listIndex = lineNo - a:firstline
        let text = join(lines[listIndex], a:preinsertchar . SEPARATOR . a:postinsertchar)
        let text = substitute(text, '\s\s*$', '', '') " trim last space
        call setline(lineNo, text)
    endfor
endfunction

vnoremap g, :<C-U>'<,'>call Myformatter('', ',', ' ')<CR>
vnoremap g= :<C-U>'<,'>call Myformatter(' ', '=', ' ')<CR>

