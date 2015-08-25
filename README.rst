pykbool is a `Cython <http://www.cython.org>`_ wrapper exposing the kbool library.

kbool is a polygon clipper provided within the `wxArt2D <http://www.wxart2d.org/>`_ framework as a third party library.
kbool was originally written by `Klaas Holwerda <http://boolean.klaasholwerda.nl/bool.html>`_.

One of kbool's feature is to provide connected keyhole polygons, which can be useful when rendering with engines not supporting polygons with holes like Tk.

kbool can be checked out from wxart2d SVN repo or extracted from the r842 archive::

    $ svn co http://svn.code.sf.net/p/wxart2d/code/trunk/wxArt2D/thirdparty/kbool
    $ tar xvfz data/kbool-wxart2d-code-842-trunk.tgz

pykbool installation and demos::

    $ python setup.py install
    $ python setup.py demo1
    $ python setup.py demo2
