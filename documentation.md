# Rationale
Working without symbol highlighting is really annoying.

# How it works

    when do-update()
        if is-c-source-file()
            preprocess()

        run-ctags()
        generate-vim-syntax-file-with-python()
        source-vim-syntax-file()

# Project structure

| File | Description |
| hitags.vim | plugin invoking hitags.py and sourcing the generated syntax file |
| hitags.py | vim syntax file generator |
| debug/ | developer relevant resources |
| builder/ | initially i planned to pre-generate tags for standard and common C/C++ symbols; it may or may not go somewhere |

# Notes
* the signatures are terribly buggy, but somewhat helpful
* C++ is fucked
* pre-generation is still not a bad idea
