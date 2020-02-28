loop through all files in folder and rename them. 
for file in *;do mv $file $file.txt; done

using sed, based on file name: 
for file in $(ls *.txt); do mv $file $(echo $file | sed 's/fil/nyttnamn/g'); done
