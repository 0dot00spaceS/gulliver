#!/usr/bin/env sh

# Downloads and patches the two files from lighthouse and devtools that we need
# to validate manifests.
#
# (These files are part of lighthouse, but depending on lighthouse would haul in
# multiple MBs of dependencies. So, we'll just dump the files here.)

curl -sO https://raw.githubusercontent.com/GoogleChrome/lighthouse/master/lighthouse-core/lib/manifest-parser.js
curl -sO https://raw.githubusercontent.com/ChromeDevTools/devtools-frontend/master/front_end/common/Color.js

# Generate patch via `git diff manifest-parser.js Color.js`
git apply - << END
diff --git i/third_party/manifest-parser.js w/third_party/manifest-parser.js
index 5ac9d72..b9e7ead 100644
--- i/third_party/manifest-parser.js
+++ w/third_party/manifest-parser.js
@@ -17,7 +17,10 @@
 'use strict';

 const url = require('url');
-const validateColor = require('./web-inspector').Color.parse;
+
+global.Common = {}; // the global is unfortunate, but necessary
+require('./Color.js');
+const validateColor = global.Common.Color.parse;

 const ALLOWED_DISPLAY_VALUES = [
   'fullscreen',
END
