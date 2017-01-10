function pause(){
   read -p "$*"
}

clear

pause "What do we know about pip so far?"

echo "# Search for a package
pip search <package>

# Install the latest version of one or more packages
pip install <package> ...

# Install specific version of one or more packages
pip install <package>==<version_number> ...

# Upgrade installed package(s)
pip install --upgrade <package> ...

# List all installed packages and versions
pip list

# List all packages that are outdated
pip list --outdated" | less

clear
pause "We have only really used search, install, and list.

We can still uninstall, freeze, show, zip, unzip, bundle, and much more!"

echo "# Uninstall package(s)
pip uninstall <package> ...

# Generate a list of installed packages in 'requirements' format
pip freeze

# Generate a list of installed packages in 'requirements' format using an existing file as a template
pip freeze --requirement <file>

# Install from the given requirements file.
pip install --requirement <file>
" | less

clear
pause "Let's improve our development process!"
