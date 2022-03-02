v -prod -cc msvc doc2txt.v -o ..\bin\windows_msvc\doc2txt
v -prod -cc msvc txt2nlp.v -o ..\bin\windows_msvc\txt2nlp

rm ../bin/windows_msvc/*.pdb

tar -a -c -f ..\bin\doctools_windows_msvc.zip ..\bin\windows_msvc
