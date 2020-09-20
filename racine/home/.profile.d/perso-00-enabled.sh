export PERSO_ENABLED=0
if [ "${SHELL}" = "/bin/bash" ] || [ "${SHELL}" = "bash" ] ; then
        if [ -t 1 ] ; then export PERSO_ENABLED=1 ; fi
fi

#if [ -z "$PS1" ]; then echo This shell is not interactive
#else export PERSO_ENABLED=1
#fi

