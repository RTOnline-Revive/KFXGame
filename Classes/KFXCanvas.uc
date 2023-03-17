//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXCanvas extends Canvas
    config(user);

var globalconfig int    KFXFontNum;
var globalconfig int    KFXFontTexSize;
var globalconfig string KFXFonts[48];
var globalconfig int KFXAdditionalFontNum;	//外部字体个数
var globalconfig String KFXAdditionalFonts[8];	//外部字体路径

event KFXInitFonts()
{
    local int loop;
    local int FontWidth;
    local int FontHeight;
    local string FontName;
    local string FontAlias;
    //<< wangkai, font bold support 2008-03-19
    local int FontWeight;
    //>>
    local array<string> TextArray;

    for ( loop = 0; loop < KFXFontNum; loop++ )
    {
        Split(KFXFonts[loop], "|", TextArray);

        FontName   = TextArray[0];
        FontAlias  = TextArray[1];
        FontWidth  = int(TextArray[2]);
        FontHeight = int(TextArray[3]);
        //<< wangkai, font bold support 2008-03-19
        FontWeight   = int(TextArray[4]);
        //>>

        //log("Font["$loop$"]: "$FontName$"|"$FontAlias$"|"$FontWidth$"|"$FontHeight);
        log("Font["$loop$"]: "$FontName$"|"$FontAlias$"|"$FontWidth$"|"$FontHeight $" | FontWeight: "$FontWeight);

        KFXSetupFont(FontName, FontAlias, FontWidth, FontHeight, FontWeight, KFXFontTexSize, KFXFontTexSize);
    }
}

event KFXAddFontResources()
{
	local int i;
	for(i=0; i<KFXAdditionalFontNum; i++)
	{
		KFXAddFontResource(KFXAdditionalFonts[i]);
	}
}
event KFXRemoveFontResources()
{
	local int i;
	for(i=0; i<KFXAdditionalFontNum; i++)
	{
		KFXRemoveFontResource(KFXAdditionalFonts[i]);
	}
}

defaultproperties
{
     KFXFontTexSize=512
}
