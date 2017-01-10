# Unicode Fundamentals

# Presenter Notes
- This talk covers both Python 2 and Python 3.
- Who's been bitten by unicode?

----

# In the beginning there was ASCII

7-bit encoding (128 values from 0x00 to 0x7f)

ASCII strings usually represented by a string of bytes

        0 1 2 3 4 5 6 7 8 9 A B C D E F
    0x0                      
    0x1                      
    0x2 ! " # $ % & ' ( ) * + , - . /
    0x3 0 1 2 3 4 5 6 7 8 9 : ; < = > ?
    0x4 @ A B C D E F G H I J K L M N O
    0x5 P Q R S T U V W X Y Z [ \ ] ^ _
    0x6 ` a b c d e f g h i j k l m n o
    0x7 p q r s t u v w x y z { | } ~                    

----

# What about non-English text?

- Let's use those extra 128 combinations
    - Proliferation of encodings for bytes 0x80 to 0xff (e.g. ISO-8859-1)

- But some languages have (far) more than 256 characters
    - multi-byte encodings (e.g. Shift JIS)

A string of bytes can mean lots of different things!

# Presenter Notes

You cannot know what text a series of bytes represents without its encoding

----

# Unicode

Universal Character Set - Represents characters as "code points"

Over 1 million available code points, enough for every language on Earth

Strings of Unicode code points can be *represented* using different encodings

----

# Encodings example: 'a'

<br>

![Unicode example: 'a'](unicode_a.png)
____

# Encodings example: 'é'

<br>

![Unicode example: 'é'](unicode_e.png)

----

# Python 2

----

# Byte strings in Python 2

`str` type - 8-bit strings (byte strings)

String literals are 8-bit strings (`str`) by default

They are **not** "ASCII strings"

    >>>'hello'
    'hello'
    >>>'\x62\x72\x10\xff'
    'br\x10\xff'

.notes: `str` is a generic byte string that happens to treat the range 0-127 as the corresponding ASCII character (e.g. for methods like `upper` and `lower`)

----

# Bytes are not text!

Text processing with byte strings is impractical unless you are **guaranteed** that everything is pure ASCII

Devices (terminal, files, network) give you **bytes** (unless the API decodes it for you)

.notes: You might think you're safe if you know that every encoded string is using the same encoding, but although some things will work (e.g. equality tests), other things will not.

----

# Bytes are not text! (Example 1)

    >>> name = raw_input('Name: ')
    Name: André
    >>> print "That has {} letters".format(len(name))
    That has 6 letters

.notes: Some characters take up multiple bytes in certain encodings

----

# Bytes are not text! (Example 2)

    >>> import sys
    >>> sys.stdin.encoding
    'UTF-8'
    >>> raw_input('Name: ')
    Name: André
    'Andr\xc3\xa9'
<p>

    >>> import sys
    >>> sys.stdin.encoding
    'ISO8859-1'
    >>> raw_input('Name: ')
    Name: André
    'Andr\xe9'

----

# Unicode strings in Python 2

`unicode` type - sequence of code points

Use '`u`' prefix for unicode literals

`unicode.encode(encoding)` → `str`

`str.decode(encoding)` → `unicode`

----

# Python 2 Unicode encoding

    >>> u'hello'.encode('utf-8')
    'hello'
    >>> u'André'.encode('utf-8')
    'Andr\xc3\xa9'
    >>> u'André'.encode('ISO8859-1')
    'Andr\xe9'
    >>> u'André'.encode('ascii')
    Traceback (most recent call last):
    ...
    UnicodeEncodeError: 'ascii' codec can't encode
    character u'\xe9' in position 4:
    ordinal not in range(128)

----

# Python 2 Unicode decoding
    >>> 'hello'.decode('utf-8')
    u'hello'
    >>> 'Andr\xc3\xa9'.decode('utf-8')
    u'Andr\xe9'
    >>> 'Andr\xe9'.decode('ISO8859-1')
    u'Andr\xe9'
    >>> 'Andr\x80'.decode('ascii')
    Traceback (most recent call last):
    ...
    UnicodeDecodeError: 'ascii' codec can't decode
    byte 0x80 in position 4:
    ordinal not in range(128)


----

# Unicode confusion in Python 2

    >>> u'hello'.decode('utf-8')
    u'hello'
    >>> u'André'.decode('utf-8')
    Traceback (most recent call last):
    ...
    UnicodeEncodeError: 'ascii' codec can't encode
    character u'\xe9' in position 4:
    ordinal not in range(128)
    ...

?????

.notes: Why does a `unicode` object even have a `decode` method??

----

# Automatic string coercion in Python 2

Python 2 will **automatically** convert between `str` and `unicode` if necessary.

    >>> import sys
    >>> sys.getdefaultencoding()
    'ascii'

Mixing `str` and `unicode` freely in code will seem to work fine... until you start to receive non-ascii unicode characters.

.notes: Python is normally a strongly typed language, which makes this implicit conversion policy extra weird.

----

# Python 3

----

# Python 3 makes it all better

`str`: text (sequence of Unicode code points)

`bytes`: bytes!

String literals are unicode by default (`str`), use the '`b`' prefix for bytes literals

----

# `encode`/`decode` in Python 3

`str.encode(encoding)` → `bytes`

`bytes.decode(encoding)` → `str`

<br>

`str.decode` doesn't exist!

`bytes.encode` doesn't exist!

# Presenter Notes

In Python 3, the delineation between bytes and text is very clear.

----

# Automatic string coercion in Python 3?

No!

Trying to mix `bytes` and `str` is a `TypeError`

----

# Best practices for Unicode in Python

- Always know what you have (text or bytes)
    - Don't mix them freely (Python 2 will let you, Python 3 won't)
- Take bytes in at the 'boundaries' (files, network, etc.), and use Unicode internally *everywhere*
- Test with non-ASCII characters (preferably code point 256 and above)
    - ℝεα∂@ßʟ℮ ☂ℯṧт υηḯ¢☺ḓ℮

.notes: Give examples of non-ascii readable text

----

# The End

See also:

- Ned Batchelder, PyCon 2012
    - [Pragmatic Unicode or How Do I Stop the Pain?](http://nedbatchelder.com/text/unipain/unipain.html)

