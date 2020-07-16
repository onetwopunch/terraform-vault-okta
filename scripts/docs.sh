#!/bin/bash

# Removes old docs from the end of the README and generates new ones

doc_start=$(grep -n '<!-- DOC_START -->' README.md | cut -f1 -d':')
head -$doc_start README.md > README.md.bak
terraform-docs md table --sort-by-required . >> README.md.bak
mv README.md.bak README.md
