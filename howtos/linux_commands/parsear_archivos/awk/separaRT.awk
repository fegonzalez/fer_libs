begin{
FS="\t"
}
{
destino=fichero rt
if ($1~rt||$4~rt) printf ("\n%s\t%s\t%s\t%s\t%s\t%s",$6,$7,$8,$9,$3,$10)>destino
}
