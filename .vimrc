highlight ColorColumn ctermbg=red ctermfg=white guibg=#592929
highlight Search ctermbg=red ctermfg=white

let s:match_highlights = {}

function! ToggleHighlight(hl_group, pattern)
    if has_key(s:match_highlights, a:pattern)
        " Remove existing highlight pattern.
        call matchdelete(s:match_highlights[a:pattern])
        call remove(s:match_highlights, a:pattern)
        " Check if variable exists for older versions of ViM and if this
        " function was called from a map.
        if exists('v:false') && v:false
            echom 'The highlight pattern ' . a:pattern . ' has been disabled.'
        endif
    else
        " Add new highlight pattern. 
        let s:match_highlights[a:pattern] = matchadd(a:hl_group, a:pattern)
        if exists('v:false') && v:false
            echom 'The highlight pattern ' . a:pattern . ' has been enabled.'
        endif
    endif
endfunction

"command! -nargs=+ ToggleHighlight call s:ToggleHighlight(<f-args>)

" Blink search highlights.
function! HLNext (blinktime)
    let target_pat = '\c\%#'.@/
    let blinks = 2
    for n in range(1,blinks)
        let ring = matchadd('ErrorMsg', target_pat, 101)
        redraw
        exec 'sleep ' . float2nr(a:blinktime / (2 * blinks) * 800) . 'm'
        call matchdelete(ring)
        redraw
        exec 'sleep ' . float2nr(a:blinktime / (2 * blinks) * 1400) . 'm'
    endfor
endfunction

" Toggle line relative number
function! RNToggle()
    if (&rnu)
        set nornu
    else
        set rnu
    endif
endfunction

" Toggle complete kspell
let s:spell = 0
function! CKToggle()
    if s:spell
        setlocal nospell
        setlocal complete-=kspell
        let s:spell = 0
    else
        setlocal spell
        setlocal complete+=kspell
        " Disable highlighting correct words.
        highlight clear SpellCap
        let s:spell = 1
    endif
endfunction

" Highlight the 81st column in lines that exceed the 80 character limit.
call ToggleHighlight('ColorColumn', '\%81v[^\n]')
" Highlight from the 81st column onwards in lines that exceed the 80 character
" limit.
"call ToggleHighlight('ColorColumn', '\%81v.\+')


nmap <silent> <leader>s :call CKToggle()<cr>


nnoremap <silent> n  n:call HLNext(0.4)<cr>
nnoremap <silent> N  N:call HLNext(0.4)<cr>

nnoremap <silent> <C-h> :call ToggleHighlight('ColorColumn', '\%81v')<cr>
nnoremap <silent> <C-n> :call RNToggle()<cr>

" Map Ctrl+l to redraw the screen and remove any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Map Ctrl+a or +x to open Netrw in the current buffer or on a new vertical
" splitted window respectively.
nnoremap <silent> <C-a> :Explore<cr>
nnoremap <silent> <C-x> :Lexplore<cr>



" Keep 200 lines of command line history.
set history=200
" Display incomplete commands.
set showcmd
" Display completion matches in a status line.
set wildmenu
" Show absolute and relative line numbers. 
set number relativenumber
" Do incremental searching.
set incsearch

set directory=$HOME/.tmp/vim/swap//
if !isdirectory(&directory)
    call mkdir(&directory, "p")
endif

" Keep a backup file (restore to previous version)
set backup
set backupdir=$HOME/.tmp/vim/backup//
if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
endif

" Keep an undo file (undo changes after closing)
set undofile
set undodir=$HOME/.tmp/vim/undo//
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif

augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 80 characters.
    autocmd FileType text setlocal textwidth=80
    autocmd FileType vhdl setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd FileType verilog setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd FileType systemverilog setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd FileType c,cpp setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
augroup END

au BufWritePre * let &bex = substitute(expand("%:p:h"), $HOME, '~', '') . strftime("%y-%m-%d_%H-%M-%S")

" Specify the initial size of the new netrw window 
let g:netrw_winsize=-30
" Split right
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_list_hide='.git'


call plug#begin()

" List your plugins here
Plug 'nordtheme/vim'

call plug#end()
