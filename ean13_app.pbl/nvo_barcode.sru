forward
global type nvo_barcode from nonvisualobject
end type
end forward

global type nvo_barcode from nonvisualobject
end type
global nvo_barcode nvo_barcode

type variables
nvo_zxingnet8 io_zxing

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
private function string of_country_code (string as_country_name)
private function string of_ean13_control (string as_code)
public function string of_generate_ean13_code (string as_country, string as_productid)
public function boolean of_dependencies_control ()
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

if not of_dependencies_control() then
	Return ls_read
end if	

IF isnull(as_filepath) OR as_filepath = "" or not FileExists( as_filepath) THEN
	messagebox("Atención!", "¡ There is no Ean13 Loaded ! ", exclamation!)
	Return ls_read
END IF

ls_read = io_Zxing.of_readbarcode(as_FilePath)

IF isnull(ls_read) or ls_read="" THEN
	messagebox("Error", io_zxing.is_ErrorText, Stopsign!)
END IF	

RETURN ls_read

end function

public function string of_build_ean13 (string as_data);String ls_path
String ls_ean13, ls_ean13_blanco
Integer li_width, li_height, li_margin, li_format
Boolean lb_PureBarcode
String ls_result

if not of_dependencies_control() then
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

IF isnull(ls_result) or ls_result="" THEN ls_result=io_zxing.is_ErrorText
	
IF ls_result <> ls_ean13 THEN
		messagebox("Error", ls_result, Stopsign!)
END IF	

IF	NOT FileExists(ls_ean13) THEN
	ls_ean13 =  ls_ean13_blanco
END IF

RETURN ls_ean13
end function

private function string of_country_code (string as_country_name);String as_country_code

//https://es.activebarcode.com/codes/ean13_laenderpraefixe

Choose Case Upper(as_country_name)
	Case "USA"  
		as_country_code = "00"  //00 - 13 USA and Canada
	Case "CANADA"  
		as_country_code = "01" //00 - 13 USA and Canada
	case"FANCE"  
		as_country_code = "30"
	Case "BULGARIA" 
		as_country_code = "380"
	Case "SLOVENIA"  
		as_country_code = "383"
	Case "CROATIA"  
		as_country_code = "385"
	Case "BOSNIA"  
		as_country_code = "387"
	Case "HERZEGOVINA"  
		as_country_code = "387"
	Case "GERMANY" 
		as_country_code = "400" //400 - 440 Germany
	Case "JAPAN"  
		as_country_code = "45"
	Case "RUSSIA"  
		as_country_code = "460"
	Case "TAIWAN"  
		as_country_code = "471"
	Case "ESTONIA"  
		as_country_code = "474"
	Case "LATVIA"  
		as_country_code = "475"
	Case "ASERBEIDJAN"  
		as_country_code = "476"
	Case "LITHUANIA"  
		as_country_code = "477"
	Case "UZBEKISTAN"  
		as_country_code = "478"
	Case "SRI LANKA"  
		as_country_code = "479"
	Case "PHILIPPINES"  
		as_country_code = "480"
	Case "BELARUS"  
		as_country_code = "481"
	Case "UKRAINE"  
		as_country_code = "482"
	Case "MOLDOVA"  
		as_country_code = "484"
	Case "ARMENIEN"  
		as_country_code = "485"
	Case "GEORGIEN"  
		as_country_code = "486"
	Case "KAZAKHSTAN"  
		as_country_code = "487"
	Case "HONG KONG"  
		as_country_code = "489"
	Case "GREAT BRITAIN"  
		as_country_code = "50"
	Case "GREECE"  
		as_country_code = "520"
	Case "LEBANESE"  
		as_country_code = "528"
	Case "CYPRUS"  
		as_country_code = "529"
	Case "MACEDONIANS"  
		as_country_code = "531"
	Case "MALTS"  
		as_country_code = "535"
	Case "IRELAND"  
		as_country_code = "539"
	Case "BELGIUM"  
		as_country_code = "54"
	Case "LUXEMBOURG"  
		as_country_code = "54"
	Case "PORTUGAL"  
		as_country_code = "560"
	Case "ICELAND"  
		as_country_code = "569"
	Case "DENMARK"  
		as_country_code = "57"
	Case "POLAND"  
		as_country_code = "590"
	Case "ROMANIA"  
		as_country_code = "594"
	Case "HUNGARY"  
		as_country_code = "599"
	Case "SOUTH AFRICA"  
		as_country_code = "600" //600, 601 South Africa
	Case "BAHRAIN"  
		as_country_code = "608"
	Case "MAURITIUS"  
		as_country_code = "609"
	Case "MOROCCO"  
		as_country_code = "611"
	Case "ALGERIA"  
		as_country_code = "613"
	Case "KENYA"  
		as_country_code = "616"
	Case "TUNISIA"  
		as_country_code = "619"
	Case "SYRIA"  
		as_country_code = "621"
	Case "EGYPT"  
		as_country_code = "622"
	Case "LYBIEN"  
		as_country_code = "624"
	Case "JORDAN"  
		as_country_code = "625"
	Case "IRANS"  
		as_country_code = "626"
	Case "KUWAIT"  
		as_country_code = "627"
	Case "SAUDI ARABIA"  
		as_country_code = "628"
	Case "UNITED ARAB EMIRATES"  
		as_country_code = "629"
	Case "FINLAND"  
		as_country_code = "64"
	Case "CHINA"  
		as_country_code = "690"
	Case "NORWAY"  
		as_country_code = "70"
	Case "ISRAELS"  
		as_country_code = "729"
	Case "SWEDEN"  
		as_country_code = "73"
	Case "CENTRAL AMERICA"  
		as_country_code = "740" //740 - 745 Central America (Guatemala, El Salvador, Honduras, Nicaragua, Costa Rica, Panama)
	Case "DOMINICAN REPUBLIC"  
		as_country_code = "746"
	Case "MEXICO"  
		as_country_code = "750"
	Case "VENEZUELA"  
		as_country_code = "759"
	Case "SWITZERLAND"  
		as_country_code = "76"
	Case "LIECHTENSTEIN"  
		as_country_code = "76"
	Case "COLOMBIA"  
		as_country_code = "770"
	Case "URUGUAY"  
		as_country_code = "773"
	Case "PERU"  
		as_country_code = "775"
	Case "BOLIVIA"  
		as_country_code = "777"
	Case "ARGENTINA"  
		as_country_code = "779"
	Case "CHILE"  
		as_country_code = "780"
	Case "PARAGUAY"  
		as_country_code = "784"
	Case "ECUADOR"  
		as_country_code = "786"
	Case "BRAZIL"  
		as_country_code = "789" //789 - 790 Brazil
	Case "ITALY"  
		as_country_code = "80" //80 - 83 Italiy
	Case "SPAIN"  
		as_country_code = "84"
	Case "CUBA"  
		as_country_code = "850"
	Case "SLOVAKIA"  
		as_country_code = "858"
	Case " CZECH REPUBLIC"  
		as_country_code = "859"
	Case "YUGOSLAVIA"  
		as_country_code = "860"
	Case "YUGOSLAVIA"  
		as_country_code = "867"
	Case "TURKEY"  
		as_country_code = "869"
	Case "NETHERLANDS"  
		as_country_code = "87"
	Case "SOUTH KOREA"  
		as_country_code = "880"
	Case "THAILAND"  
		as_country_code = "885"
	Case "SINGAPORE"  
		as_country_code = "888"
	Case "INDIA"  
		as_country_code = "890"
	Case "VIET NAM"  
		as_country_code = "893"
	Case "INDONESIA"  
		as_country_code = "899"
	Case "AUSTRIA"  
		as_country_code = "90"
	Case "AUSTRALIA"  
		as_country_code = "93"
	Case "NEW ZEALAND"  
		as_country_code = "94"
	Case "MALAYSIA"  
		as_country_code = "955"
	Case "MAKAO"  
		as_country_code = "958"
End choose
 	
//977 Journals (ISSN)
//978 - 979 Books (ISBN)
//980 - 99 Promotional Codes

Return as_country_code



end function

private function string of_ean13_control (string as_code);long ll_pair, ll_odd, ll_check, ll_total

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

public function string of_generate_ean13_code (string as_country, string as_productid);String ls_ean13
String ls_country_code, ls_control_digit

ls_country_code = of_country_code("SPAIN")

ls_ean13 = ls_country_code+fill("0", 12 - len(ls_country_code) - len(as_Productid)) + as_Productid

ls_control_digit = of_ean13_control(ls_ean13)

ls_ean13 += ls_control_digit 

RETURN ls_ean13
end function

public function boolean of_dependencies_control ();String ls_files[]
Int li_File, li_TotalFiles

ls_files[]={"ZxingBarcode.deps.json", "ZxingBarcode.dll", "zxing.dll", "ZXing.Windows.Compatibility.dll", "System.Drawing.Common.dll", "Microsoft.Win32.SystemEvents.dll"}

li_TotalFiles = UpperBound(ls_files[])

FOR li_File = 1 TO li_TotalFiles
	IF NOT FileExists(gs_appdir+"DotNet\ZxingBarcode\"+ls_files[li_File]) THEN
		MessageBox ("Atención", "¡ You need the "+ls_files[li_File]+" File to generate the Ean13 !", Exclamation!)
		Return FALSE
	END IF
NEXT	

Return TRUE
end function

on nvo_barcode.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_barcode.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;io_zxing = CREATE nvo_zxingnet8
end event

event destructor;destroy io_zxing 
end event

