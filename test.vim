syntax region MyLineRange
      \ start=/\%1l/
      \ end=/\%4l/
      \ contains=MyKeyword

syntax keyword MyKeyword foo bar baz contained
hi link MyKeyword Special
