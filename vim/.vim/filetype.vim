autocmd BufNewFile,BufRead Jenkinsfile* setfiletype groovy
autocmd BufNewFile,BufRead values.tpl setfiletype yaml
autocmd BufNewFile,BufRead *.hcl setfiletype tf
autocmd BufNewFile,BufRead *.hbs setfiletype html
autocmd BufNewFile,BufRead *.j2 setfiletype yaml
autocmd BufNewFile,BufRead *.conf setfiletype cfg
autocmd BufNewFile,BufRead .workrc setfiletype sh
autocmd BufRead,BufNewFile *.proto setfiletype proto

