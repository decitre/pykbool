# remove debug key files and add BOOL_NON support
(cd kbool/src && patch << EOF
--- booleng.cpp	2009-09-14 18:50:12.000000000 +0200
+++ booleng.cpp	2011-02-20 16:58:51.124226814 +0100
@@ -335,6 +335,8 @@ bool Bool_Engine::Do_Operation( BOOL_OP 
             case ( BOOL_SMOOTHEN ):
                             m_graphlist->Smoothen( GetInternalSmoothAber() );
                 break;
+            case (BOOL_NON ): // http://sourceforge.net/tracker/index.php?func=detail&aid=3174463&group_id=58919&atid=489289
+                break;
             default:
     {
                 error( "Wrong operation", "Command Error" );
--- graph.cpp	2009-09-14 18:50:12.000000000 +0200
+++ graph.cpp	2011-02-20 17:00:22.724804775 +0100
@@ -2476,6 +2476,7 @@ bool kbGraph::checksort()
 
 void kbGraph::WriteKEY( Bool_Engine* GC, FILE* file )
 {
+#if KBOOL_DEBUG // http://sourceforge.net/mailarchive/message.php?msg_id=27090327
     double scale = 1.0 / GC->GetGrid() / GC->GetGrid();
 
     bool ownfile = false;
@@ -2553,14 +2554,14 @@ void kbGraph::WriteKEY( Bool_Engine* GC,
         fclose (file);
 
     }
+#endif
 }
 
 
 void kbGraph::WriteGraphKEY(Bool_Engine* GC)
 {
-
+#if KBOOL_DEBUG // http://sourceforge.net/mailarchive/message.php?msg_id=27090327
     double scale = 1.0/GC->GetGrid()/GC->GetGrid();
-
     FILE* file = fopen("keygraphfile.key", "w");
 
     fprintf(file,"\
@@ -2618,6 +2619,7 @@ void kbGraph::WriteGraphKEY(Bool_Engine*
             ");
 
     fclose (file);
+#endif
 }
 
 
EOF
)
