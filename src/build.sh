#!/bin/bash

echo "building doc2txt (linux)..."
v -prod doc2txt.v -o ../bin/linux/doc2txt

echo "building txt2nlp (linux)..."
v -prod txt2nlp.v -o ../bin/linux/txt2nlp

echo "building doc2txt (windows)..."
v -prod doc2txt.v -os windows -o ../bin/windows/doc2txt

echo "building xerdump (windows)..."
v -prod txt2nlp.v -os windows -o ../bin/windows/txt2nlp