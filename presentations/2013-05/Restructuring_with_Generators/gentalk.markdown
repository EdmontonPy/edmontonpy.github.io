# Restructuring your code with generators

----

# Me
* Aden Grue
* Fugitive from C++ development
* Computer engineering background
* Grew up with C-style languages

.notes: The best way to learn to be thankful of Python's more powerful constructs is to program without them for 20+ years!

----

# Standard intro to generators

(All code is Python 3)

    !python3
    # introduced in Python 2.0
    squares = [x**2 for x in range(10)]
    for s in squares:
        # ...

Slow! Inefficient! Old and busted!

    !python3
    # introduced in Python 2.4
    squares = (x**2 for x in range(10))
    for s in squares:
        # ...

Fast! Efficient! New hotness! Wow!

... so is that all generators can do?

.notes: The standard intro to generators moves from list comprehensions to generator expressions, giving the impression that generators are just a more efficient way of doing things you could already do. But generator functions can be powerful tools for restructuring your code to make it more readable, understandable, and testable.

# Presenter notes
Ask who has used / knows about list comprehensions / generators

* These two lines are ways of doing pretty much the same thing
* The only difference between the two lines is the square vs round brackets

----

# A simple script, a simple loop

    !python3
    num_words = 3
    print('Give me {n} words'.format(n=num_words))

    for _ in range(num_words):
        line = input('Word: ')
        print('Your word: {word}'.format(word=line))

.notes: Our sample program starts out as this.

# Presenter notes

* Describe briefly the functionality of this loop
* I hope nobody is thinking about needing to add functions to this

----

# Repeating ourselves a little

    !python3
    num_words = 3
    print('Give me {n} words'.format(n=num_words))

    for _ in range(num_words):
        line = input('Word: ')
        print('Your word: {word}'.format(word=line))

    # other stuff here

    num_words = 4
    print('Now give me {n} words'.format(n=num_words))

    for _ in range(num_words):
        line = input('Word: ')
        print('Your word: {word}'.format(word=line))

.notes: This is getting a little repetitive, but not overly so.

# Presenter notes

* At this point you may be getting the DRY itch
* It's not that bad - every line is expressive and we can factor out prompt/response using variables

----

# Repeating ourselves a lot

    !python3
    num_words = 3
    print('Give me {n} words'.format(n=num_words))

    for _ in range(num_words):
        while True:
            line = input('Word: ').strip()
            if len(line.split()) != 1:
                print('Not a word!')
            else:
                break

        print('Your word: {word}'.format(word=line))

    # now do this exact same thing in 10 other places!

.notes: Okay, now it's getting ridiculous. Repeating this boilerplate all over the place would be unmaintainable. Plus it's visual noise that obfuscates the purpose of the code.

# Presenter notes

* Now we also want to do validation on the data
* DRY: even if you can guarantee this code will never change, it's visual noise - people's eyes will glaze over

----

# Put everything in a function

    !python3
    def get_words(num_words):
        for _ in range(num_words):
            while True:
                line = input('Word: ').strip()
                if len(line.split()) != 1:
                    print('Not a word!')
                else:
                    break

            print('Your word: {word}'.format(word=line))

    # ...

    num_words = 3
    print('Give me {n} words'.format(n=num_words))
    get_words(num_words)

    # etc.

.notes: Everyone's first instinct is to grab all the repeated code and stuff it into a function.

# Presenter notes

* This is everyone's first instinct, and for good reason!
* Anyone who's been programming for a while knows this isn't the end of the story

----

# This can be overkill

    !python3
    def get_words(num_words):
        for _ in range(num_words):
            while True:
                line = input('Word: ').strip()
                if len(line.split()) != 1:
                    print('Not a word!')
                else:
                    break

            # help! they've taken me hostage!
            print('Your word: {word}'.format(word=line))
            #

What if we want to do something else sometimes?

Give a different response? No response? Capitalize the word? Put it in a database?
All (or some) of the above?

Start parameterizing the function: this can lead to an unreadable mess of unrelated code paths.

.notes: Along with all the boilerplate, we've taken the useful work and hidden it away in the function as well. This can come back to bite us if we want the 'useful work' part to be flexible.

# Presenter notes

* Code continues to change: some of the 'repeated code' we might want to change later
* There are ways around this (passing parameters), but they lead to complexity and don't address the real problem

----

# Factor out the loop boilerplate

    !python3
    def get_valid_word():
        while True:
            line = input('Word: ').strip()
            if len(line.split()) == 1:
                return line
            else:
                print('Not a word')

    # ...

    num_words = 3
    print('Give me {n} words'.format(n=num_words))

    for _ in range(num_words):
        word = get_valid_word()
        print('Your word: {word}'.format(word=line))

.notes: This is more flexible. It's also still pretty easy to understand, and we don't have that much boilerplate to wade through.

# Presenter notes
* Much less indirection, easier to understand
* More flexible, we can ignore the boilerplate or change it in special cases

----

# Control issues

    !python3
    for _ in range(num_words):
        word = get_valid_word()
        if word == 'stop':
            break
        print('Your word: {word}'.format(word=line))

More complicated loop control still has to be done explicitly - we can't hide it away.

.notes: We can't factor out everything we want using this technique - functions can't directly control the flow of our loop.

# Presenter notes
* All the ugly loop control details are still out in the open for us to see (and mess up when we copy/paste)

----

# There's got to be a better way!

# Presenter notes
* Time to start offering solutions

----

# The real problem

We want to separate the low-level data input and validation logic from the useful work

    !python3
    for _ in range(n):
        # low-level details about what counts as valid input,
        # pre-processing of input, loop control

        # ----

        # high-level execution of useful work

What we want:

    !python3
    for word in get_n_valid_words_from_user_until_user_says_stop():
        do_useful_work(word)

Yes! How do I make this happen?

.notes: This would be ideal - encapsulate the loop control and boilerplate in a function yet still let us vary the 'useful work' part.

# Presenter notes
* Thinking about refactoring in terms of code reuse only ignores the real problem
* We want a function that can execute the first part of the loop and then pass control back to us

----

# Generator functions with '`yield`'

    !python3
    def gen_valid_words(num_words):
        for _ in range(num_words):
            while True:
                line = input('Word: ').strip()
                if len(line.split()) != 1:
                    print('Not a word!')
                else:
                    break

            yield line

    # ...

    num_words = 3
    print('Give me {n} words'.format(n=num_words))

    for word in get_valid_words(num_words):
        print('Your word: {word}'.format(word=word))

.notes: `yield` lets the return value of the function be used as an iterator, exactly as we wanted in the last slide. The function will execute until it yields a value, then freeze until the next iteration. The iteration stops when the function returns.

# Presenter notes
* Describe briefly how yield works. Make it explicit that the special thing about a generator function is `yield`
* `yield` makes the function result iterable

----

# The right level of refactoring

This level of refactoring is 'just right'

* We can hide away all the low-level iteration and control details in the generator
* We still get to see right away what the loop is doing
* We can make the loop do whatever we want

.notes: Relevant Zen of Python adjectives: beautiful, explicit (not implicit), flat (not nested).

# Presenter notes

----

# Build generators from simple pieces

    !python3
    def gen_input(prompt):
        while True:
            yield input(prompt)

.notes: A generator that gets values from the user forever.

# Presenter notes
Instead of building the generator all at once, let's build it out of simple pieces.
Each piece is concerned with details at a different level

----

# Chain generators together

    !python3
    def gen_input(prompt):
        ...

    def gen_valid_words(prompt):
        for line in gen_input(prompt):
            line = line.strip()
            if len(line.split()) != 1:
                print('Not a word!')
            else:
                yield line

.notes: This generator gets its input from another generator and only yields valid words (otherwise prints an error and skips over the value).

# Presenter notes
* Breaking up generators like this makes them easier to understand

----

# Chain generators together (2)

    !python3
    def gen_valid_words(prompt):
        ...

    def gen_n_valid_words(num_lines):
        if num_lines <= 0:
            return
        num_yielded = 0
        for word in gen_valid_words('Word: '):
            yield word
            num_yielded += 1
            if num_yielded >= num_lines:
                return

    # ...

    for word in gen_n_valid_words(5):
        print('Your word was {word}'.format(word=word))

.notes: Use 'return' with no argument to stop iterating - returning values is not allowed when using yield.

# Presenter notes
* This generator is only in charge of counting out a fixed number of values - separation of concerns
* When each generator does one thing very well, you can reason about and test the components very easily

----

# Summary

* When refactoring looping constructs, think about generators
* Factor complicated generators into simple ones and chain them together
* Think about how you want your code to look, then find a way to refactor that lets you write it that way!

----

# The End

* Ned Batchelder
    * PyCon 2013 - [Loop Like a Native](http://nedbatchelder.com/text/iter.html)
* David Beazly
    * PyCon 2008 - [Generator Tricks for Systems Programmers](http://www.dabeaz.com/generators/)

