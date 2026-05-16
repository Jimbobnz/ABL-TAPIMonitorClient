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

USING Progress.Json.ObjectModel.JsonConstruct.     
USING Progress.Json.ObjectModel.ObjectModelParser.     
USING Progress.Json.ObjectModel.JsonObject.

CREATE WIDGET-POOL.


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

define input parameter hnPartentProcudure as handle no-undo. 

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE hClientSocket AS Handle        NO-UNDO.
DEFINE VARIABLE lConnected    AS LOGICAL       NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS edEventLog 
&Scoped-Define DISPLAYED-OBJECTS edEventLog 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE edEventLog AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE NO-BOX
     SIZE 168 BY 26.91
     BGCOLOR 7 FGCOLOR 10 FONT 0 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     edEventLog AT ROW 1.48 COL 3 NO-LABEL WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 171.8 BY 28.1 WIDGET-ID 100.


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
         TITLE              = "TAPI Event Handler"
         HEIGHT             = 28.1
         WIDTH              = 171.8
         MAX-HEIGHT         = 28.1
         MAX-WIDTH          = 171.8
         VIRTUAL-HEIGHT     = 28.1
         VIRTUAL-WIDTH      = 171.8
         SHOW-IN-TASKBAR    = no
         CONTROL-BOX        = no
         MIN-BUTTON         = no
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
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
       edEventLog:RETURN-INSERTED IN FRAME DEFAULT-FRAME  = TRUE
       edEventLog:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _Query            is NOT OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* TAPI Event Handler */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE 
    DO:
        /* This case occurs when the user presses the "Esc" key.
           In a persistently run window, just ignore this.  If we did not, the
           application would exit. */
        IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON PARENT-WINDOW-CLOSE OF C-Win /* TAPI Event Handler */
DO:
      IF hClientSocket:CONNECTED() THEN
        hClientSocket:DISCONNECT().
        
    DELETE OBJECT hClientSocket.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* TAPI Event Handler */
DO:
        /* This event will close the window and terminate the procedure.  */
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN NO-APPLY.
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
  
    Run InitialiseSocketConnection. 
  
/*     IF NOT THIS-PROCEDURE:PERSISTENT THEN */
/*         WAIT-FOR CLOSE OF THIS-PROCEDURE. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CloseTAPIHandler C-Win 
PROCEDURE CloseTAPIHandler :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF hClientSocket:CONNECTED() THEN
        hClientSocket:DISCONNECT().
        
    DELETE OBJECT hClientSocket.

    APPLY "Close" TO THIS-PROCEDURE. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  DISPLAY edEventLog 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE edEventLog 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitialiseSocketConnection C-Win 
PROCEDURE InitialiseSocketConnection PRIVATE :
/*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    CREATE SOCKET hClientSocket.
    
    /* 2. Attempt connection to the server (Host can be an IP or hostname) */
    lConnected = hClientSocket:CONNECT("-H localhost -S 1471") NO-ERROR.
    
    if NOT lConnected then 
        RETURN.
        
    hClientSocket:SET-READ-RESPONSE-PROCEDURE( "ReadResponse"  , this-procedure).
    //hClientSocket:SET-READ-RESPONSE-PROCEDURE( "ReadResponse").    

    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OnIncomingCallEvent C-Win 
PROCEDURE OnIncomingCallEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
      /* {"Type":"OnIncomingCall",
        "Timestamp":"2026-05-16T13:23:59.182319\u002B12:00",
        "Data":{"CallID":9877099,
                "CallerNumber":"2102155338",
                "CallerName":"Unknown Caller",
                "CalledNumber":"02825508013",
                "CalledName":"Main Line",
                "StartTime":"2026-05-16T13:23:59"}
                }
         }*/
  
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER objJSONData AS CLASS JsonObject NO-UNDO.
    
    IF NOT VALID-OBJECT(objJSONData) THEN
        RETURN.
        
    IF objJSONData:has("CallerNumber") THEN
        RUN IncomingCallCallerIDNumber IN hnPartentProcudure (INPUT objJSONData:GetCharacter("CallerNumber")).
    
    RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReadJSONResponse C-Win 
PROCEDURE ReadJSONResponse PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pchJSONResponse AS CHARACTER  NO-UNDO.
    
    DEFINE VARIABLE objJSONObject AS CLASS JsonObject   NO-UNDO.
    
    
    DEFINE VARIABLE objParser AS CLASS ObjectModelParser NO-UNDO.
    DEFINE VARIABLE objConstruct AS CLASS JsonConstruct NO-UNDO.

    objParser = NEW ObjectModelParser( ).
    objJSONObject = NEW JsonObject().
    
    /* 3. Parse the string into a JsonObject */
    objJSONObject = CAST(objParser:Parse(pchJSONResponse), JsonObject).
    
    IF NOT VALID-OBJECT(objJSONObject) THEN
        RETURN.
        
    IF objJSONObject:has("Type") THEN
    DO:
       STATUS DEFAULT objJSONObject:GetCharacter("Type").
       
       CASE objJSONObject:GetCharacter("Type"):
            WHEN "OnIncomingCall" THEN
                RUN OnIncomingCallEvent (INPUT objJSONObject:GetJsonObject( "Data") ).
       END CASE.
       
    END.
    

    
    
    
    
    
    RETURN.
    
    FINALLY:
    
        DELETE OBJECT objParser.
        DELETE OBJECT objJSONObject.
    
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReadResponse C-Win 
PROCEDURE ReadResponse :
/*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE inByteAvailable AS INTEGER   NO-UNDO.
    DEFINE VARIABLE mReadBuffer     AS MEMPTR    NO-UNDO.
    DEFINE VARIABLE cResponse       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cResponseSpilt  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iChunkEntrie    AS INTEGER     NO-UNDO.
    
    inByteAvailable = hClientSocket:GET-BYTES-AVAILABLE( ).
    
    if inByteAvailable eq 0 or inByteAvailable eq ? then
        return.
        
    /* Allocate memory to match the exact size of the incoming stream */
    SET-SIZE(mReadBuffer) = 0.  // <-- All way do this. 
    SET-SIZE(mReadBuffer) = inByteAvailable.
        
    /* Pull the raw binary packet into our MEMPTR buffer */
    hClientSocket:READ(mReadBuffer, 1, inByteAvailable, 2).
        
    /* Cast the binary data to an ABL readable string */
    cResponse = GET-STRING(mReadBuffer, 1).
        
    /* Output the server's raw response */
    do with frame {&Frame-name}:
        edEventLog:MOVE-TO-EOF( ).
        edEventLog:INSERT-STRING (cResponse).
    end.
        
    //If there is a queue of messages bunched up, split them out to indiviual JSON chunks.
    DO iChunkEntrie = 1 TO NUM-ENTRIES(cResponse, '~r'):
    
        cResponseSpilt = ENTRY(iChunkEntrie, cResponse, '~r' ).        
        
        IF LENGTH(cResponseSpilt) GT 0 THEN
            RUN ReadJSONResponse (INPUT cResponseSpilt).
    
    END.
    
    Return.
    
    Finally:
        
        /* Clean up the dynamic read buffer allocation */
        SET-SIZE(mReadBuffer) = 0. 
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TAPIEventWindowHidden C-Win 
PROCEDURE TAPIEventWindowHidden :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER lgHidden AS LOGICAL NO-UNDO. 
    
    C-WIN:HIDDEN = lgHidden.
    
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

