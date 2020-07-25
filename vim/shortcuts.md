Profiling

[From Stack Overflow](https://stackoverflow.com/a/12216578)

```vim
:profile start profile.log
:profile func *
:profile file *
" At this point do slow actions
:profile pause
:noautocmd qall!
```


Single number on a line:

increment <C-a> decrement <C-x>

Save and quit
:wq == ZZ

Toggle case
~

Ignore sudo protection while saving
!w !sudo tee %

Output external command's result in Vim
:.! date

Command history
q:

Open a URL (note the slash at the end)
vim https://stackoverflow.com/


