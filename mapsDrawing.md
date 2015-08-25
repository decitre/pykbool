# Introduction #

tkinter provides nice canvas objects like, points, polylines, areas, texts, etc...
But tkinter does not support polygons with **holes**, which is a drawback for map drawing. pykbool module **feeds that gap**.

# Details #

I made a [GDF](http://en.wikipedia.org/wiki/Geographic_Data_Files) parser in C++ and python (actually using [Cython](http://www.cython.org)).

With C++ you get speed, compactness and the nice [boost libraries](http://www.boost.org/).

With Python you get a command interpreter, scriptability, [objects mutation](http://inst.eecs.berkeley.edu/~selfpace/cs9honline/Q2/mutation.html) and numerous extensions such as [tkinter](http://wiki.python.org/moin/TkInter).

With tk(inter) canvas, it is quite easy to draw complex 2D graphics. But while using it to draw maps, I always missed keyhole polygons support when it came to paint/fill building landmarks, or small islands. I always had to paint the holes after the contours, and since tk does not understand transparency, I had to find a convenient color to paint the holes... With (py)kbool I could merge multipolygons into a closed polygonal chain, thus compatible with tk color filling algorithms.

![![](http://pykbool.googlecode.com/svn/wiki/keyhole4.png)](http://pykbool.googlecode.com/svn/wiki/keyhole4.png)