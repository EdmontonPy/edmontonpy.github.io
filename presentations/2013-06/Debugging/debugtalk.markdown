# Debugging: How to learn from your mistakes

----

# 20 minute introduction to Python

... is not what this is.

There are lots of good resources already out there for learning the language:

- <http://learnpythonthehardway.org>
- <http://pythonmonk.com>
- <http://www.codeacademy.com/tracks/python>

----

# Why teach debugging?

Learning from success is easy (and fun), but failure will happen.

If we don't teach beginners how to learn from failure, we fail to teach them how to learn.

----

# 3 steps to self-sufficiency

1. Read and *understand* error messages
2. Experiment in the interactive interpreter
3. `pdb`, the Python debugger

----

# Read and understand error messages

----

# Don't fear the traceback

Example of a common traceback:

    !bash
    Traceback (most recent call last):
      File "sample2.py", line 9, in <module>
        random_square()
      File "sample2.py", line 6, in random_square
        pring('Number: {num}'.format(num=val))
    NameError: global name 'pring' is not defined

This is your most valuable tool for finding out what went wrong.

.notes: The traceback contains the dying words of a crashed program.

----

# Traceback breakdown

    !bash
    Traceback (most recent call last):
<p></p>

    !bash
      File "sample2.py", line 9, in <module>
        random_square()
<p></p>

    !bash
      File "sample2.py", line 6, in random_square
        pring('Number: {num}'.format(num=val))
<p></p>

    !bash
    NameError: global name 'pring' is not defined

----

# The error message

    !bash
    NameError: global name 'pring' is not defined

This last line is most important

`<Type of error>: <helpful error message>`

Errors (e.g. a `NameError`) are Python objects! All are documented online.

<http://docs.python.org/3/library/exceptions.html>

.notes: NameError is very common, especially when starting out

----

# `(most recent call last)`

The final 3 lines show what whent wrong and where:

    !bash
      File "sample2.py", line 6, in random_square
        pring('Number: {num}'.format(num=val))
<p/>

    !bash
    NameError: global name 'pring' is not defined

The previous lines show how you got there:

    !bash
      File "sample2.py", line 9, in <module>
        random_square()

----

# Experiment in the interactive interpreter

----

# Try things out

Instead of writing your whole program top-to-bottom, build your program in the interpreter first.

    !bash
    >>>val = input('Enter a number: ')
    Enter a number: 23
    >>>val
    '23'
    >>>type(val)
    <class 'str'>
    >>>int(val)
    23

.notes: Building bigger pieces out of small pieces is a kind of preemptive debugging

----

# Even better: IPython and BPython

<http://ipython.org>

    !bash
    $ pip install ipython
    $ ipython3

<http://www.bpython-interpreter.org>

    !bash
    $ pip install bpython
    $ bpython

.notes: If you need to install pip, refer to Brian's pip instructions at <http://edmontonpy.com/presentations/>

----

# `pdb`, the Python debugger

----

# Ultimate debugging power

Interact with your program as it executes step-by-step.

Can also inspect a crashed program at the moment the error occurred.

<http://docs.python.org/3.3/library/pdb.html>

<http://pymotw.com/2/pdb/index.html>

* for Python 2, but still relevant

.notes: Unfortunately for beginners this means learning yet another set of commands at the same time they're learning the language itself. Still, learning pdb is an incredibly useful skill.

----

# 3 ways to use `pdb`

1. Prompt/terminal: `python -m pdb <myfile.py>`
2. Post-mortem from the interpreter: `import pdb; pdb.pm()` 
3. In code: `import pdb; pdb.set_trace()`

.notes: I don't demo #3 or talk about it further because it's the least convenient

----

# `pdb` from the terminal

`python -m pdb <myfile.py>`

Starts with execution paused at the first line of your file.

Can step through line by line, see values of variables, change variables, etc.

----

# `pdb` from the interpreter

After a crash: `pdm.pm()` (post-mortem)

Returns to execution state when the exception occurred.

Unfortunately cannot resume code execution post-mortem; use breakpoints for that.

----

# Commands used in `pdb` demo

* list - show where you are in the code
* step - advance one line / function call
* cont - start running again (until breakpoint)
* jump - jump straight to a line number

----

# Summary

If you know how to debug your programs, you know how to learn from failure.

We do beginners a disservice if we fail to teach them how to be self-sufficient.
