#/bin/sh
for file in $(grep -l viejo_valor *.h);
do echo $file;
#
#sin cambiar de verdad
#do sed 's/viejo_valor/nuevo/g' $file; 
#
#orden definitiva
#do sed -i 's/viejo_valor/nuevo/g' $file; 
done



#DE OTRA FORMA:
sed -i 's/192.168.15.29/172.22.241.29/g' $(find -name 'hgrc')


# WARNING Mac computer (OS X): 'sed -i' requires the extension of backups files.
# See man

sed -i 's/viejo_valor/nuevo/g' $file         # ERROR
sed -i '.old' 's/viejo_valor/nuevo/g' $file  # OK & creates .old backup file
sed -i '' 's/viejo_valor/nuevo/g' $file      # OK & ignores backup file

