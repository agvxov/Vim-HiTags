" --- ------ ----
" --- Config ----
" --- ------ ----

" Folder to store all dynamically generated files in
"   + tags files
"   + highlighting scripts
"  I do not recommend using '.' especially if you don't auto cd with vim
let s:polution_directory = expand('<sfile>:p:h:h') . '/cache/'

" C_preprocessor:
"  The main purpose of our usage of a preprocessor is
"   to get #include statements expanded.
"
"  Real compilers tend to be problematic.
"  Namely, they error out if a header is not found.
"
"  The only stand-alone preprocessor implementation i know
"   is fcpp (https://github.com/bagder/fcpp.git)
"  It has the major advantage of only warning on missing
"   headers and not terminating with an error.
"  Meaning a tool chain using '-I' doesn't break everything.
"  The problem is, that many things, such as __VA_ARGS__ crashes it.
"  The following does crash:
"      \ 'fcpp':  'fcpp -I/usr/local/include $(git-compiler-include-path.pl) -LL {input_} {output}',
let g:hitags_cpreprocessor = get(g:, 'hitags_cpreprocessor', 'gcc')

let s:preprocessor_commands = {
      \ 'clang': 'clang -fdirectives-only -E {input_} -o {output}',
      \ 'gcc':   'gcc   -fdirectives-only -E {input_} -o {output}',
      \ 'fcpp':  'fcpp -I/usr/local/include -LL {input_} {output}',
      \ }

if !has_key(s:preprocessor_commands, g:hitags_cpreprocessor)
  echoerr 'hitags: invalid g:hitags_cpreprocessor value "' . g:hitags_cpreprocessor .
        \ '" - expected one of: ' . join(keys(s:preprocessor_commands), ', ')
endif

let s:preprocessor = get(s:preprocessor_commands, g:hitags_cpreprocessor,
      \ s:preprocessor_commands['gcc'])

if exists('g:hitags_cpreprocessor_cmd')
  let s:preprocessor = g:hitags_cpreprocessor_cmd
endif

" --- --------------------------- ---
" ---          Don't Touch        ---
" ---             Unless          ---
" --- You know What You Are Doing ---
" --- --------------------------- ---
let s:tags_filename      = 'tags'
let s:tags_file          = expand(s:polution_directory) . s:tags_filename
let s:tags_scriptname    = 'tags.vim'
let s:tags_script        = expand(s:polution_directory) . 'tags.vim'
let s:sigs_script        = expand(s:polution_directory) . 'sigs.vim'
"
let s:generator_script   = expand('<sfile>:p:h:h') . '/bin/hitags.py'
let s:generation_command =
                         \ 'python ' . s:generator_script .
                         \ ' -i ' . '"' . expand('%:p')        . '"' .
                         \ ' -p ' . "'" . s:preprocessor       . "'" .
                         \ ' -t ' . '"' . s:polution_directory . '"' .
                         \ ' hi ' .
                         \ '  > ' . '"' . s:tags_script        . '"' .
                         \ ';' .
                         \ 'python ' . s:generator_script .
                         \ ' -i ' . '"' . expand('%:p')        . '"' .
                         \ ' -p ' . "'" . s:preprocessor       . "'" .
                         \ ' -t ' . '"' . s:polution_directory . '"' .
                         \ ' sig ' .
                         \ '  > ' . '"' . s:sigs_script        . '"'

" --- Signature stuff ---
function! SigDebug()
   echo s:generation_command
endfunction


function! SigInit()
   let g:signatures = {}

   autocmd TextChangedI * call SigPopup()
endfunction

call SigInit()

function! SigPopup()
   let key = matchstr(getline('.')[:col('.')-2], '\k\+$')
   if has_key(g:signatures, key)
      call popup_atcursor(g:signatures[key], #{} )
   endif
endfunction

function! Sig()
   execute 'source ' . s:sigs_script
endfunction

if exists('g:sigs_events')
   for e in g:sigs_events
      execute "autocmd " . e . " * Sig"
   endfor
endif

command! Sig    :call Sig()
" --- --- ---

function! HiTagsUpdate()
   let pid = system(s:generation_command)

   if v:shell_error != 0
      echohl ErrorMsg
      echomsg "error: " . s:generator_script . " failed."
      echohl NONE
      return 1
   endif
endfunction

function! HiTagsClean()
   syn clear HiTagSpecial
   syn clear HiTagFunction
   syn clear HiTagType
   syn clear HiTagConstant
   syn clear HiTagIdentifier
endfunction

function! HiTagsHighlight()
   execute 'source ' . s:tags_script
endfunction

function! HiTagsDo()
   call HiTagsUpdate()
   call HiTagsClean()
   call HiTagsHighlight()
endfunction

" --- Hook up everything ---
if exists('g:hitags_events')
   for e in g:hitags_events
      execute "autocmd " . e . " * HiTagsDo"
   endfor
endif

hi link HiTagSpecial    Special
hi link HiTagFunction   Function
hi link HiTagType       Type
hi link HiTagConstant   Constant
hi link HiTagIdentifier Identifier

command! HiTagsUpdate    :call HiTagsUpdate()
command! HiTagsClean     :call HiTagsClean()
command! HiTagsHighlight :call HiTagsHighlight()
command! HiTagsDo        :call HiTagsDo()
