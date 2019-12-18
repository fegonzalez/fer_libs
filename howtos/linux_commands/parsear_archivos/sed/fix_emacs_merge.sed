#Eliminar los restos de un merge hecho con emacs
#
sed '/^<<<<<<< variant A/,/^>>>>>>> variant B/d;/^======= end/d' emacs_merged_output.cpp >dummy_merged.output
