# HiTags
> Hitags is a Vim plugin which harnesses the power of ctags
> to provide dynamic symbol (e.g. variable, function) name highlighting.

## Before/After
![before\_after](before_after.jpg)

## Runtime dependencies
 + [mimetype](https://packages.gentoo.org/packages/dev-perl/File-MimeInfo) (sadly, `file -i` does not suffice)
 + python3 (system installation, not Vim compile flag)
 + ctags (tested with Universal ctags)
 + **_(Optional)_** gcc/clang/fcpp (to preprocess C/C++ files)

## Installation
1. Pack this repository.

> [!NOTE]
> "Pack" as in the Vim 8 feature.

2. Configure Vim to actually invoke the plugin.
    Achieve this by appending / overriding the following definition in your .vimrc.
```VimScript
let g:hitags_events = ["BufWrite"]  " trigger a symbol update on writes
```

3. **_(Optional)_** Further configure HiTags by editing `plugin/hitags.vim`.
All required details are commented right there in the script.

4. Enjoy

## How it works
```pseudo
when do-update()
    if is-c-source-file()
        preprocess()

    run-ctags()
    generate-vim-syntax-file-with-python()
    source-vim-syntax-file()
```

## Project structure

| File | Description |
| :--- | :---------- |
| hitags.vim | Plugin invoking hitags.py and sourcing the generated syntax file |
| hitags.py  | Vim syntax file generator |
| debug/     | Developer relevant resources |
| builder/   | Optional pregenerated tags files for standard libraries |

## Rationale
Working without symbol highlighting is really annoying.

## Notes
* Now, comes with experimental tool tips in insert mode.
* The signatures are terribly buggy, but somewhat helpful
* C++ is fucked
* im glad that frexx exists, but its source quality is concerning and it crashes from `__VA_ARGS__`
