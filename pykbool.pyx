# pykbool.pyx     
# Provides Python bindings to kbool (http://boolean.klaasholwerda.nl/)

"""Boolean engine to perform operation on two sets of polygons.

   First the engine needs to be filled with polygons.
   The first operand in the operation is called group A polygons, the second group B.

   The boolean operation ( BOOL_OR, BOOL_AND, BOOL_EXOR, BOOL_A_SUB_B, BOOL_B_SUB_A )
   are based on the two sets of polygons in group A and B.
   The other operations ( BOOL_CORRECTION, BOOL_SMOOTHEN, BOOL_MAKERING)
   are based on group A only.
 
   At the end of the operation the resulting polygons can be extracted.
"""

# Cython and C++: http://docs.cython.org/src/userguide/wrapping_CPlusPlus.html


from libcpp cimport bool

cdef extern from '<string>':
    cdef cppclass std_string 'std::string':
        std_string()
        std_string(char *)
        char* c_str()
    

cdef int KboolError() except *:
    """Exception handling function called in case of C++ exception"""
    try:
        with open('kbool.log') as l:
            msg = l.read()
    except IOError:
            msg = ''    
    raise RuntimeError('Exception occured in libkbool\n%s' % (msg))

cdef extern from "kbool/booleng.h":
    cdef enum GroupType:
        GROUP_A,
        GROUP_B
    cdef enum Operation 'BOOL_OP':
        BOOL_NON, # Not supported in kbool 2.1. change submitted.
        BOOL_OR, BOOL_AND, BOOL_EXOR, 
        BOOL_A_SUB_B, BOOL_B_SUB_A, 
        BOOL_CORRECTION, BOOL_SMOOTHEN, BOOL_MAKERING
    cdef enum kbEdgeType:
        KB_OUTSIDE_EDGE,
        KB_INSIDE_EDGE,
        KB_FALSE_EDGE
    cdef cppclass CBool_Engine 'Bool_Engine':
        CBool_Engine()
        std_string GetVersion()
        bool Do_Operation(Operation) except +KboolError
        void SetMarge(double)
        double GetMarge()
        void SetGrid(int)
        int GetGrid()
        void SetDGrid(double)
        double GetDGrid()
        void SetCorrectionAber(double)
        double GetCorrectionAber()
        void SetCorrectionFactor(double)
        double GetCorrectionFactor()
        void SetSmoothAber(double)
        double GetSmoothAber()
        void SetMaxlinemerge(double)
        double GetMaxlinemerge()
        void SetRoundfactor(double)
        double GetRoundfactor()
        void SetLinkHoles(bool)
        bool GetLinkHoles()
        void SetWindingRule(bool)
        bool GetWindingRule()
        void SetOrientationEntryMode(bool)
        bool GetOrientationEntryMode()
        void SetAllowNonTopHoleLinking(bool)
        bool GetAllowNonTopHoleLinking()
        bool StartPolygonAdd(GroupType)
        bool AddPoint(double, double) except +KboolError
        bool EndPolygonAdd() except +KboolError
        bool StartPolygonGet() except +KboolError
        int GetNumPointsInPolygon() except +KboolError
        bool PolygonHasMorePoints() except +KboolError
        double GetPolygonXPoint() except +KboolError
        double GetPolygonYPoint() except +KboolError
        void EndPolygonGet() except +KboolError
        void SetLog(bool)
        void Write_Log(std_string)
        double GetAccur()
        kbEdgeType GetPolygonPointEdgeType()

# Wrapping the enums
A = GROUP_A
B = GROUP_B

NON = BOOL_NON
AND = BOOL_AND
OR = BOOL_OR
XOR = BOOL_EXOR
A_SUB_B = BOOL_A_SUB_B
B_SUB_A = BOOL_B_SUB_A
CORRECTION = BOOL_CORRECTION
MAKERING = BOOL_MAKERING
SMOOTHEN = BOOL_SMOOTHEN

# Wrapping the C++ class and methods
cdef class Bool_Engine:
    cdef CBool_Engine *thisptr

    # Constructor, destructor
    def __cinit__(self): self.thisptr = new CBool_Engine()
    def __dealloc__(self): del self.thisptr

    property version:
        """kbool version"""
        def __get__(self): return self.thisptr.GetVersion().c_str().strip().decode()

    property marge:
        """The distance within which points and lines will be snapped towards lines and other points
           The algorithm takes into account gaps and inaccuracies caused by rounding to integer coordinates
           in the original data.
           Imagine two rectangles one with a side ( 0,0 ) ( 2.0, 17.0 ) 
           and the other has a side ( 0,0 ) ( 1.0, 8.5 )
           If for some reason those coordinates where round to ( 0,0 ) ( 2, 17 ) ( 0,0 ) ( 1, 9 ),
           there will be clearly a gap or overlap that was not intended.
           Even without rounding this effect takes place since there is always a minimum significant bit
           also when using doubles.

           If the user used as minimum accuracy 0.00001, you need to choose Marge > 0.00001
           The boolean engine scales up the input data with dgrid*grid and rounds the result to
           integer, So (assuming grid = 100 dgrid = 1000)  a vertex of 123.00001 in the user data will
           become 12300001 internal.
           At the end of the algorithm the internal vertexes are scaled down again with dgrid*grid,
           so 12300103 becomes 123.00103 eventually.
           So indeed the minimum accuracy might increase, you are free to round again if needed."""
        def __get__(self): return self.thisptr.GetMarge()
        def __set__(self, double p): self.thisptr.SetMarge(p)

    property grid:
        """grid makes sure that the integer data used within the algorithm has room for extra intersections
           smaller than the smallest number within the input data.
           The input data scaled up with dgrid is related to the accuracy the user has in his input data.
           Another scaling with grid is applied on top of it to create space in the integer number for 
           even smaller numbers."""
        def __get__(self): return self.thisptr.GetGrid()
        def __set__(self, long long p): self.thisptr.SetGrid(p)

    property dgrid:
        """The input data scaled up with dgrid is related to the accuracy the user has in his input data.
           User data with a minimum accuracy of 0.00001, means set the drid to 100000.
           The input data may contain data with a minimum accuracy much smaller, but by setting the dgrid
           everything smaller than 1/dgrid is rounded.

           dgrid is only meant to make fractional parts of input data which can be
           doubles, part of the integers used in vertexes within the boolean algorithm.
           And therefore dgrid bigger than 1 is not usefull, you would only loose accuracy.
           Within the algorithm all input data is multiplied with dgrid, and the result
           is rounded to an integer. """
        def __get__(self): return self.thisptr.GetDGrid()
        def __set__(self, double p): self.thisptr.SetDGrid(p)

    property correction_aber:
        def __get__(self): return self.thisptr.GetCorrectionAber()
        def __set__(self, double p): self.thisptr.SetCorrectionAber(p)

    property correction_factor:
        """The correction algorithm can apply positive and negative offset to polygons.
           It takes into account closed in areas within a polygon, caused by overlapping/selfintersecting
           polygons. So holes form that way are corrected proberly, but the overlapping parts itself
           are left alone. An often used trick to present polygons with holes by linking to the outside
           boundary, is therefore also handled properly.
           The algoritm first does a boolean OR operation on the polygon, and seperates holes and
           outside contours.
           After this it creates a ring shapes on the above holes and outside contours.
           This ring shape is added or subtracted from the holes and outside contours.
           The result is the corrected polygon.
           If the correction factor is > 0, the outside contours will become larger, while the hole contours
           will become smaller."""
        def __get__(self): return self.thisptr.GetCorrectionFactor()
        def __set__(self, double p): self.thisptr.SetCorrectionFactor(p)

    property smooth_aber:
        def __get__(self): return self.thisptr.GetSmoothAber()
        def __set__(self, double p): self.thisptr.SetSmoothAber(p)

    property maxline_merge:
        def __get__(self): return self.thisptr.GetMaxlinemerge()
        def __set__(self, double p): self.thisptr.SetMaxlinemerge(p)

    property round_factor:
        def __get__(self): return self.thisptr.GetRoundfactor()
        def __set__(self, double p): self.thisptr.SetRoundfactor(p)


    property link_holes:
        """if set to True, holes are linked into outer contours by double overlapping segments.
          This mode is needed when the software using the boolean algorithm does 
          not understand hole polygons. In that case a contour and its holes form one
          polygon. In cases where software understands the concept of holes, contours
          are clockwise oriented, while holes are anticlockwise oriented.
          The output of the boolean operations, is following those rules also.
          But even if extracting the polygons from the engine, each segment is marked such
          that holes and non holes and linksegments to holes can be recognized."""
        def __get__(self): return self.thisptr.GetLinkHoles()
        def __set__(self, bool p): self.thisptr.SetLinkHoles(p)

    property orientation_entry_mode:
        """- if orientationEntryMode is set True, holes are added by adding an inside polygons 
            with opposite orientation compared to another polygon added. So the contour polygon 
            ClockWise, then add counterclockwise polygons for holes, and visa versa.
          - if orientationEntryMode is set to False,  all polygons are redirected, and become 
            individual areas without holes. """
        def __get__(self): return self.thisptr.GetOrientationEntryMode()
        def __set__(self, bool p): self.thisptr.SetOrientationEntryMode(p)

    property allow_non_top_hole_linking:
        """when set to True, not only the top vertex of a hole is linked to the other holes and contours,
            but also vertex  other vertexes close to a hole can be used."""
        def __get__(self): return self.thisptr.GetAllowNonTopHoleLinking()
        def __set__(self, p): self.thisptr.SetAllowNonTopHoleLinking(p)

    property winding_rule:
        """Polygon may be filled in different ways (alternate and winding rule).
           Set to True to use the winding rule"""
        def __get__(self): return self.thisptr.GetWindingRule()
        def __set__(self, p): self.thisptr.SetWindingRule(p)         

    property accur:
        """the smallest accuracy used within the algorithm for comparing two real numbers."""
        def __get__(self): return self.thisptr.GetAccur()


    def config(self, **kvargs):
        """Shortcut to set property attributes using kvargs"""
        for k, v in kvargs.items():
            setattr(self, k, v)
        return self

    # Polygon setting
    def start_polygon_add(self, GroupType A_or_B ):
        """The boolean operation work on two groups of polygons ( group A or B ),
           other algorithms are only using group A.

           You add polygons like this to the engine.

           # foreach point in a polygon ...
           if (booleng.StartPolygonAdd(GROUP_A)):
               booleng.AddPoint(100,100)
               booleng.AddPoint(-100,100) 
               booleng.AddPoint(-100,-100)
               booleng.AddPoint(100,-100) 
           booleng.EndPolygonAdd() 

           param A_or_B defines if the new polygon will be of group A or B

           Holes or added by adding an inside polygons with opposite orientation compared
           to another polygon added.
           So the contour polygon ClockWise, then add counterclockwise polygons for holes, and visa versa.
           BUT only if orientation_entry_mode is set true, else all polygons are redirected, and become
           individual areas without holes. 
           Holes in such a case must be linked into the contour using two extra segments."""
        return self.thisptr.StartPolygonAdd(A_or_B)

    def add_point(self, double x, double y ): return self.thisptr.AddPoint(x, y)
    def end_polygon_add(self,): return self.thisptr.EndPolygonAdd()

    # Polygon getting
    def start_polygon_get(self):
      """This iterates through the first graph in the graphlist.
         Setting the current kbNode properly by following the links in the graph
         through its nodes. """
      return self.thisptr.StartPolygonGet()
    def get_num_points_in_polygon(self): return self.thisptr.GetNumPointsInPolygon()
    def polygon_has_more_points(self): return self.thisptr.PolygonHasMorePoints()
    def get_polygon_x_point(self): return self.thisptr.GetPolygonXPoint()
    def get_polygon_y_point(self): return self.thisptr.GetPolygonYPoint()
    def end_polygon_get(self):
      """Removes a graph from the graphlist.
         Called after an extraction of an output polygon was done."""
      self.thisptr.EndPolygonGet()
  
    # Do the job
    def perform(self, Operation op): return self.thisptr.Do_Operation(op)

    # logging
    def set_log(self, p):
        """boolean setter property for kbool logging"""
        self.thisptr.SetLog(p)

    def write_log(self, text):
        bytes_ = text.encode()
        self.thisptr.Write_Log(std_string(bytes_))

    def get_polygon_point_edge_type(self): return self.thisptr.GetPolygonPointEdgeType()

    def set_polygon(self, list polygon, int A_or_B = GROUP_A):
      """provides a closed polygonal chain to either group A or group B. Default is Group A."""
      self.start_polygon_add(A_or_B)
      for x, y in polygon:
        self.add_point(x, y)
      self.end_polygon_add()
     
    def get_result(self):
      """Retrieves the boolan operation resulting polygonal chain"""
      poly = []
      while self.start_polygon_get():
        while self.polygon_has_more_points():
          poly.append((self.get_polygon_x_point(), self.get_polygon_y_point()))
        self.end_polygon_get()
      return poly

    def connect(self, list keyhole_polygon):
        """Link holes into contour.
           keyhole_polygon is a list of polygons, whereas the first one is the contour.
           Uses A - B operation."""
        connected_polygon = []
        self.thisptr.StartPolygonAdd(GROUP_A)
        for x, y in keyhole_polygon[0]:
            self.thisptr.AddPoint(x, y)    
        self.thisptr.AddPoint(keyhole_polygon[0][0][0], keyhole_polygon[0][0][1])
        self.thisptr.EndPolygonAdd()
        self.thisptr.StartPolygonAdd(GROUP_B)
        for hole in keyhole_polygon[1:]:
            for x, y in hole:
                self.thisptr.AddPoint(x, y)
            self.thisptr.AddPoint(hole[0][0], hole[0][1])
        self.thisptr.EndPolygonAdd()
        self.thisptr.Do_Operation(BOOL_A_SUB_B)
        if self.thisptr.StartPolygonGet():
          while self.thisptr.PolygonHasMorePoints():
            connected_polygon.append((self.thisptr.GetPolygonXPoint(), self.thisptr.GetPolygonYPoint()))
          self.thisptr.EndPolygonGet()
        return connected_polygon

# lambda to close a polygon... Suboptimal because of list duplication....
close = lambda p: p if p[0] == p[-1] else p + [p[0]]

def _test():
    e=Bool_Engine()
    e.marge=0.001
    assert(e.marge == 0.001)
    e.dgrid=1000
    assert(e.dgrid == 1000)
    e.correction_factor=500.0
    assert(e.correction_factor == 500.0)
    e.correction_aber=1.0
    assert(e.correction_aber == 1.0)
    e.round_factor=1.5
    assert(e.round_factor == 1.5)
    e.smooth_aber=10.0
    assert(e.smooth_aber == 10.0)    
    e.maxline_merge=1000.0
    assert(e.maxline_merge == 1000.0)    
    e.grid = 10000
    assert(e.grid == 10000)

    def dothis(what):
        assert(e.start_polygon_add(GROUP_A))
        assert(e.add_point(100, 100) and e.add_point(-100, 100) and e.add_point(-100, -100) and e.add_point(100, -100) and e.add_point(100, 100))
        assert(e.end_polygon_add())
        assert(e.start_polygon_add(GROUP_B))
        assert(e.add_point(50, 50) and e.add_point(-50, 50) and e.add_point(-50, -50) and e.add_point(50, -50) and e.add_point(50, 50))
        assert(e.end_polygon_add())
        assert(e.perform(what))
        assert(e.start_polygon_get())
        while e.polygon_has_more_points():
          (e.get_polygon_x_point(), e.get_polygon_y_point())
        e.end_polygon_get() # void C++ method....

    e.set_log(True)
    #dothis(BOOL_NON)
    dothis(BOOL_OR)
    dothis(BOOL_AND)
    dothis(BOOL_EXOR)
    dothis(BOOL_A_SUB_B)
    #dothis(BOOL_B_SUB_A)
    dothis(BOOL_CORRECTION)
    #dothis(BOOL_SMOOTHEN)
    dothis(BOOL_MAKERING)
    print ('Tests done')