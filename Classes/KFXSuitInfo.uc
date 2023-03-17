//-----------------------------------------------------------
//				��װ������Ϣ
//-----------------------------------------------------------
class KFXSuitInfo extends Info;

// ��װ��������Ϣ
struct KFXSuitAttribute
{
	var int AttrID;			// ����ID
    var int StarLevel;		// �Ǽ���
    var float Param1;		// Kֵ
    var float Param2;		// Nֵ
};

var array<KFXSuitAttribute> AttrInfo;
var array<String> AttrNames;
var KFXPlayer Player;


// ��ʼ����װ������Ϣ
function KFXInit(int SuitID)
{
	local KFXCSVTable CsvSuitItem, CsvAttrItem, CsvAttrName;
	local int TempID;
	local int Loop;

	;

	if ( SuitID == 0 )
    {
        log("KFXSuitInfo] Suit ID is none !");
        return;
    }

	CsvSuitItem = class'KFXTools'.static.KFXCreateCSVTable("PawnSuitWearing.csv");
	CsvAttrItem = class'KFXTools'.static.KFXCreateCSVTable("EquipAttribute.csv");
	CsvAttrName = class'KFXTools'.static.KFXCreateCSVTable("SuitAttrName.csv");

    if ( !CsvSuitItem.SetCurrentRow(SuitID) )
    {
        log("[KFXSuitInfo] Can't Resolve The Suit ID (PawnSuitWearing.csv): " $ SuitID);
        return;
    }

    Loop = 0;
    while ( CsvAttrName.SetCurrentRow(Loop + 1) )
    {
    	AttrNames.Insert(Loop, 1);
    	AttrNames[Loop ++] = CsvAttrName.GetString("Name");
    }

	for ( Loop = 0; Loop < AttrInfo.Length; Loop ++ )
	{

		TempID = CsvSuitItem.GetInt(AttrNames[AttrInfo[Loop].AttrID]);
	    if ( !CsvAttrItem.SetCurrentRow(TempID) )
	    {
	        log("[KFXSuitInfo] Can't Resolve The Attr:" @ AttrNames[AttrInfo[Loop].AttrID]
									@ "with this ID(EquipAttribute.csv): " $ TempID);
	    }
		else
		{
			AttrInfo[Loop].Param1 = CsvSuitItem.GetFloat("Param1");
			AttrInfo[Loop].Param2 = CsvSuitItem.GetFloat("Param2");
	    }
	}
}


function int KFXGetAttrIndex(string AttrDes)
{
	local int AttrIndex;

	for ( AttrIndex = 0; AttrIndex < AttrInfo.Length; AttrIndex ++ )
	{
		if ( AttrDes == AttrNames[AttrInfo[AttrIndex].AttrID] )
		{
			return AttrIndex;
		}
	}

	;

	return -1;
}

defaultproperties
{
}
