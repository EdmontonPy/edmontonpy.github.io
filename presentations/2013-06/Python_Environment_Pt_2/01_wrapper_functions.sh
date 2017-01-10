function pause(){
   read -p "$*"
}

clear

pause "What functions does virtualenvwrapper give us?"

echo "#### Managing Environments ####
mkvirtualenv
mktmpenv
lsvirtualenv
showvirtualenv
rmvirtualenv
cpvirtualenv

#### Controlling the Active Environment ####
workon
deactivate

#### Quickly Navigating to a virtualenv ####
cdvirtualenv
cdsitepackages
lssitepackages

#### Path Management ####
add2virtualenv
toggleglobalsitepackages

#### Project Directory Management ####
mkproject
setvirtualenvproject
cdproject" | less

clear
pause "What functions are we going to look at today?"

echo "#### Managing Environments ####
mkvirtualenv -> Create a new environment
rmvirtualenv -> Remove an existing environment

#### Controlling the Active Environment ####
workon -----> Activate or change to another environment
deactivate -> Deactivate and change back to system Python

#### Path Management ####
toggleglobalsitepackages -> Allows the active environment to import from the global site-packages

#### Project Directory Management ####
mkproject ------------> Create a new environment AND a new project
setvirtualenvproject -> Associate an existing environment with a project
cdproject ------------> Change into the project directory" | less

clear
deactivate
clear
pause "Let's solve our requests issue!"
