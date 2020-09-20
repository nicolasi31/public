**Tmux**

[[_TOC_]]

# Usefull Links
[https://gist.github.com/MohamedAlaa/2961058](https://gist.github.com/MohamedAlaa/2961058)

----

# Config File
## ${HOME}/.tmux.conf
```
# Replace C-b by C-a, like screen
set-option -g prefix C-a
unbind-key C-b
bind-key C-a send-prefix
#
# set default TERM
set -g default-terminal "screen-256color"
```

----

# Cheatsheet
## start new:
```shell
tmux
```
## start new with session name:
```shell
tmux new -s mysession
```
## attach:
```shell
tmux a
```
> or at, or attach
## attach to named:
```shell
tmux a -t mysession
```
## list sessions:
```shell
tmux ls
```
## kill session:
```shell
tmux kill-session -t mysession
```
## Kill all the tmux sessions:
```shell
tmux ls | grep : | cut -d. -f1 | awk '{print substr($1, 0, length($1)-1)}' | xargs kill
```

----

# Sessions
## new session
```
:new<CR>
```
##  list sessions
```
s
```
## name session
```
$
```

----

# Windows (tabs)
## create window
```
c
```
## list windows
```
w
```
## next window
```
n
```
## previous window
```
p
```
## find window
```
f
```
## name window
```
,
```
## kill window
```
&
```

