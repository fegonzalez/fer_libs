{


if ($0~/<ID_Building>/) {
poslimitador1=index($0,">")
prenum=substr($0,1,poslimitador1)
resto=substr($0,poslimitador1+1,(length($0)-poslimitador1))
poslimitador2=index(resto,"<")
numero=substr(resto,1,poslimitador2-1)
printf ("%s ",numero)

getline 
poslimitador1=index($0,">")
prenum=substr($0,1,poslimitador1)
resto=substr($0,poslimitador1+1,(length($0)-poslimitador1))
poslimitador2=index(resto,"<")
numero=substr(resto,1,poslimitador2-1)
printf ("%s\n ",numero)
}
}
