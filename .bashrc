# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022
export PS1="\t \[\e[01;32m\]\h\[\e[01;34m\] \W \[\e[00m\]# "
# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -laF'
alias grep='grep -i --color'

alias pg='ps aux | grep'
alias pl='ps faux | less'

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias ts='tail /var/log/syslog'

# Gestion des paquets
alias upgrade='apt-get update && apt-get upgrade && apt-get clean'
alias install='apt-get install'
alias remove='apt-get remove'

# Renvoi le chemin absolu d'un fichier
alias abso='readlink -f $1'

# Reviens à faire  cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak 
function cpb() { cp $@{,.bak} ;}

# Crée une sauvegarde du fichier passé en paramètre, en rajoutant l'heure et la date
function bak() { cp "$1" "$1_`date +%Y-%m-%d_%H-%M-%S`" ; }

# Bannir une IP
function ban() {
	if [ "`id -u`" == "0" ] ; then
		iptables -A INPUT -s $1 -j DROP
	else
		sudo iptables -A INPUT -s $1 -j DROP
	fi
}

# permettre une complétion plus "intelligente" des commandes
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi
