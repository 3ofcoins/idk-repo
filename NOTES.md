# Requirements

## Ruby and the development environment
- gcc-4.2 (OSX: non-LLVM) etc
- XCode command line?
- homebrew?
- rvm || rbenv
- Ruby 1.9.3 w/ Rubygems & Bundler
- libxml2, libxslt (for nokogiri)
- VirtualBox (for Vagrant)
- Python (for Sphinx)
- LaTeX (for Sphinx & PDF docs)

# Development

Ignore Gemfile.lock without pushing it globally and having it merged
into child repo:

    echo Gemfile.lock >> .git/info/exclude

## Python

    $PYTHON vendor/virtualenv/virtualenv.py vendor/root/
    vendor/root/bin/pip install -r vendor/requirements.txt
