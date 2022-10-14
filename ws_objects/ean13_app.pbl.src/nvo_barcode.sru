$PBExportHeader$nvo_barcode.sru
forward
global type nvo_barcode from nonvisualobject
end type
end forward

global type nvo_barcode from nonvisualobject
end type
global nvo_barcode nvo_barcode

type variables
nvo_zxingnetcoreclass io_zxing

CONSTANT Integer AZTEC = 1
        //
        // Resumen:
        //     CODABAR 1D format.
CONSTANT Integer CODABAR = 2
        //
        // Resumen:
        //     Code 39 1D format.
CONSTANT Integer  CODE_39 =3
        //
        // Resumen:
        //     Code 93 1D format.
CONSTANT Integer CODE_93 =4
        //
        // Resumen:
        //     Code 128 1D format.
CONSTANT Integer CODE_128 =5
        //
        // Resumen:
        //     Data Matrix 2D barcode format.
CONSTANT Integer  DATA_MATRIX = 6
        //
        // Resumen:
        //     EAN-8 1D format.
CONSTANT Integer  EAN_8 = 7
        //
        // Resumen:
        //     EAN-13 1D format.
CONSTANT Integer EAN_13 = 8
        //
        // Resumen:
        //     ITF (Interleaved Two of Five) 1D format.
CONSTANT Integer ITF = 9
        //
        // Resumen:
        //     MaxiCode 2D barcode format.
CONSTANT Integer  MAXICODE =10
        //
        // Resumen:
        //     PDF417 format.
CONSTANT Integer  PDF_417 =11
        //
        // Resumen:
        //     QR Code 2D barcode format.
CONSTANT Integer  QR_CODE = 12
        //
        // Resumen:
        //     RSS 14
CONSTANT Integer RSS_14 = 13
        //
        // Resumen:
        //     RSS EXPANDED
CONSTANT Integer  RSS_EXPANDED =14
        //
        // Resumen:
        //     UPC-A 1D format.
CONSTANT Integer UPC_A =15
        //
        // Resumen:
        //     UPC-E 1D format.
CONSTANT Integer  UPC_E =16
        //
        // Resumen:
        //     UPC/EAN extension format. Not a stand-alone format.
CONSTANT Integer  UPC_EAN_EXTENSION =17
        //
        // Resumen:
        //     MSI
CONSTANT Integer  MSI = 18
        //
        // Resumen:
        //     Plessey
CONSTANT Integer  PLESSEY =19
        //
        // Resumen:
        //     Intelligent Mail barcode
CONSTANT Integer  IMB = 20
        //
        // Resumen:
        //     Pharmacode format.
CONSTANT Integer PHARMA_CODE = 21
        //
        // Resumen:
        //     UPC_A | UPC_E | EAN_13 | EAN_8 | CODABAR | CODE_39 | CODE_93 | CODE_128 | ITF
        //     | RSS_14 | RSS_EXPANDED without MSI (to many false-positives) and IMB (not enough
        //     tested, and it looks more like a 2D)  -->ONLY FOR DECODE
CONSTANT Integer   All_1D = 22
end variables

forward prototypes
private function boolean of_ean13_check (string as_code)
public function string of_read_ean13 (string as_filepath)
public function string of_build_ean13 (string as_data)
public function boolean of_control_dependencies ()
public function string of_ean13_control (string as_code)
end prototypes

private function boolean of_ean13_check (string as_code);String ls_check

if len(as_code) <> 13 then RETURN FALSE

ls_check=of_ean13_control(left(as_code,12))

if len(ls_check)<>1 or ls_check <> mid(as_code,13,1) then
	RETURN FALSE
else
	RETURN TRUE
end if
end function

public function string of_read_ean13 (string as_filepath);String ls_read

if not of_control_dependencies() then
	Return ls_read
end if	

IF isnull(as_filepath) OR as_filepath = "" or not FileExists( as_filepath) THEN
	messagebox("Atención!", "¡ There is no Ean13 Loaded ! ", exclamation!)
	Return ls_read
END IF

ls_read = io_Zxing.of_readbarcode(as_FilePath)

RETURN ls_read

end function

public function string of_build_ean13 (string as_data);String ls_path
String ls_ean13, ls_ean13_blanco
Integer li_width, li_height, li_margin, li_format
Boolean lb_PureBarcode
String ls_result

if not of_control_dependencies() then
	Return ls_ean13_blanco
end if	

if isnull(as_data) OR as_data = "" then
	messagebox("Error", "¡ There is no information to generate EAN13 !", exclamation!)
	Return ls_ean13_blanco
end if

ls_path = GetCurrentDirectory()
CreateDirectory(ls_path + "\EAN_13")

ls_ean13 = ls_path + "\EAN_13\ean13.png" // File where the barcode is generated.

FileDelete(ls_ean13) //If it exists, I'll delete it.

ls_ean13_blanco =  ls_path + "\EAN_13\ean13white.png"   // White File

//We could generate any other type of barcode. See Instance constants with all available Formats.
//EAN13 Code Configuration
li_width=218	
li_height=140
li_margin=2
lb_PureBarcode=false
li_format =EAN_13

CHOOSE CASE Len( as_data )
	CASE 12
		as_data += of_ean13_control( as_data)
	CASE 13
		if not of_ean13_check(as_data) then 
			Messagebox( "Error", "The barcode does not correspond to an EAN13", exclamation!)
			RETURN ""
		end if
END CHOOSE 

ls_result = io_zxing.of_barcodegenerate(as_data, ls_ean13, li_format, li_height, li_width, lb_PureBarcode, li_margin)
	
IF	NOT FileExists(ls_ean13) THEN
	ls_ean13 =  ls_ean13_blanco
END IF

IF ls_result <> ls_ean13 THEN
		messagebox("Error", ls_result, Stopsign!)
END IF	


RETURN ls_ean13
end function

public function boolean of_control_dependencies ();String ls_path

ls_path = GetCurrentDirectory()

if not FileExists( ls_path +"\ZxingBarcode.dll") then
	messagebox("Error","¡ You need the ZxingBarcode.dll File to generate the Ean13 !", exclamation!)
	Return False
end if	

if not FileExists( ls_path +"\zxing.dll") then
	messagebox("Error", "¡ You need the  zxing.dll File to generate the Ean13 !", exclamation!)
	Return False
end if	

if not FileExists( ls_path +"\System.Drawing.Common.dll") then
	messagebox("Error", "¡ You need the  System.Drawing.Common.dll File to generate the Ean13 !", exclamation!)
	Return False
end if	

return true
end function

public function string of_ean13_control (string as_code);long ll_pair, ll_odd, ll_check, ll_total

if len(as_code) <> 12 then RETURN as_code

ll_pair=integer(mid(as_code,2,1))+integer(mid(as_code,4,1))+&
		integer(mid(as_code,6,1))+integer(mid(as_code,8,1))+&
		integer(mid(as_code,10,1))+integer(mid(as_code,12,1))


ll_odd=integer(mid(as_code,1,1))+integer(mid(as_code,3,1))+&
		integer(mid(as_code,5,1))+integer(mid(as_code,7,1))+&
		integer(mid(as_code,9,1))+integer(mid(as_code,11,1))

ll_total=ll_pair*3 + ll_odd
ll_check=10 - (mod(ll_total,10) )

if ll_check=10 then ll_check=0


RETURN string(ll_check)
end function

on nvo_barcode.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_barcode.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;io_zxing = CREATE nvo_zxingnetcoreclass

end event

event destructor;destroy io_zxing 
end event

