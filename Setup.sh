#! /bin/sh

if [ ! -f existence_check_am7lutmwb3jal ]; then
  exit 1
fi

echo 'cleaning ... ignore "No such file or directory" errors'
./Clean.sh
echo 'cleaning fin'

echo

npm install . &&
/bin/mkdir dist &&
node_modules/.bin/browserify -r react -r react-dom src/bundle-react.js -o dist/bundle-react.js &&
/bin/cp node_modules/react-codemirror/dist/react-codemirror.js dist &&

git clone https://github.com/JedWatson/react-codemirror.git react-codemirror_git &&

/bin/cp react-codemirror_git/example/src/example.js src/example.jsx &&
( cd src && /usr/bin/patch -p1 <<EOS ) &&
--- a/example.jsx	2018-01-14 13:46:21.246810000 +0900
+++ b/example.jsx	2018-01-14 14:10:23.083136000 +0900
@@ -1,8 +1,9 @@
-var React = require('react');
-var ReactDOM = require('react-dom');
-var Codemirror = require('../../src/Codemirror');
+const React = require('react');
+const ReactDOM = require('react-dom');
+const Codemirror = window.Codemirror;
 const createReactClass = require('create-react-class');
 
+const CodeMirror = require('codemirror');
 require('codemirror/mode/javascript/javascript');
 require('codemirror/mode/xml/xml');
 require('codemirror/mode/markdown/markdown');
@@ -45,7 +46,7 @@
 		};
 		return (
 			<div>
-				<Codemirror ref="editor" value={this.state.code} onChange={this.updateCode} options={options} autoFocus={true} />
+				<Codemirror ref="editor" value={this.state.code} onChange={this.updateCode} codeMirrorInstance={CodeMirror} options={options} autoFocus={true} />
 				<div style={{ marginTop: 10 }}>
 					<select onChange={this.changeMode} value={this.state.mode}>
 						<option value="markdown">Markdown</option>
EOS
node_modules/.bin/browserify -u react -u react-dom src/example.jsx -o dist/example.js -t [ babelify --presets [ react ] ] &&

/bin/cp react-codemirror_git/example/src/index.html dist &&
( cd dist && /usr/bin/patch -p1 <<EOS ) &&
--- a/index.html	2018-01-14 11:45:55.526623000 +0900
+++ b/index.html	2018-01-14 11:54:21.478043000 +0900
@@ -1,5 +1,6 @@
 <!doctype html>
 <head>
+	<meta charset="utf-8" />
 	<title>React Codemirror</title>
 	<link rel="stylesheet" href="example.css">
 </head>
@@ -16,7 +17,7 @@
 			Copyright &copy; 2016 Jed Watson.
 		</div>
 	</div>
-	<script src="common.js"></script>
-	<script src="bundle.js"></script>
+	<script src="bundle-react.js"></script>
+	<script src="react-codemirror.js"></script>
 	<script src="example.js"></script>
 </body>
EOS
( cd react-codemirror_git && npm install . ) &&
( cd react-codemirror_git/node_modules/require-dir && /usr/bin/patch -p1 <<EOS ) &&
--- a/index.js	2012-07-03 10:09:27.000000000 +0900
+++ b/index.js	2018-01-14 09:13:21.880053000 +0900
@@ -48,7 +48,7 @@
 
     for (var base in filesForBase) {
         // protect against enumerable object prototype extensions:
-        if (!filesForBase.hasOwnProperty(base)) {
+        if (!Object.prototype.hasOwnProperty.call(filesForBase, base)) {
             continue;
         }
 
@@ -90,7 +90,7 @@
         // otherwise, go through and try each require.extension key!
         for (ext in require.extensions) {
             // again protect against enumerable object prototype extensions:
-            if (!require.extensions.hasOwnProperty(ext)) {
+            if (!Object.prototype.hasOwnProperty.call(require.extensions, ext)) {
                 continue;
             }

EOS
( cd react-codemirror_git && node_modules/.bin/gulp build:example:css ) &&
/bin/cp react-codemirror_git/example/dist/example.css dist &&

:
