if [ ${PERSO_ENABLED} = 1 ] ; then
 catbashrc () { if [ ! -z $1 ]; then /bin/cat ~/.bashrc ~/.profile ~/.bash_logout | grep -i $1; else /bin/cat ~/.bashrc ~/.profile ~/.bash_logout; fi }

 catcommande () { if [ ! -z $1 ]; then /bin/cat ~/Documents/geek/commandes.txt | grep -i $1; else /bin/cat ~/Documents/geek/commandes.txt; fi }

 catgmrun () { if [ ! -z $1 ]; then /bin/cat ~/.gmrun_history | grep -i $1; else /bin/cat ~/.gmrun_history; fi }

 cathistory () { if [ ! -z $1 ]; then /bin/cat ~/.bash_history | grep -i $1; else /bin/cat ~/.bash_history; fi }

 cati3 () { if [ ! -z $1 ]; then /bin/cat ~/.config/i3/config ~/.config/i3blocks/config | grep -i $1; else /bin/cat ~/.config/i3/config ~/.config/i3blocks/config; fi }

 cattmux () { if [ ! -z $1 ]; then /bin/cat ~/.byobu/.tmux.conf ~/.byobu/windows.tmux | grep -i $1; else /bin/cat ~/.byobu/.tmux.conf ~/.byobu/windows.tmux; fi }
fi
