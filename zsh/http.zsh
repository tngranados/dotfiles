# Creates a static server using ruby, php, or python 2 or 3, whichever is
# available. It support an optional port (default is 8000).
shttp() {
  local port="${1:-8000}"
  if (( $+commands[php] )); then
    php -S localhost:$port
  elif (( $+commands[python] )); then
    local pythonVer=$(python -c 'import platform; major, _, _ = platform.python_version_tuple(); print(major);')
    if [ $pythonVer -eq 2 ]; then
      python -m SimpleHTTPServer $port
    else
      python -m http.server $port
    fi
  elif (( $+commands[ruby] )); then
    ruby -run -ehttpd . -p$port
  else
    echo "Error: Ruby, PHP or Python needed"
  fi
}
