" --- Config options ---
let s:tags_folder = expand("~") . "/.local/share/ctags"
let s:std_tags_folder = expand('<sfile>:p:h') . "/cpp_src"
let s:std_tags_file = "std.ctags"
map <f6>	:call Cpp_tags_run()<CR>
" --- ---

function s:init()
	if !isdirectory(s:tags_folder)
		call mkdir(s:tags_folder, 'p')
	endif
	if !filereadable(s:tags_folder . '/' . s:std_tags_file)
		call system('ctags --tag-relative=always -R -o'
			\ . ' "' . s:tags_folder . '/' . s:std_tags_file . '"'
			\ . ' "' . s:std_tags_folder . '"'
		\)
	endif
	highlight link class_mg Class
endfunction

function! Cpp_tags_generate()
	call system('ctags --tag-relative=always -R -o'
		\ . ' "'  . s:tags_folder . "/$(echo $PWD | md5sum | cut -d ' ' -f 1).ctags" . '"'
		\ . ' *'
	\)
endfunction

function! Cpp_tags_load()
	exe "set tags=" . system("echo /home/anon/Desktop/ctags/$(echo $PWD | md5sum | cut -d ' ' -f 1).ctags")
	exe "set tags+=" . s:tags_folder . '/' . s:std_tags_file
endfunction

let s:matches = []
function! Cpp_tags_hi()
	" make sure no removed symbols stay highlighted
	for i in s:matches
		highlight clear i
	endfor
	let s:matches = []
	" add tags to a highlighting groups
	for t in taglist('.')
		let group = ''
		"
		if t.kind == 'v'
			let group = 'Variable'
		elseif t.kind == 'f'
			let group = 'Function'
		elseif t.kind == 'd' || t.kind == 'e'
			let group = 'Constant'
		elseif t.kind == 't'
			let group = 'Type'
		elseif t.kind == 'c'
			let group = 'Class'
		elseif t.kind == 'n'
			let group = 'Namespace'
		endif
		"
		if group != ''
			call add(s:matches, t.name)
			let prefix = ''
			let postfix = ''
			if has_key(t, 'class')
				let postfix = split(t.class, '::')
				let postfix = postfix[len(postfix)-1]
				let postfix = ' contained containedin=' . postfix . '_region'
			endif
			try
				exe 'syntax match ' group . "\t". '"\<' . t.name . '\>"' . postfix
			catch
			endtry
		endif
		"
		if t.kind == 'c'
			try
				"exe "syn region " . t.name . '_region'
				"	\. ' matchgroup=class_mg'
				"	\. ' start=' . '"' . '\<' . t.name . '\ze\.' . '"'
				"	\. ' end="\.\w*\W"\=@'
				exe "syn region " . t.name . '_region'
					\. ' matchgroup=class_mg'
					\. ' start=' . '"' . '\<' . t.name . '\.' . '"'
					\. ' end="\>"'
			catch
			endtry
		endif
	endfor
endfunction

function! Cpp_tags_run()
	"silent call Cpp_tags_generate()
	"silent call Cpp_tags_load()
	"silent call Cpp_tags_hi()
	call Cpp_tags_generate()
	call Cpp_tags_load()
	call Cpp_tags_hi()
endfunction

" ---
silent call s:init()
