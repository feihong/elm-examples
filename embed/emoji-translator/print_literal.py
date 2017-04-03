"""
Print the List Char literal to use inside Emojifier.elm. There's no easy way to 
generate this in Elm itself.

"""

start = 0x1f600
chars = (chr(i) for i in range(start, start+52))
for i, char in enumerate(chars, 1):
    print("       -- {}".format(i))
    print("       , '{}'".format(char))