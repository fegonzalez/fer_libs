cd $RPATH

#Hxifcs.cfg: using all the interfaces

cd ./simulador/datos/ejecutivo/
rm -f Hxifcs.cfg
rm -f Hxifcs_cabina.cfg
cp Hxifcs_Testbed.cfg Hxifcs_cabina.cfg
sed -i 's/#@//g' Hxifcs_cabina.cfg
sed -i 's/cabvirtual.*udp.*big_endian.*localhost.*3033/cabvirtual  udp  big_endian  192.168.4.204  3033/g' Hxifcs_cabina.cfg
grep "192.168.4.204" Hxifcs_cabina.cfg
ln -s Hxifcs_cabina.cfg  Hxifcs.cfg

#VC disabled
sed -i 's/SET ALL.virtualCockpit 1/SET ALL.virtualCockpit 0/g' Hxtest.cfg
grep "SET ALL.virtualCockpit" Hxtest.cfg

cd  $RPATH

