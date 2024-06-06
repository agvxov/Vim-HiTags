syn region HelloWorldRegion start=/^class HelloWorld\n\s*{$/ end=/}/ transparent
syn keyword Greeting greeting contained containedin=HelloWorldRegion
hi link Greeting Statement

syn region MainRegion start=/^    static void Main()\n\s*{$/ end=/}/ contains=ALL transparent
syn keyword HelloWorldInstance helloWorldInstance contained containedin=MainRegion
hi link HelloWorldInstance Statement

"syn region BraceBlock start=/{/ end=/}/ transparent
