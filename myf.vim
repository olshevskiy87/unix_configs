if exists('g:loaded_myf')
    finish
endif
let g:loaded_myf = 1

function! myf#JsonPrettyVisual()
    let json_xs_test = system('which json_xs')
    if empty(json_xs_test)
        echom "err: could not find json_xs utility"
        return 1
    endif
    silent! s/\v\\u(\x{4})/\=nr2char("0x".submatch(1), 1)/g
    let redir_buf = ''
    redir => redir_buf
    silent execute "'<,'>w ! json_xs -t json-pretty"
    redir END
    if redir_buf =~ "shell returned"
        echom "could not parse json"
        return 1
    endif
    silent execute  "'<,'>! json_xs -t json-pretty"
endfu

function! myf#JsonPretty()
    let json_xs_test = system('which json_xs')
    if empty(json_xs_test)
        echom "err: could not find json_xs utility"
        return 1
    endif
    silent! %s/\v\\u(\x{4})/\=nr2char("0x".submatch(1), 1)/g
    let redir_buf = ''
    redir => redir_buf
    silent execute "w ! json_xs -t json-pretty"
    redir END
    if redir_buf =~ "shell returned"
        echom "could not parse json"
        return 1
    endif
    silent execute  "%! json_xs -t json-pretty"
endfu

function! myf#SortPhpMdErrors(i1, i2)
    if a:i1.text == a:i2.text
        return 0
    elseif a:i1.text > a:i2.text
        return 1
    else
        return -1
    endif
endfunction

function! myf#PhpMdCheck()
    let fname = expand("%:p")

    " check if current file is readable
    if !filereadable(fname)
        echo 'no file'
        return 1
    endif

    " clear the quickfixlist
    call setqflist([])

    " run phpmd with params
    let pmd_out = split(system(
            \ '! phpmd '.
            \ fname.
            \ ' text'.
            \ ' unusedcode,codesize,naming,design,cleancode,controversial'
        \ ), '\n')
    " filter empty strings
    let filtered_out = filter(pmd_out, '!empty(v:val)')
    let errors_list = []
    for line in filtered_out
        let mtch = matchlist(line, '^\([^:]\+\):\(\d\+\)\s\+\(.*\)$')
        if !len(mtch)
            continue
        endif
        call add(
            \ errors_list, {
                \ "filename": mtch[1],
                \ "lnum": mtch[2],
                \ "text": mtch[3],
                \ "type": "E"
            \ }
        \ )
    endfor

    let sorted_list = sort(errors_list, "myf#SortPhpMdErrors")
    call setqflist(sorted_list)
    copen

    return 0
endfunction
