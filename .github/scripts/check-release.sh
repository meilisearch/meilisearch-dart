#!/bin/sh

# Checking if current tag matches the package version
current_tag=$(echo $GITHUB_REF | tr -d 'refs/tags/v')
major=$(echo $current_tag | cut -d '.' -f1 )
minor=$(echo $current_tag | cut -d '.' -f2 )
round_current_tag="$major.$minor.0"

file1='pubspec.yaml'
file2='example/pubspec.yaml'
file3='example/pubspec.lock'
file4='README.md'
changelog_file='CHANGELOG.md'
ret=0

file_tag1=$(grep '^version: ' $file1 | cut -d ':' -f 2 | tr -d ' ')
file_tag2=$(grep 'meilisearch: "' $file2 | cut -d ':' -f 2 | tr -d '"' | tr -d ' ')
file_tag3=$(grep 'meilisearch' -A 6 $file3 | grep 'version: ' | cut -d ':' -f2 | tr -d '"' | tr -d ' ')
file_tag4=$(grep 'meilisearch: ' $file4 | cut -d '^' -f2)
if [ "$current_tag" != "$file_tag1" ] || [ "$current_tag" != "$file_tag2" ] || [ "$current_tag" != "$file_tag3" ] || [ "$round_current_tag" != "$file_tag4" ]; then
  echo "Error: the current tag does not match the version in package file(s)."
  echo "$file1: found $file_tag1 - expected $current_tag"
  echo "$file2: found $file_tag2 - expected $current_tag"
  echo "$file3: found $file_tag3 - expected $current_tag"
  echo "$file4: found $file_tag4 - expected $round_current_tag"
  ret=1
fi

# Checking the CHANGELOG file was updated
grep -q "$current_tag" "$changelog_file"

if [ "$?" -ne 0 ]; then
  echo "There is no description of the $current_tag release in $changelog_file"
  ret=1
fi

# Return
if [ "$ret" -eq 0 ]; then
  echo 'OK'
  exit 0
fi

exit 1
