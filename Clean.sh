#! /bin/sh

if [ ! -f existence_check_am7lutmwb3jal ]; then
  exit 1
fi

rm package-lock.json
rm -R node_modules
rm src/example.jsx
rm src/example.jsx.orig
rm -R dist
rm -Rf react-codemirror_git
