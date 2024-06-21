//-----------------------------------------------------------------------------
// Ejemplo mantenimiento dbf
// By Lailton
//-----------------------------------------------------------------------------

procedure main

    local hGet

    set deleted on
    set epoch to 1990
    ap_setCgiVar()

    html_Init()

    use( ap_getEnv( "DOCUMENT_ROOT" ) + "/hb/dbtest/data/test.dbf" ) new alias "test" via "DBFCDX"

    toolBar()

    // Controlador frontal
    hGet := ap_readGet()

    switch if( hb_hHasKey( hGet, "action" ), hGet[ "action" ], "view" )
    case "add" 
        addForm(); exit
    case "save"
        saveForm(); exit
    case "update"
        updateForm(); exit
    case "delete"
        deleteForm( val( hGet[ "id" ] ) ); exit
    case "edit"
        editForm( val( hGet[ "id" ] ) ); exit
    otherwise 
        listAll()
    endswitch

    html_exit()

return

//-----------------------------------------------------------------------------

procedure listAll

    local n, nLen, cRec
    local aStruct := test->( dbStruct() )

    console( "<div class='table-responsive'><table class='table table-vcenter card-table'>" )
    console( "<thead>" )
    console( "<tr>" )

    nLen := len( aStruct )
    for n := 1 to nLen
        console( "<th>" + aStruct[ n, 1 ] + "</th>" )
    next

    console( "<th></th>" )
    console( "</tr>" )
    console( "</thead>" )
    console( "<tbody>" )

    test->( dbGoTop() )

    if test->( recCount() ) == 0
        console( "<tr><td colspan=" + hb_ntos( len( aStruct ) ) + ">No Register Available</td></tr>" )
    else
        while test->( !eof() )
            console( "<tr>" )  

            for n := 1 to nLen
                console( "<td>" )
                console( test->&( aStruct[ n, 1 ] ) )
                console( "</td>" )
            next

            cRec := hb_ntos( test->( recno() ) )
            console( "<td><a href='?action=edit&id=" + cRec + "'>Edit</a> | <a href='?action=delete&id=" + cRec + "'>Delete</a></td>" )
            console( "</tr>" )

            test->( dbSkip() )
        enddo
    endif

    console( "</tbody>" )
    console( "</table>" )

return 

//-----------------------------------------------------------------------------

procedure toolBar

    console( "WA: " + hb_ntoc( Select()) + "   Alias: " + alias() ) 
    console( "<hr>" )
    console( "<a href=?action=view>Index</a> | <a href=?action=add>Add</a>" )
    console( "<hr>" )

return 

//-----------------------------------------------------------------------------

procedure addForm

    local cHTML := ""

    text into cHTML
    <div class="col-md-6">
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">Form Test</h3>
        </div>
        <div class="card-body">
          <form method=post action="?action=save">
            <div class="form-group mb-3 row">
              <label class="form-label col-3 col-form-label">First Name</label>
              <div class="col">
                <input type="text" name="first" class="form-control" aria-describedby="FirstName" placeholder="First Name">
                <small class="form-hint">Enter your first name</small>
              </div>
            </div>
            <div class="form-group mb-3 row">
              <label class="form-label col-3 col-form-label">Last Name</label>
              <div class="col">
                <input type="text" name="last" class="form-control" aria-describedby="LastName" placeholder="Last Name">
                <small class="form-hint">Enter your last name</small>
              </div>
            </div>
            <div class="form-group mb-3 row">
              <label class="form-label col-3 col-form-label">Street</label>
              <div class="col">
                <input type="text" name="street" class="form-control" aria-describedby="Street" placeholder="Street">
              </div>
            </div>
            <div class="form-group mb-3 row">
              <label class="form-label col-3 col-form-label">City</label>
              <div class="col">
                <input type="text" name="city" class="form-control" aria-describedby="City" placeholder="City">
              </div>
            </div>
            <div class="form-group mb-3 row">
              <label class="form-label col-3 col-form-label">State</label>
              <div class="col">
                <select name="state" class="form-select">
                  <option>IL</option>
                  <option>MA</option>
                  <option>WY</option>
                  <option>SD</option>
                  <option>ID</option>
                </select>
              </div>
            </div>
            <div class="form-group mb-3 row">
              <label class="form-label col-3 col-form-label">ZIP</label>
              <div class="col">
                <input type="text" name="zip" class="form-control" aria-describedby="ZIP" placeholder="ZIP">
              </div>
            </div>
            <div class="form-group mb-3 row">
              <label class="form-label col-3 col-form-label">Hire Date</label>
              <div class="col">
                <input type="text" name="hiredate" class="form-control" aria-describedby="Hire Date" maxlength=10 placeholder="YYYY-MM-DD">
              </div>
            </div>
            <div class="form-group mb-3 row">
              <label class="form-label col-3 col-form-label pt-0">Married</label>
              <div class="col">
                <label class="form-check">
                  <input class="form-check-input" type="checkbox" checked="" name="married">
                </label>
              </div>
            </div>
            <div class="form-group mb-3 row">
              <label class="form-label col-3 col-form-label">Age</label>
              <div class="col">
                <input type="number" name="age" class="form-control" aria-describedby="Age" placeholder="Age">
              </div>
            </div>
            <div class="form-group mb-3 row">
              <label class="form-label col-3 col-form-label">Salary</label>
              <div class="col">
                <input type="number" name="salary" class="form-control" aria-describedby="Salary" placeholder="Salary">
              </div>
            </div>

            <div class="form-group mb-3 row">
              <label class="form-label col-3 col-form-label">Notes</label>
              <div class="col">
                <textarea class="form-control" name="notes" rows="6" placeholder="Notes.."></textarea>
              </div>
            </div>
            <div class="form-footer">
              <button type="submit" class="btn btn-primary">Save</button>
            </div>
          </form>
        </div>
      </div>
    </div>
    endtext

    console( cHTML )

return 

//-----------------------------------------------------------------------------

static procedure postToRec( hPost )

    test->first := hPost[ "first" ]
    test->last := hPost[ "last" ]
    test->street := hPost[ "street" ]
    test->city := hPost[ "city" ]
    test->state := hPost[ "state" ]
    test->zip := hPost[ "zip" ]
    test->hiredate := hb_ctod( hPost[ "hiredate" ], "YYYY-MM-DD" )
    test->married := ( hb_hHasKey( hPost, "married" ) .and. hPost[ "married" ] == "on" )
    test->age := val( hPost[ "age" ] )
    test->salary := val( hPost[ "salary" ] )
    test->notes := hPost[ "notes" ]

return

//-----------------------------------------------------------------------------

procedure saveForm
  
    if ap_getMethod() == "POST" 
        if test->( dbAppend( .t. ) )
            postToRec( ap_readPost() )
            test->( dbRUnlock() )
            console( "<script>location.href='?action=view';</script>" )
        else
            console( "Failed to save" )
        endif
    else
        addForm()
    endif

return 

//-----------------------------------------------------------------------------

procedure updateForm

    local nId, hPost 
  
    if ap_getMethod() == "POST"
        hPost := ap_readPost()
        nId := val( hPost[ "id" ] )

        test->( dbGoto( nId ) )
        if test->( recno() ) == nId .and. test->( dbRLock() )
            postToRec( hPost )
            test->( dbRUnlock() )
            console( "<script>location.href='?action=view';</script>" )
        else
            console( "Failed to update" )
        endif
    else
        console( "<script>location.href='?action=view';</script>" )
    endif

return 

//-----------------------------------------------------------------------------

procedure deleteForm( nId )

    local lDeleted := .f.

    test->( dbGoto( nId ) )
    if test->( recno() ) == nId
        if test->( dbRLock() )
            test->( dbDelete() )
            test->( dbRUnlock() )
            lDeleted := test->( deleted() )
        endif
    endif

    console( if( lDeleted, "Record deleted!", "Failed to delete the record" ) )

return 

//-----------------------------------------------------------------------------

procedure editForm( nId )

    local lEdit := .f.
    local cHTML := ""

    test->( dbGoto( nId ) )
    lEdit := ( test->( recno() ) == nId .and. test->( !deleted() ) )

    if lEdit
        text into cHTML
        <div class="col-md-6">
          <div class="card">
            <div class="card-header">
              <h3 class="card-title">Form Edit</h3>
            </div>
            <div class="card-body">
              <form method=post action="?action=update">
                <input type=hidden name=id value="{{id}}">
                <div class="form-group mb-3 row">
                  <label class="form-label col-3 col-form-label">First Name</label>
                  <div class="col">
                    <input type="text" name="first" value="{{first}}" class="form-control" aria-describedby="FirstName" placeholder="First Name">
                    <small class="form-hint">Enter your first name</small>
                  </div>
                </div>
                <div class="form-group mb-3 row">
                  <label class="form-label col-3 col-form-label">Last Name</label>
                  <div class="col">
                    <input type="text" name="last" value="{{last}}" class="form-control" aria-describedby="LastName" placeholder="Last Name">
                    <small class="form-hint">Enter your last name</small>
                  </div>
                </div>
                <div class="form-group mb-3 row">
                  <label class="form-label col-3 col-form-label">Street</label>
                  <div class="col">
                    <input type="text" name="street" value="{{street}}" class="form-control" aria-describedby="Street" placeholder="Street">
                  </div>
                </div>
                <div class="form-group mb-3 row">
                  <label class="form-label col-3 col-form-label">City</label>
                  <div class="col">
                    <input type="text" name="city" value="{{city}}" class="form-control" aria-describedby="City" placeholder="City">
                  </div>
                </div>
                <div class="form-group mb-3 row">
                  <label class="form-label col-3 col-form-label">State</label>
                  <div class="col">
                    <select name="state" class="form-select" value="{{state}}">
                      <option>IL</option>
                      <option>MA</option>
                      <option>WY</option>
                      <option>SD</option>
                      <option>ID</option>
                    </select>
                  </div>
                </div>
                <div class="form-group mb-3 row">
                  <label class="form-label col-3 col-form-label">ZIP</label>
                  <div class="col">
                    <input type="text" name="zip" value="{{zip}}" class="form-control" aria-describedby="ZIP" placeholder="ZIP">
                  </div>
                </div>
                <div class="form-group mb-3 row">
                  <label class="form-label col-3 col-form-label">Hire Date</label>
                  <div class="col">
                    <input type="text" name="hiredate" value="{{hiredate}}" class="form-control" aria-describedby="Hire Date" maxlength=10 placeholder="YYYY-MM-DD">
                  </div>
                </div>
                <div class="form-group mb-3 row">
                  <label class="form-label col-3 col-form-label pt-0">Married</label>
                  <div class="col">
                    <label class="form-check">
                      <input class="form-check-input" type="checkbox" checked="{{married}}" name="married">
                    </label>
                  </div>
                </div>
                <div class="form-group mb-3 row">
                  <label class="form-label col-3 col-form-label">Age</label>
                  <div class="col">
                    <input type="number" name="age" value="{{age}}" class="form-control" aria-describedby="Age" placeholder="Age">
                  </div>
                </div>
                <div class="form-group mb-3 row">
                  <label class="form-label col-3 col-form-label">Salary</label>
                  <div class="col">
                    <input type="number" name="salary" value="{{salary}}" class="form-control" aria-describedby="Salary" placeholder="Salary">
                  </div>
                </div>

                <div class="form-group mb-3 row">
                  <label class="form-label col-3 col-form-label">Notes</label>
                  <div class="col">
                    <textarea class="form-control" name="notes" rows="6" placeholder="Notes..">{{notes}}</textarea>
                  </div>
                </div>
                <div class="form-footer">
                  <button type="submit" class="btn btn-primary">Update</button>
                </div>
              </form>
            </div>
          </div>
        </div>
        endtext

        cHTML := strtran( cHTML, "{{id}}", hb_ntos( test->( recno() ) ) )
        cHTML := strtran( cHTML, "{{first}}", alltrim( test->first ) )
        cHTML := strtran( cHTML, "{{last}}", alltrim( test->last ) )
        cHTML := strtran( cHTML, "{{street}}", alltrim( test->street ) )
        cHTML := strtran( cHTML, "{{city}}", alltrim( test->city ) )
        cHTML := strtran( cHTML, "{{state}}", alltrim( test->state ) )
        cHTML := strtran( cHTML, "{{zip}}", alltrim( test->zip ) )
        cHTML := strtran( cHTML, "{{hiredate}}", hb_dtoc( test->hiredate, "YYYY-MM-DD" ) )
        cHTML := strtran( cHTML, "{{married}}", if( test->married, "checked", "" ) )
        cHTML := strtran( cHTML, "{{age}}", hb_ntos( test->age )) 
        cHTML := strtran( cHTML, "{{salary}}", hb_ntos( test->salary )) 
        cHTML := strtran( cHTML, "{{notes}}", alltrim( test->notes ) )

        console( cHTML )
    else
        console( "Fail to open record or it was deleted" )
    endif

return 

//-----------------------------------------------------------------------------

procedure html_Init

    local cHTML := ""

    text into cHTML
        <!doctype html>
        <html lang="en">
        <head>
            <meta charset="utf-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover"/>
            <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
            <title>Harbour</title>
            <link href="./dist/css/tabler.min.css" rel="stylesheet"/>
        </head>
        <body style="padding:20px;">
    endtext

    console( cHTML )

return 

//-----------------------------------------------------------------------------

procedure html_exit

    console( "</body></html>" )

return 

//-----------------------------------------------------------------------------

procedure console( ... )

    local aParams := hb_aParams()
    local nParam, nLen
    
    nLen := len( aParams )
    for nParam := 1 to nLen
        ap_rwrite( aParams[ nParam ] )
    next

return 

//-----------------------------------------------------------------------------
