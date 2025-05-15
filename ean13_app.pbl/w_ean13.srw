forward
global type w_ean13 from window
end type
type cb_1 from commandbutton within w_ean13
end type
type st_platform from statictext within w_ean13
end type
type st_myversion from statictext within w_ean13
end type
type st_ean13_reader from statictext within w_ean13
end type
type p_ean13_reader from picture within w_ean13
end type
type st_ean13_generator from statictext within w_ean13
end type
type st_copyright from statictext within w_ean13
end type
type p_rsrsystem from picture within w_ean13
end type
type p_ean13_generator from picture within w_ean13
end type
type dw_1 from datawindow within w_ean13
end type
type st_data from statictext within w_ean13
end type
type sle_data from singlelineedit within w_ean13
end type
type r_1 from rectangle within w_ean13
end type
type p_ean13code from picture within w_ean13
end type
end forward

global type w_ean13 from window
integer width = 3378
integer height = 1868
boolean titlebar = true
string title = "Ean13 App"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
st_platform st_platform
st_myversion st_myversion
st_ean13_reader st_ean13_reader
p_ean13_reader p_ean13_reader
st_ean13_generator st_ean13_generator
st_copyright st_copyright
p_rsrsystem p_rsrsystem
p_ean13_generator p_ean13_generator
dw_1 dw_1
st_data st_data
sle_data sle_data
r_1 r_1
p_ean13code p_ean13code
end type
global w_ean13 w_ean13

type variables
nvo_barcode io_ean13
end variables

forward prototypes
public subroutine wf_version (statictext ast_version, statictext ast_patform)
public function long wf_retrieve (datawindow adw)
end prototypes

public subroutine wf_version (statictext ast_version, statictext ast_patform);String ls_version, ls_platform
environment env
integer rtn

rtn = GetEnvironment(env)

IF rtn <> 1 THEN 
	ls_version = string(year(today()))
	ls_platform="32"
ELSE
	ls_version = "20"+ string(env.pbmajorrevision)+ "." + string(env.pbbuildnumber)
	ls_platform=string(env.ProcessBitness)
END IF

ls_platform += " Bits"

ast_version.text=ls_version
ast_patform.text=ls_platform
end subroutine

public function long wf_retrieve (datawindow adw);Integer li_row, li_rowcount, li_Insert
String ls_ProductID[25]
String ls_description[25], ls_barcode[25]

ls_ProductID[]={'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25'}
ls_description[] = {'CONCRETE BLOCK 9X20X50', 	'POLYESTER COVER. EXP.22X100X65 CE MARKING', 	'LEAD PVC 90x67.5° DOUBLE SQUARE', 	'DISC DIAM CUTTING METAL-STEEL 230X2.4', 	'MAGNETIC MOUTH 13 MM', 	'FLASHING 4-985 SILVER ADHESIVE', 	'STAINLESS STEEL POOL LADDER 4P', 	'GOTEL 25K', 	'HAMMER DRILL 20V LI-ION', 	'SERGEANT APR BRICO 50X150', 	'BLACK RUBBER MALLET 250GR', 	'BLACK RUBBER HAMMER 500GR', 	'RUBIMIX-9N 1200W MIXER', 	'LEAD PVC 110x67.5° DOUBLE BRACKET', 	'STAINLESS STEEL TROWEL 28CM D12', 	'STAINLESS STEEL TROWEL 28CM D15', 	'RUBBER BOILER 10L', 	'STAINLESS STEEL HOSE 1/2H-1/2H 30CM', 	'CVL LOCK 1981-60 MORTICE', 	'DOUBLE UNION HOSE 8 M/MA8', 	'DOUBLE UNION HOSE 10A8', 	'ARTIFICIAL GRASS', 	'TAIL F PLUS DARK GRAY 5 KG',  'TAIL F PLUS WHITE 5 KG','EXTRACTION VALVE IN PP 100'} 
ls_barcode[] = {'8400000000109', 	'8400000001007', 	'8400000010009', 	'3661589053923', 	'3510785420889', 	'8413023020344', 	'8400000100038', 	'8400000100045', 	'8400000100052', 	'8015233871602', 	'8413797659047', 	'8413797659085', 	'8413797259407', 	'8400000010016', 	'8413797749472', 	'8413797769470', 	'8400000100120', 	'8430045036214', 	'8423869215200', 	'8427082091221', 	'8427082091214', 	'4350100747159', 	'8400000100182', 	'8400000100199', 	'8400000010023'} 


//We insert 25 Records for the Demo

 li_rowcount = 25
 
FOR li_Row = 1 to  li_RowCount
	li_Insert = adw.InsertRow(0)
	adw.object.ProductId[li_Insert] = ls_ProductID[li_Row]
	adw.object.Description[li_Insert] = ls_description[li_Row]
	adw.object.ean13[li_Insert] =ls_barcode[li_Row]
NEXT

return  li_rowcount
end function

on w_ean13.create
this.cb_1=create cb_1
this.st_platform=create st_platform
this.st_myversion=create st_myversion
this.st_ean13_reader=create st_ean13_reader
this.p_ean13_reader=create p_ean13_reader
this.st_ean13_generator=create st_ean13_generator
this.st_copyright=create st_copyright
this.p_rsrsystem=create p_rsrsystem
this.p_ean13_generator=create p_ean13_generator
this.dw_1=create dw_1
this.st_data=create st_data
this.sle_data=create sle_data
this.r_1=create r_1
this.p_ean13code=create p_ean13code
this.Control[]={this.cb_1,&
this.st_platform,&
this.st_myversion,&
this.st_ean13_reader,&
this.p_ean13_reader,&
this.st_ean13_generator,&
this.st_copyright,&
this.p_rsrsystem,&
this.p_ean13_generator,&
this.dw_1,&
this.st_data,&
this.sle_data,&
this.r_1,&
this.p_ean13code}
end on

on w_ean13.destroy
destroy(this.cb_1)
destroy(this.st_platform)
destroy(this.st_myversion)
destroy(this.st_ean13_reader)
destroy(this.p_ean13_reader)
destroy(this.st_ean13_generator)
destroy(this.st_copyright)
destroy(this.p_rsrsystem)
destroy(this.p_ean13_generator)
destroy(this.dw_1)
destroy(this.st_data)
destroy(this.sle_data)
destroy(this.r_1)
destroy(this.p_ean13code)
end on

event open;wf_version(st_myversion, st_platform)

wf_retrieve(dw_1)


io_ean13 = CREATE nvo_barcode

end event

event closequery;destroy io_ean13 
end event

type cb_1 from commandbutton within w_ean13
integer x = 2117
integer y = 856
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "New Barcode"
end type

event clicked;Long ll_Row, ll_RowCount
String ls_barcode, ls_Productid, ls_country ="SPAIN"
Integer li_year

li_year = year(today())

ll_RowCount=dw_1.RowCount()

FOR ll_Row = 1 to ll_RowCount
	ls_Productid = dw_1.object.ProductId[ll_Row]
	
	ls_barcode = io_ean13.of_generate_ean13_code(ls_country, ls_Productid)
	
	dw_1.object.Ean13[ll_Row] = ls_barcode
	
NEXT
end event

type st_platform from statictext within w_ean13
integer x = 2839
integer y = 140
integer width = 457
integer height = 72
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 33521664
string text = "Bits"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_myversion from statictext within w_ean13
integer x = 2839
integer y = 52
integer width = 457
integer height = 72
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 33521664
string text = "Versión"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ean13_reader from statictext within w_ean13
integer x = 2770
integer y = 676
integer width = 695
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217857
long backcolor = 67108864
string text = "<-- Click TO Read"
boolean focusrectangle = false
end type

type p_ean13_reader from picture within w_ean13
integer x = 2043
integer y = 564
integer width = 690
integer height = 236
string pointer = "HyperLink!"
string picturename = "ean13reader.png"
boolean focusrectangle = false
end type

event clicked;String ls_read, ls_filePath

//I remove the Ean13 to be able to generate the next
IF p_ean13code.PictureName = "" THEN
	messagebox("Error", "¡ There is no Ean13 loaded !", exclamation!)
	return
END IF	

ls_filePath = p_ean13code.PictureName

ls_read = io_ean13.of_read_ean13(ls_filePath)

messagebox("Ean13 Read", ls_read)

 
end event

type st_ean13_generator from statictext within w_ean13
integer x = 2770
integer y = 400
integer width = 695
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 134217857
long backcolor = 67108864
string text = "<-- Click TO Build"
boolean focusrectangle = false
end type

type st_copyright from statictext within w_ean13
integer x = 1778
integer y = 1684
integer width = 1531
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8421504
long backcolor = 67108864
string text = "Copyright © Ramón San Félix Ramón  rsrsystem.soft@gmail.com"
boolean focusrectangle = false
end type

type p_rsrsystem from picture within w_ean13
integer x = 5
integer y = 4
integer width = 1253
integer height = 248
boolean originalsize = true
string picturename = "logo.jpg"
boolean focusrectangle = false
string powertiptext = "Click Para Registrar Librerias"
end type

type p_ean13_generator from picture within w_ean13
integer x = 2043
integer y = 288
integer width = 690
integer height = 236
string pointer = "HyperLink!"
string picturename = "ean13generator.png"
boolean focusrectangle = false
end type

event clicked;String ls_data, ls_filePath

ls_data = sle_data.Text

//I remove the Ean13 to be able to generate the next
p_ean13code.PictureName = ""

ls_filePath = io_ean13.of_build_ean13(ls_data)

p_ean13code.PictureName = ls_filePath
end event

type dw_1 from datawindow within w_ean13
integer x = 73
integer y = 968
integer width = 3195
integer height = 632
integer taborder = 20
string title = "none"
string dataobject = "dw_products"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;String ls_barcode

debugbreak()

IF row < 1 THEN RETURN

ls_barcode = dw_1.object.ean13[row]

sle_data.text = ls_barcode
p_ean13code.PictureName = ""
end event

type st_data from statictext within w_ean13
integer x = 78
integer y = 320
integer width = 745
integer height = 88
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Data to Generate Ean13:"
boolean focusrectangle = false
end type

type sle_data from singlelineedit within w_ean13
integer x = 78
integer y = 424
integer width = 1765
integer height = 88
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 13
borderstyle borderstyle = stylelowered!
end type

type r_1 from rectangle within w_ean13
long linecolor = 33521664
integer linethickness = 4
long fillcolor = 33521664
integer y = -8
integer width = 3314
integer height = 260
end type

type p_ean13code from picture within w_ean13
integer x = 489
integer y = 520
integer width = 850
integer height = 428
boolean bringtotop = true
boolean focusrectangle = false
end type

