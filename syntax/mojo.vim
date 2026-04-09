runtime! syntax/python.vim

" Imports
syn keyword mojoInclude from import
hi def link mojoInclude Include

" Function/method definition
syn keyword mojoStatement fn
hi def link mojoStatement pythonStatement

" Type definitions
syn keyword mojoStructure struct trait
hi def link mojoStructure Structure

" Variable/parameter modifiers
syn keyword mojoStorageClass var read out owned borrowed inout
hi def link mojoStorageClass StorageClass

" Type aliases
syn keyword mojoTypedef alias comptime
hi def link mojoTypedef Typedef

" Compile-time / constraints
syn keyword mojoPreProc where __extension
hi def link mojoPreProc PreProc

" Exception modifier
syn keyword mojoException raises
hi def link mojoException Exception

syn match mojoTypeAnnotation ":\s*\zs\w\+" containedin=ALL
syn match mojoReturnType "→\s*\zs\w\+" containedin=ALL
syn match mojoArrow "→" containedin=ALL
hi def link mojoTypeAnnotation Type
hi def link mojoReturnType     Type
hi def link mojoArrow          Operator

" Decorators
syn match mojoDecorator "@fieldwise_init\|@always_inline\|@parameter\|@register_passable\|@staticmethod"
hi def link mojoDecorator PreProc

" Type parameters: Type[...]
syn match mojoParamBracket "\[" contained
syn match mojoParamBracket "\]" contained
syn region mojoTypeParam matchgroup=mojoParamBracket
  \ start="\w\+\[" end="\]"
  \ contains=mojoTypeParam,mojoParamKey,pythonNumber,pythonString
syn match mojoParamKey "\w\+\ze\s*=" contained
hi def link mojoTypeParam    Type
hi def link mojoParamBracket Delimiter
hi def link mojoParamKey     Identifier

" Trait list in struct defs: struct Foo(Trait, Trait)
syn region mojoTraitList matchgroup=mojoTraitBracket
  \ start="\(struct\|trait\)\s\+\w\+\s*(" end=")"
  \ contains=mojoTrait,pythonComment
syn match mojoTrait "\w\+" contained
hi def link mojoTraitBracket Delimiter
hi def link mojoTrait        Type
