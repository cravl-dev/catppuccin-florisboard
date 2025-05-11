set export

_default:
  @just --list

version := `whiskers extension.tera && jq '.meta.version' extension.json | tr -d '"'`

# Remove the './dist' directory and extension.json
clean:
  test -d ./dist && rm -rfv ./dist || true
  test -f extension.json && rm -fv extension.json || true

# Minify JSON files and put source files into "./dist"
build: clean
  whiskers florisboard.tera
  whiskers extension.tera
  cat extension.json | jq -c > dist/extension.json
  for file in `ls dist/stylesheets`; do \
      cat dist/stylesheets/$file | jq -c > dist/stylesheets/minify_$file; \
      mv -v dist/stylesheets/minify_$file dist/stylesheets/$file; \
  done

# Zip "./dist" into the "./flex" format
zip: build
  test -f catppuccin-{{version}}.flex && rm -v catppuccin-{{version}}.flex || true
  cd dist && zip -r ../catppuccin-{{version}}.flex .
