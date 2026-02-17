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
| :--- | :---------- |
| hitags.vim | Plugin invoking hitags.py and sourcing the generated syntax file |
| hitags.py  | Vim syntax file generator |
| debug/     | Developer relevant resources |
| builder/   | Initially I planned to pre-generate tags for standard and common C/C++ symbols; it may or may not go somewhere |

# Notes
* the signatures are terribly buggy, but somewhat helpful
* C++ is fucked
* pre-generation is still not a bad idea
* im glad that frexx exists, but its source quality is concerning and it crashes from `__VA_ARGS__`

# Todo
* I should be preprocessing different types of files too, e.g. python;
just include the modules ctags will figure it out
