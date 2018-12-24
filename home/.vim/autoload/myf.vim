if exists('g:loaded_myf')
    finish
endif
let g:loaded_myf = 1

function! myf#JsonPrettyVisual()
    let json_xs_test = system('which json_pp')
    if empty(json_xs_test)
        echom "err: could not find json_xs utility"
        return 1
    endif
    silent! s/\v\\u(\x{4})/\=nr2char("0x".submatch(1), 1)/g
    let redir_buf = ''
    redir => redir_buf
    silent execute "'<,'>w ! json_pp"
    redir END
    if redir_buf =~ "shell returned"
        echom "could not parse json"
        return 1
    endif
    silent execute  "'<,'>! json_pp"
endfu

function! myf#JsonPretty()
    let json_xs_test = system('which json_pp')
    if empty(json_xs_test)
        echom "err: could not find json_xs utility"
        return 1
    endif
    silent! %s/\v\\u(\x{4})/\=nr2char("0x".submatch(1), 1)/g
    let redir_buf = ''
    redir => redir_buf
    silent execute "w ! json_pp"
    redir END
    if redir_buf =~ "shell returned"
        echom "could not parse json"
        return 1
    endif
    silent execute  "%! json_pp"
endfu

function! myf#SortPhpStaticAnalyseErrors(i1, i2)
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
            \ ' unusedcode'
        \ ), '\n')
    " filter empty strings
    let filtered_out = filter(pmd_out, '!empty(v:val)')
    if !len(filtered_out)
        cclose
        echo 'phpmd: no issues'
        return 0
    endif
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

    let sorted_list = sort(errors_list, "myf#SortPhpStaticAnalyseErrors")
    call setqflist(sorted_list)
    copen

    return 0
endfunction

function! myf#PhpStanCheck(...)
    let a:level = get(a:, 1, 0)

    let phpstan_config=$PHPSTAN_CONFIG
    if phpstan_config == ''
        echo 'env PHPSTAN_CONFIG is not defined. use "config.neon"'
        let phpstan_config='config.neon'
    endif

    let fname = expand("%:p")

    " check if current file is readable
    if !filereadable(fname)
        echo 'no file'
        return 1
    endif

    " clear the quickfixlist
    call setqflist([])

    " run phpstan with params
    let phpstan_out = split(system(
            \ '! phpstan analyse'.
            \ ' -c '.phpstan_config.
            \ ' -l '.a:level.
            \ ' --error-format=raw --no-progress'.
            \ ' -- '.fname
        \ ), '\n')
    " filter empty strings
    let filtered_out = filter(phpstan_out, '!empty(v:val)')
    if !len(filtered_out)
        cclose
        echo 'phpstan (level '.a:level.'): no issues'
        return 0
    endif
    let errors_list = []
    for line in filtered_out
        let mtch = matchlist(line, '^\([^:]\+\):\(\d\+\):\(.*\)$')
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

    let sorted_list = sort(errors_list, "myf#SortPhpStaticAnalyseErrors")
    call setqflist(sorted_list)
    copen

    return 0
endfunction
