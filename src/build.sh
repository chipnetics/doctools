#!/bin/bash

echo "building doc2txt (linux)..."
v -prod doc2txt.v -o ../bin/linux/doc2txt

echo "building txt2nlp (linux)..."
v -prod txt2nlp.v -o ../bin/linux/txt2nlp

echo "building doc2txt (windows)..."
v -prod doc2txt.v -os windows -o ../bin/windows_mingw/doc2txt

echo "building txt2nlp (windows)..."
v -prod txt2nlp.v -os windows -o ../bin/windows_mingw/txt2nlp

echo "zipping windows..."
zip -r ../bin/doctools_windows_mingw.zip ../bin/windows_mingw

echo "zipping linux..."
zip -r ../bin/doctools_linux.zip ../bin/linux

