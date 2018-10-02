#!/usr/bin/env bash
# Push HTML files to gh-pages automatically.

# Fill this out with the correct org/repo
ORG=24OI
REPO=OI-wiki
# This probably should match an email for one of your users.
EMAIL=sirius.caffrey@gmail.com

set -e

# Clone Theme for Editing
if [ ! -d "mkdocs-material" ] ; then
  git clone --depth 1 https://github.com/squidfunk/mkdocs-material.git
  sed -i '9a\<meta http-equiv="x-dns-prefetch-control" content="on">\n\<link rel="dns-prefetch" href="//fonts.loli.net">\n\<link rel="dns-prefetch" href="//cdnjs.loli.net">\n\<link rel="dns-prefetch" href="//oi-wiki.org">\n\<link rel="dns-prefetch" href="//cdn.jsdelivr.net">\n\<link rel="dns-prefetch" href="//api.github.com">' mkdocs-material/material/base.html
fi
sed -i "s/name: 'material'/name: null\n  custom_dir: 'mkdocs-material\/material'\n  static_templates:\n    - 404.html/g" mkdocs.yml
sed -i "s/- 'https:\/\/cdnjs.loli.net\/ajax\/libs\/mathjax\/2.7.5\/MathJax.js?config=TeX-MML-AM_CHTML'//g" mkdocs.yml

# Change Google CDN to loli.net
sed -i 's/fonts.gstatic.com/gstatic.loli.net/g' mkdocs-material/material/base.html
sed -i 's/fonts.googleapis.com/fonts.loli.net/g' mkdocs-material/material/base.html
sed -i "s/'assets\/fonts\/material-icons.css'/'https:\/\/fonts.loli.net\/icon?family=Material+Icons'/g" mkdocs-material/material/base.html
# sed -i 's/script/script data-no-instant/g' mkdocs-material/material/base.html
# sed -i 's/<head>/<head data-no-instant>/g' mkdocs-material/material/base.html
sed -i 's/{{ page.content }}/{% set pagetime = config.extra.pagetime %} {% if page and page.meta and page.meta.pagetime is string %} {% set pagetime = page.meta.pagetime %} {% endif %}{% if pagetime %}<blockquote class="page-time"><\/blockquote>{% endif %}\n                {{ page.content }}/g' mkdocs-material/material/base.html

# Patch for Han.js - use render only for main container.
# Maybe remove md-icons or just use an important attr. for icons?
# sed -i 's/<div class="md-content">/<div class="han-init-context">/g' mkdocs-material/material/base.html

cp ./static/main.html mkdocs-material/material/
cp ./static/disqus.html mkdocs-material/material/partials/integrations/disqus.html
cp ./static/footer.html mkdocs-material/material/partials/footer.html
cp ./static/extra.js docs/_static/js/extra.js
