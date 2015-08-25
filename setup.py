# -*- coding: utf-8 -*-
import sys, os.path, traceback
version='0.1.2'

def demo1():
    try:
        
        if sys.version_info[0] == 3:
            from tkinter import Tk, Canvas, PhotoImage, NW, SW
        else:
            from Tkinter import Tk, Canvas, PhotoImage, NW, SW
    except ImportError:
        Tk = Canvas = None      

    if Tk: 
        from pykbool import connect
        
        contour = [(491.1025968497233, 19.886736214605065), (491.1025968497233, 5.524093392945851), (455.34269902086, 5.524093392945851), (455.34269902086, 19.886736214605065), (353.68241805023416, 17.677098857426728), (353.68241805023416, 8.838549428713364), (323.20136228182207, 8.838549428713364), (323.20136228182207, 17.677098857426728), (210.81311196253725, 14.362642821659207), (210.81311196253725, 3.3144560357675132), (175.05321413367392, 3.3144560357675132), (175.05321413367392, 14.362642821659207), (73.22264793529162, 14.362642821659207), (73.22264793529162, 10.0), (34.05704555129843, 10.0), (32.18390804597701, 110.48186785891704), (10.0, 110.48186785891704), (10.0, 162.40834575260803), (48.36100468284376, 156.88425235966218), (75.09578544061303, 156.88425235966218), (128.56534695615156, 162.40834575260803), (178.62920391656024, 176.77098857426725), (226.81992337164752, 196.65772478887232), (249.9787143465304, 211.02036761053148), (291.18773946360153, 246.374565325385), (328.65048957002983, 283.9384003974168), (337.5053214133674, 298.30104321907595), (337.5053214133674, 341.3889716840536), (448.1907194550873, 350.22752111276696), (448.1907194550873, 333.6552409339294), (685.7386121753938, 350.22752111276696), (683.8654746700724, 356.856433184302), (771.3920817369094, 364.5901639344262), (774.9680715197957, 318.18777943368104), (767.816091954023, 318.18777943368104), (789.272030651341, 60.765027322404364), (796.4240102171137, 60.765027322404364), (800.0, 8.838549428713364), (757.088122605364, 8.838549428713364), (757.088122605364, 23.20119225037257), (644.6998722860792, 19.886736214605065), (644.6998722860792, 8.838549428713364), (610.8131119625373, 5.524093392945851), (608.9399744572158, 19.886736214605065)]
        holea = [(162.62239250744997, 127.0541480377546), (189.35717326521925, 135.89269746646795), (239.42103022562793, 159.09388971684052), (287.6117496807152, 187.81917536015894), (308.8974031502767, 205.49627421758566), (348.2332907620264, 246.374565325385), (366.1132396764581, 266.26130153999003), (389.272030651341, 301.6154992548435), (450.0638569604087, 307.13959264778936), (451.7667092379736, 57.45057128663686), (355.38527032779905, 55.24093392945852), (355.38527032779905, 66.28912071535022), (323.20136228182207, 66.28912071535022), (323.20136228182207, 55.24093392945852), (210.81311196253725, 55.24093392945852), (210.81311196253725, 60.765027322404364), (173.35036185610898, 60.765027322404364), (173.35036185610898, 55.24093392945852), (73.22264793529162, 51.926477893691), (71.51979565772669, 116.00596125186286), (107.27969348659005, 119.32041728763039)]
        holeb = [(749.9361430395913, 60.765027322404364), (498.254576415496, 57.45057128663686), (494.67858663260967, 294.9865871833085), (566.0280970625798, 301.6154992548435), (566.0280970625798, 292.77694982613014), (591.0600255427842, 292.77694982613014), (589.3571732652192, 303.8251366120218), (730.3533418475947, 315.9781420765027)]
          
        connected_polygon = connect([contour, holea, holeb])

        root = Tk()
        root.title(string='connect holes to contour / fill resulting polygon')
        canvas1 = Canvas(root, width=900, height=415, background='white')
        canvas1.pack()

        canvas1.create_polygon(contour, outline='blue', fill='')
        canvas1.create_text(contour[0], text='C(1)')
        canvas1.create_text(contour[20], text='C(i)')
        canvas1.create_text(contour[-1], text='C(n)')

        canvas1.create_polygon(holea, outline='red', fill='')
        canvas1.create_text(holea[0], text='H1(1)')
        canvas1.create_text(holea[9], text='H1(i)')
        canvas1.create_text(holea[-1], text='H1(n)')

        canvas1.create_polygon(holeb, outline='green', fill='')
        canvas1.create_text(holeb[0], text='H2(1)')
        canvas1.create_text(holeb[2], text='H2(i)')
        canvas1.create_text(holeb[-1], text='H2(n)')
        
        canvas1.create_text((10, 350), text='# More info in setup.py\n'
            'from pykbool import connect\n'
            'contour=[(... , ...) ... ]; hole1=[(... , ...) ... ]; hole2=...\n'
            'polygon=connect([contour, hole1, hole2, ...])', anchor=SW)
        
        canvas2 = Canvas(root, width=900, height=415, background='white')
        canvas2.pack()
        image=PhotoImage(file=os.path.join('data','demo.gif'))
        canvas2.create_image((0,0), image=image, anchor=NW)
        canvas2.image=image
        canvas2.create_polygon(connected_polygon, outline='black', fill='grey')
        canvas2.create_text(connected_polygon[0], text='P1')
        canvas2.create_text(connected_polygon[62], text='Pi')
        canvas2.create_text(connected_polygon[-1], text='Pn')

        root.mainloop()


def demo2():
    try:
        if sys.version_info[0] == 3:
            from tkinter import Tk, Canvas
        else:
            from Tkinter import Tk, Canvas
    except ImportError:
        Tk = Canvas = None      

    if Tk: 
        from pykbool import connect
        import json, gzip
        
        with gzip.open(os.path.join('data','poly.json.gz'), 'r') as f:
            contour, holes = json.loads(f.readline().decode())
        
        try:
            connected = connect([contour]+holes)

            root1 = Tk()
            root1.title(string='not connected - contour (%d points) + holes (%d points)'%(len(contour), sum(map(len, holes))))
            canvas1 = Canvas(root1, width=810, height=510, background='white')
            canvas1.pack()
            canvas1.create_polygon(contour, outline='blue', fill='')
            for hole in holes:
                canvas1.create_polygon(hole, outline='red', fill='')

            root2 = Tk()
            root2.title(string='connected - keyhole polygon (%d points)' %(len(connected)))
            canvas2 = Canvas(root2, width=810, height=510, background='white',)
            canvas2.pack()

            canvas2.create_polygon(connected, outline='black', fill='#98BAD3', dash=(4,))

            canvas2.create_text(connected[0], text='P1', fill='red')
            canvas2.create_text(connected[int(len(connected)*0.5)], text='Pi', fill='red')
            canvas2.create_text(connected[int(len(connected)*2/3)], text='Pj', fill='red')

            root1.mainloop()
        except:
            traceback.print_exc()


if sys.argv[-1] == 'demo1':
    demo1()
elif sys.argv[-1] == 'demo2':
    demo2()
elif sys.argv[-1] == 'dist':
    import shutil, os, tarfile
    releasedir = 'pykbool-%s'%(version)
    shutil.rmtree(releasedir, True)
    os.mkdir(releasedir)
    os.mkdir(os.path.join(releasedir, 'data'))
    for file_ in ('README.rst',
                  'LICENSE', 
                  'setup.py',
                  'pykbool.pyx', 
                  os.path.join('data','demo.gif'), 
                  os.path.join('data', 'poly.json.gz'), 
                  os.path.join('data', 'kbool-wxart2d-code-842-trunk.tgz')):
        shutil.copy(file_, '%s/%s'%(releasedir, file_))
    with tarfile.open('%s.tgz'%(releasedir), 'w:gz') as a:
        a.add(releasedir)
    
else:
  
    from distutils.core import setup
    from distutils.extension import Extension

    try:
        from Cython.Distutils import build_ext
    except ImportError:
        print ('Cython (www.cython.org) not found')
        sys.exit(0)

    sources=[''.join(('kbool/src/', s)) for s in ['booleng.cpp', 'graphlst.cpp', 'line.cpp', 'lpoint.cpp', 'record.cpp',
                                                'graph.cpp', 'link.cpp', 'node.cpp', 'scanbeam.cpp']]
    #ext_modules=[ Extension('pykbool', ['pykbool.pyx'] + sources, include_dirs=['kbool/include'], define_macros=[('KBOOL_DEBUG', None)], language="c++", extra_compile_args=["-g"], extra_link_args=["-g"]) ]
    ext_modules=[ Extension('pykbool', ['pykbool.pyx'] + sources, include_dirs=['kbool/include'], language="c++") ]
    
    setup(name = 'pykbool', 
          version = version,
          url = 'https://github.com/decitre/pykbool',
          author = 'Emmanuel Decitre',
          license = 'LGPL',
          description = "A Cython wrapper for the kbool library",          
          cmdclass = {'build_ext': build_ext}, ext_modules = ext_modules)
