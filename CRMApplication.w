&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

USING System.Windows.Forms.* FROM ASSEMBLY.
USING System.Drawing.*       FROM ASSEMBLY.

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE VARIABLE hnTAPIEventHandler AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 fiCallerIDNumber slCallers bntClose ~
tbShowTAPIEventLog 
&Scoped-Define DISPLAYED-OBJECTS fiCallerIDNumber slCallers ~
tbShowTAPIEventLog 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bntClose 
     LABEL "Close" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE fiCallerIDNumber AS CHARACTER FORMAT "X(256)":U 
     LABEL "Caller ID Number" 
     VIEW-AS FILL-IN 
     SIZE 33 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 9.76.

DEFINE VARIABLE slCallers AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 64 BY 7.38
     FONT 0 NO-UNDO.

DEFINE VARIABLE tbShowTAPIEventLog AS LOGICAL INITIAL no 
     LABEL "Hide TAPI Event Log" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     fiCallerIDNumber AT ROW 2.19 COL 24 COLON-ALIGNED WIDGET-ID 6 NO-TAB-STOP 
     slCallers AT ROW 3.38 COL 8 NO-LABEL WIDGET-ID 10
     bntClose AT ROW 11.71 COL 60 WIDGET-ID 4
     tbShowTAPIEventLog AT ROW 11.95 COL 4 WIDGET-ID 2
     " Incoming Call Events" VIEW-AS TEXT
          SIZE 21 BY .95 AT ROW 1.24 COL 7 WIDGET-ID 14
     RECT-1 AT ROW 1.71 COL 4 WIDGET-ID 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 78.2 BY 12.14 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Mock CRM Application"
         HEIGHT             = 12.1
         WIDTH              = 78.2
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 135.4
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 135.4
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
ASSIGN 
       fiCallerIDNumber:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Mock CRM Application */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Mock CRM Application */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bntClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bntClose C-Win
ON CHOOSE OF bntClose IN FRAME DEFAULT-FRAME /* Close */
DO:
  
  
/*   IF VALID-HANDLE(hnTAPIEventHandler) THEN      */
/*     RUN CloseTAPIHandler IN hnTAPIEventHandler. */
  
  APPLY "Close" TO THIS-PROCEDURE. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tbShowTAPIEventLog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tbShowTAPIEventLog C-Win
ON VALUE-CHANGED OF tbShowTAPIEventLog IN FRAME DEFAULT-FRAME /* Hide TAPI Event Log */
DO:
  
    RUN TAPIEventWindowHidden IN hnTAPIEventHandler (INPUT SELF:CHECKED).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
       
    RUN enable_UI.
    
    RUN TAPIEventHandler.w persistent SET hnTAPIEventHandler (INPUT THIS-PROCEDURE).
  
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY fiCallerIDNumber slCallers tbShowTAPIEventLog 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-1 fiCallerIDNumber slCallers bntClose tbShowTAPIEventLog 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE IncomingCallCallerIDNumber C-Win 
PROCEDURE IncomingCallCallerIDNumber :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER cCallerIDNumber  AS CHARACTER     NO-UNDO.
    
    DO WITH FRAME {&FRAME-NAME}:
    
        fiCallerIDNumber:SCREEN-VALUE = cCallerIDNumber.
    
        RUN ShowNotification.
        
        slCallers:ADD-FIRST( SUBSTITUTE("&1 --> &2", STRING(TIME, "HH:MM:SS"), cCallerIDNumber)  ).
    
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ShowNotification C-Win 
PROCEDURE ShowNotification :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        DEFINE VARIABLE notify AS NotifyIcon NO-UNDO.
        
        DO WITH FRAME {&FRAME-NAME}:
        
        
        
        
        /* 1. Create and configure the NotifyIcon object */
        notify = NEW NotifyIcon().
        notify:Icon = SystemIcons:Information.
        notify:Visible = TRUE.
        
        /* 2. Set up the balloon tip properties */
        notify:BalloonTipTitle = C-WIN:TITLE.
        notify:TEXT = C-WIN:TITLE.
        notify:BalloonTipText  = "Incoming Call: " + fiCallerIDNumber:SCREEN-VALUE.
        notify:BalloonTipIcon  = ToolTipIcon:Info.
        
        /* 3. Display the balloon tip (timeout parameter is 5000ms) */
        notify:ShowBalloonTip(5000).
        
        /* 4. Pause execution to let the balloon display before cleaning up */
        PAUSE (.5).
        
        /* 5. Clean up the object to remove it from the system tray */
        notify:Dispose().
        END.
        
        CATCH e AS Progress.Lang.Error:
            MESSAGE "An error occurred: " e:GetMessage(1) VIEW-AS ALERT-BOX ERROR.
        END CATCH.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

