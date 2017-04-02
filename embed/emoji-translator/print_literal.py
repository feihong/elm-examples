"""
Print the List Char literal to use inside Emojifier.elm. There's no easy way to 
generate this in Elm itself.

"""

start = 0x1f600
for i in range(start, start+53):
    c = chr(i)
    print("       , '{}'".format(c))