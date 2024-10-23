#!/bin/sh

# Set error handling
set -e

# Define directories
src_dir="site/content"
build_dir="site/content/executed"

# Create the build.ninja file
cat <<EOF > build.ninja
# Define variables
src_dir = $src_dir
build_dir = $build_dir

# Rule to convert Markdown to HTML
rule markdown_to_html
  command = pandoc \$in --lua-filter=./bin/executor.lua --from markdown --to markdown -o \$out
  description = Converting \$in to \$out

EOF

# Find all markdown files in the source directory and subdirectories
src_files=$(find "$src_dir" -name '*.md' | grep -v "$build_dir")

# Generate build rules for each source file
for src_file in $src_files; do
    target_file=$(echo "$src_file" | sed "s|$src_dir|$build_dir|" | sed 's|\.md$|\.md|')
    echo "build $target_file: markdown_to_html $src_file" >> build.ninja
done

# Add the all target and default target
cat <<EOF >> build.ninja

# All target
build all: phony $(echo $src_files | sed "s|$src_dir|$build_dir|g" | sed 's|\.md|\.md|g')

# Default target
default all
EOF

# Run ninja
# ninja
# cat build.ninja