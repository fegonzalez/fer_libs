{
if ($0~/Altitud/) {
poslimitador1=index($0,">")
prenum=substr($0,1,poslimitador1)
resto=substr($0,poslimitador1+1,(length($0)-poslimitador1))
poslimitador2=index(resto,"<")
numero=substr(resto,1,poslimitador2)
resto2=substr(resto,poslimitador2,(length(resto)-poslimitador2))
printf ("%s%f%s\n",prenum,numero+2,resto2)
}else{
print $0
}
}

