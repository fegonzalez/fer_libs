# fer .bashrc par ael proyecto 225 en la maquina local (no exportar a la maquina 225)
#
# Version: 20-10-2009 15:1
# Compila OK en $WORKDIR: local & Gris
#
###################   $WORKDIR    #############

export HOSTNAME
export WORKDIR=$HOME/job/workspace
export WORKDIR_TIGRE=$WORKDIR/tigre
export WORKDIR_225=$WORKDIR/225
export WORKDIR_350=$WORKDIR/as350
##############################################



#----------------------------------------------------------------------------------------------
#-------------------------------------  gris & integracion   ------------------------------
#----------------------------------------------------------------------------------------------



#########   LIBRERIAS empleadas en HxuSTART.j   ###########
#
# .bashrc de usuario

###########################################

#  No cambiar esta parte
#
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
# 

# warning: /usr/openwin no existe
export OPENWINHOME=/usr/openwin
# warnuing: /usr/dt no existe
export MOTIFHOME=/usr/dt

#LD_LIBRARY_PATH  se usa desde fuera
#export LD_LIBRARY_PATH=/usr/local/lib:$OPENWINHOME/lib:$MOTIFHOME/lib:$HOME/library/sistemas


###################   REMOTE HOSTS   #############


#echo "REMOTEHOST=$REMOTEHOST"
export CVSROOT=:ext:$USER@172.22.241.29:/home/cvs


export OSTYPE=linux-gnu
export MANPATH=/usr/share/man
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

export BOUML_ID=101
export CPPUNITLIB=/usr/lib
export ECLIPSE_PATH=/home/fer/eclipse/eclipse_3.2.2_CDT_3.1.2
export PLUGINS_PATH=/home/fer/links_to_path
export DIR_INSTALACION_ACROBAT_READER=/home/apps/acrobat_reader
export ACROBAT_READER_PATH=$DIR_INSTALACION_ACROBAT_READER/bin
export LIBXML2_INCLUDE_PATH=/usr/include:/usr/include/libxml2:/usr/include/libxml2/libxml
export LIBXML2_LIB_PATH=/usr/lib
export LIBXML2_BIN_PATH=/usr/bin
export LIBXML2_TOTAL_PATH=$LIBXML2_BIN_PATH:$LIBXML2_LIB_PATH:$LIBXML2_INCLUDE_PATH
export PATH=$WORKDIR_TIGRE/local/bin:/usr/local/teTeX/bin/i686-pc-linux-gnu:/bin:/usr/X11R6/bin:$MOTIFHOME/bin:$OPENWINHOME/bin:/usr/totalview/bin:$CPPUNITLIB:$ECLIPSE_PATH:$PLUGINS_PATH:$ACROBAT_READER_PATH:$PATH


##############################################################################
############################### ALIAS ########################################
##############################################################################
export WORKDIR_ENU=$WORKDIR/famet_enu
#WORK 225
alias ww225='cd $WORKDIR_225;clear;pwd'
export DIR_XEX=$WORKDIR_225/executive/exec/bin
alias ww_xex='cd $DIR_XEX;clear;pwd'
export DIR_SAR=$WORKDIR_225/ec225/simulador/sistemas/smis/sar
alias ww_sar='cd $DIR_SAR;clear;pwd'
export DIR_DATOS=$WORKDIR_225/ec225/simulador/datos/ejecutivo
alias ww_datos='cd $DIR_DATOS; clear; pwd'
export DIR_SAR_DATOS=$WORKDIR_225/ec225/simulador/datos/sistemas/smis/sar
export DIR_TCAS=$WORKDIR_225/ec225/simulador/sistemas/smis/tcas
alias ww_tcas='cd $DIR_TCAS;clear;pwd'
export DIR_MFD=$WORKDIR_225/ec225/simulador/interfaces/ifc_ec_mfd
alias ww_mfd='cd $DIR_MFD;clear;pwd'
alias ulu='ps -efc|grep xexec' #finding executions in progress
export DIR_SAR_VEH=$DIR_SAR/eTactico/sistemas/vehiculo
alias ww_veh='cd $DIR_SAR_VEH; clear; pwd'
alias wwenu='cd $WORKDIR_ENU;pwd'
#WORK as350
alias ww3='cd $WORKDIR_350;clear;pwd'
alias wwq='cd $WORKDIR_350/fdAS350/qtg;clear;pwd'
#local
export WORKDIR_SOFT=/home/fer/job/workspace/pruebasC++/ag_master_1
alias ww_soft='cd $WORKDIR_SOFT'
#wildcat
export WORKDIR_WILDCAT=/home/fer/job/workspace/wildcat
alias ww_wildcat='cd $WORKDIR_WILDCAT;pwd'
alias gatu=ww_wildcat

export DIR_WILDCAT_TP=$WORKDIR_WILDCAT/tp
alias ww_tp='cd $DIR_WILDCAT_TP;pwd'

export DIR_WILDCAT_WEAPONS=$WORKDIR_WILDCAT/weapons
alias ww_weapons='cd $DIR_WILDCAT_WEAPONS;pwd'

export DIR_WILDCAT_SOC_SMS=$DIR_WILDCAT_WEAPONS/doc/SMS
alias ww_sms='cd $DIR_WILDCAT_SOC_SMS'

export DIR_WILDCAT_MR=$DIR_WILDCAT_TP/doc/mission_recorder
alias ww_mr='cd $DIR_WILDCAT_MR'

export DIR_WILDCAT_EODS=$DIR_WILDCAT_TP/doc/EODS
alias ww_eods='cd $DIR_WILDCAT_EODS'
alias ww='ww_eods'

export DIR_WILDCAT_CMDS=$DIR_WILDCAT_TP/doc/CMDS
alias ww_cmds='cd $DIR_WILDCAT_CMDS'
alias ww='ww_cmds'

export DIR_WILDCAT_HUMS=$WORKDIR_WILDCAT/HUMS
alias ww_hums='cd $DIR_WILDCAT_HUMS'
alias ww='ww_hums'




export DIR_UML_WILDCAT=/home/fer/job/workspace/wildcat/general_doc/uml/rational_rose/wildcat-program_2_rational_rose
alias ww_uml='cd $DIR_UML_WILDCAT'


export VIAJE='/home/fer/Desktop/docs/viaje'
alias toviaje='cd $VIAJE'


###########################################

# Pongamos un poco de color en el prompt
USUARIO="\u"
HOST="\h"
DIR="\W"
negro="\[\033[1;30m\]"
rojo="\[\033[1;31m\]"
verde="\[\033[1;32m\]"
amarillo="\[\033[1;33m\]"
azul="\[\033[1;34m\]"
rosa="\[\033[1;35m\]"
cyan="\[\033[1;36m\]"
incoloro="\[\033[0m\]"
#
PS1="$azul$USUARIO@$azul$HOST/$DIR$azul$ $incoloro"


###### Personal Alias #####

#para que emacs reconozca caracteres españoles (Ñ,...)
export LANG=
#export LANG="es_ES.iso8859"
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias dir='ls $LS_OPTIONS'
alias z='ls $LS_OPTIONS -ltrh'
alias zz='clear;ls $LS_OPTIONS -ltragh'
alias cd..='cd ..'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
#alias ee='emacs -font fixed'
alias ee='emacs'
alias e='gedit'
#alias limpia='rm -rf *~;rm -rf *.*~'
alias limpia='for file in $(find -name "*~" -type f); do rm -f $file;done'
alias whereami='echo $HOSTNAME'
alias wer='whereami'
alias wai='whoami'
#alias para erroress tipograficos frecuentes
alias grep='grep --color'

alias 2famet='ssh -X fegonzalez@famet'
alias 2gatu='ssh -X fer@wildcat'

stty erase  ^H
