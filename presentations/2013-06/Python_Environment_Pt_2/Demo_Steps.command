# Client 1 asks us to build something for them.
# We already have requests installed (version 0.13.0)
pip list
python3 client_1.py

# Client two asks us to build something requiring python-dateutil and requests.
pip search python-dateutil
pip install python-dateutil

# Are there any updates to packages that we need?
pip list --outdated
pip install --upgrade requests

# Let's see if Client 2's project is all working
python3 client_2.py

# Client 1 comes back to us and asks for some small changes.
python3 client_1.py

# The API for requests changed across versions.

# Could keep downgrading and upgrading the versions of requests as we do work
# for each client, but that is a really messy solution.

pip list
# This is just getting messy now! six and python-dateutil are there, but
# Client 1 doesn't use them

which mkvirtualenv
# Isn't a program, it's actually a function from virtualenvwrapper.sh

# Show all of the functions that virtualenvwrapper defines.
# Make sure to source it.
. 01_wrapper_functions.sh

# Make a new environment for client 1
mkvirtualenv client_1_project
echo $PS1
which python3
deactivate
which python3

# Make a new environment for client 2
mkvirtualenv client_2_project

# Show that workon lists and autocompletes
workon
workon client_1_project
pip install requests==0.13.0
pip list
python3 client_1.py

# Install into client 2 and talk about how the dependencies are cleanly separated
workon client_2_project
pip list
pip install requests python-dateutil
pip list
python3 client_2.py

# Cleanly separated now
# Have been concentrating on virtualenv, but now we'll see how pip helps
./02_pip_functions.sh

# Install docopt for development
pip install docopt

# Work with it for a bit, but it doesn't really fit
pip list
pip uninstall docopt

# Now that we have a stable setup, we want to document it
clear; pip list
pip freeze
pip freeze > requirements.txt
less requirements.txt

# This basic requirements file is correct, but isn't laid out so well.
# Instead, we can re-arrange it and comment it as we want.
# Here is an old requirements file that we have already altered from our source code control.
clear; cat old_requirements.txt
pip freeze --requirement old_requirements.txt

pip freeze --requirement old_requirements.txt > new_requirements.txt
opendiff old_requirements.txt new_requirements.txt
# mv new_requirements.txt old_requirements.txt

# Say we want to deploy stuff to another machine or another developer
mkvirtualenv other_machine -r new_requirements.txt
pip list
python client_2.py

# Talk about how I have used these requirements files
./03_uses_of_requirements.sh

# Deleting old environments.
# So lightweight that I make and delete them constantly
deactivate
rmvirtualenv other_machine
workon


# Can give your environments access to the global site-packages with
# toggleglobalsitepackages

# toggleglobalsitepackages is sticky. It will hold its state unless changed.
# Even across deactivations

# virtualenv has the notion of projects.
# need to set the PROJECT_HOME variable first though

# Notice that it changes into the project dir after activation
# This will happen to any project on activation.


# Two more points


# There are extra files that virtualenvwrapper uses to control behavior
# Hook files
# In ~/.virtualenvs
ls ~/.virtualenvs
emacs ~/.virtualenvs/postactivate
emacs ~/.virtualenvs/postmkvirtualenv
mkvirtualenv w_hooks
deactivate
rmvirtualenv w_hooks


# Final use case for virtualenv
# Different interpreters
# Useful for switching to Python 3 as your default, but still wanting access to 2.x
mkvirtualenv --python=python2.7 new_27_env
which python
python --version
deactivate

# rmvirtualenv new_27_env client_1_project client_2_project



















###############################################################################
# Not talked about in-depth
###############################################################################

# Can give your environments access to the global site-packages.
pip list
workon client_2_project
pip list
toggleglobalsitepackages
pip list
toggleglobalsitepackages
pip list
# toggleglobalsitepackages is sticky. It will hold its state unless changed.
# Even across deactivations

# virtualenv has the notion of projects.
# need to set the PROJECT_HOME variable first though
clear
export PROJECT_HOME="$(pwd)"
ls -A1
mkproject client_3_project

# Notice that it changes into the project dir after activation
# This will happen to any project on activation.
pwd
ls -A1

# Can also use cdproject to always take you to your project files
cd
cdproject
pwd
deactivate
cd "$PROJECT_HOME"
rmvirtualenv client_3_project
ls -A1
rmdir client_3_project
unset PROJECT_HOME

# Can also use setvirtualenvproject
# Can call this from a deactivated state with explicit args
# Can call from an activated state with implicit args for project and dir (uses pwd)

