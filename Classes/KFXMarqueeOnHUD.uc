//-----------------------------------------------------------
//  liubo, hud上的走马灯
//  使用方法：
//		定义变量:var automated KFXMarqueeOnHUD marquee;
//		然后在defaultproperties中：
//			Begin Object class=KFXMarqueeOnHUD name=mar
//			End Object
//			marquee=mar
//-----------------------------------------------------------
class KFXMarqueeOnHUD extends Object;

enum EShowType
{
	SHOW_LeftToRight,	//从左到右
	SHOW_RightToLeft     //从右到左
};
struct EmotionInfo
{
    var string MaterialName;
    var float  MatPosX;
    var int  U;
    var int  v;
    var int  UL;
    var int  VL;
};
var bool 				m_bRunning;
var string 	            m_sWords;
var array<EmotionInfo>	m_emotion;
var float 				m_nStartTime, m_nNeedTime;
var float				m_nLeft, m_nTop, m_nWidth, m_nHeight;
var int					m_nWordMax;

var color				m_color;
var string				m_sFont;
var EShowType			m_eShowType;
var string				m_sImage;

var float 				m_nDyPic1, m_nDyPic2, m_nDyWordWait;
var bool 				bShown;

var Canvas 				canvas;
var Material			pic1, pic2, pic3;
var color 				thickPrado;

var color colorPrado[2];
var color colorPradoShade[2];
var float shadeWidth;

///重新初始化
function reInit()
{
	m_bRunning = false;
	m_sWords = "";
	m_nStartTime = 0;
	m_nNeedTime = 0;
	m_nLeft = 0;
	m_nTop = 0;
	m_nHeight = 0;
	m_nWidth = 0;
	bShown=false;
	m_emotion.Remove(0, m_emotion.Length);
}
///设置动画效果参数, pic1=pic1结束时间，pic2=pic2结束时间，wait=文字等待时间
function setDy(float pic1, float pic2, float wait)
{
	m_nDyPic1 = pic1;
	m_nDyPic2 = pic2;
	m_nDyWordWait = wait;
}

///设置显示的位置
function setPos(float x, float y, float w, float h)
{
	m_nLeft = x;
	m_nTop = y;
	m_nWidth = w;
	m_nHeight = h;
}

///设置要显示的文字，起始时间和一共需要显示的时间
function set(Canvas ca, string word, float start, float need)
{
	m_bRunning = true;
	m_sWords = word;
	m_nStartTime = start;
	m_nNeedTime = need;
	canvas = ca;
	parseWord(m_sWords);

	Pic1=Material(DynamicLoadObject("fx_ui_ad_texs.HUD_speaker_effect1", class'Material'));
	Pic2=Material(DynamicLoadObject("fx_ui_ad_texs.HUD_speaker_map1", class'Material'));
	pic3=Material(DynamicLoadObject("fx_ui3_texs.login_Expression", class'Material'));
}
function setColor(int colorType)
{
	if(colorType<0 || colorType > 1){
		colortype = 0;
	}
	m_color = colorPrado[colorType];
	thickPrado = colorPradoShade[colorType];
	if(colorType == 1)
		shadeWidth = 2;
	else
		shadeWidth = 2;
}
//把文字中的表情提取出来
function parseWord(out string word)
{
	local string s;
	local float xl, yl;
	local int i, nlen;
	s = word;
	word = "";
	Canvas.KFXFontAlias = m_sFont;
	nlen = Len(s);
	for(i=0; i< nlen; i++){
     	if(Mid(s, i, 1) == "/"){
         	if(IsExp(Mid(s, i+1, 3))){
				Canvas.KFXStrLen(word, xl, yl);
				m_emotion[m_emotion.length-1].MatPosX=xl;
				word $= "  ";
				i += 3;
			}else{
				word $= "/";
			}
		}else{
			word $= Mid(s, i, 1);
		}
	}
}



///画
///返回false时，表示绘制结束。
function bool draw(Canvas canvas, float currTime)
{
	local float speed;
	local Canvas myCanvas;
	local int i, mj;
	local EDrawPivot pivotOld;
	myCanvas = canvas;
	//speed = (currTime - m_nStartTime) / m_nNeedTime;
	if((currTime - m_nStartTime) >= m_nNeedTime){
		m_bRunning = false;
		return false;
	}
	//画图片，画完图片后再画文字
 	//第一秒画闪光

	//第2~3秒画卷轴拉开动作
	//第4~8秒画文字
	//第8~9秒画文字等待。
	canvas.SetDrawColor(255, 255, 255, 170);
	pivotOld = Canvas.KFXDrawPivot;
	Canvas.KFXSetPivot(DP_UpperMiddle);
	if((currTime - m_nStartTime) < 0){
    	log("#### ERROR #### currTime < startTime");
	}else if((currTime - m_nStartTime) < m_nDyPic1){
		bShown = true;
		Canvas.SetPos( (m_nLeft + m_nWidth / 2 - 28 / 2) , m_nTop + m_nHeight / 2 - 200 / 2 + 10);
//		myCanvas.DrawTile(Material(DynamicLoadObject("fx_ui_ad_texs.HUD_speaker_effect1", class'Material')),
		myCanvas.DrawTile(pic1,
					28,
					148,
					0,
					0,
					56,
					200);
	}else if((currTime - m_nStartTime) < m_nDyPic2){
		speed = (currTime - m_nStartTime) / m_nDyPic2;
		Canvas.SetPos((m_nLeft + m_nWidth / 2 - speed * 760 / 2), m_nTop);
//		myCanvas.DrawTile(Material(DynamicLoadObject("fx_ui_ad_texs.HUD_speaker_map1", class'Material')),
		myCanvas.DrawTile(Pic2,
					(speed * 760),
					75,
					(760.0 / 2 - speed * 760 / 2),
					0,
					(speed * 760),
					75);

	}else if((currTime - m_nStartTime) < m_nNeedTime){
    	//画文字，从右到左，下次做一个可配的，既能从左到右又能从右到左，多少！
    	//3秒时动画时间，1秒时文字等待时间
		//来点渐变
		Canvas.SetPos(m_nLeft, m_nTop);
//		myCanvas.DrawTile(Material(DynamicLoadObject("fx_ui_ad_texs.HUD_speaker_map1", class'Material')),
		myCanvas.DrawTile(Pic2,
					760,
					75,
					0,
					0,
					760,
					75);


		speed = (currTime - m_nStartTime - m_nDyPic2) / (m_nNeedTime - m_nDyPic2 - m_nDyWordWait);
		if(speed > 1)
			speed = 1;
		myCanvas.KFXFontAlias = m_sFont;
		myCanvas.DrawColor = m_color;
		if(m_eShowType == SHOW_RightToLeft){
			//文字居左显示，动作时从右到左，最后停靠在左侧
			myCanvas.KFXDrawStrJustifiedWithBorder(Left(m_sWords, int(speed * m_nWordMax)),
							0,
							m_nLeft + m_nWidth*(1-speed) + 10,
							m_nTop + 8,
							m_nLeft + m_nWidth - 20,
							m_nTop + m_nHeight,
							thickPrado, shadeWidth);
			//画表情
			for(i=0; i< m_emotion.Length; i++){
				if((m_emotion[i].MatPosX + 10) >= (m_nWidth * speed)){
					break;
				}else{
					myCanvas.SetDrawColor(255, 255, 255);
					myCanvas.SetPos(m_nLeft + m_nWidth*(1-speed) + 10 + m_emotion[i].MatPosX,
									m_nTop + 32);
					mj = m_nWidth*speed - m_emotion[i].MatPosX - 10;
					if(mj > m_emotion[i].UL)
						mj = m_emotion[i].UL;
					myCanvas.DrawTile(pic3,			//这里截取的图片大小不对，需要改！
								mj,
								m_emotion[i].VL,
								m_emotion[i].U,
								m_emotion[i].V,
								m_emotion[i].UL,
								m_emotion[i].VL);
				}
			}


		}else if(m_eShowType == SHOW_LeftToRight){	//从左到右
			myCanvas.KFXDrawStrJustified(Left(m_sWords, int(speed * m_nWordMax)),
							2,
							m_nLeft,
							m_nTop + 8,
							m_nLeft + m_nWidth * speed,
							m_nTop + m_nHeight);
		}//想办法来个从上到下、从下到上就帅了！

	}

	canvas.KFXSetPivot(pivotOld);


	return true;

}
function bool isRunning()
{
	return m_bRunning;
}
function doStop()
{
	m_bRunning = false;
}
function string getWord(float speed)
{
	if(speed > 1){
    	return m_sWords $ getBlackspace(int((speed-1) * m_nWordMax));
	}else{
		return Left(m_sWords, int(speed * m_nWordMax));
	}
}

function string getBlackspace(int n)
{
	if(n == 0)
		return "";
	else
		return " "$getBlackspace(n-1);
}

///这段代码有待改进
function bool IsExp(string tmp)
{
    local int ix;
    local bool bResult;

    local KFXCSVTable CSVIconInfos;

	if(Left(tmp, 1) != "0"){
		return false;
	}
    // Read icon info from CSV table
    CSVIconInfos = class'KFXTools'.static.KFXCreateCSVTable("SmileyIcons.csv");
    if (CSVIconInfos != none)
    {
        for (ix =0; CSVIconInfos.SetCurrentRow(ix); ix++)
        {
            bResult = false;
            if (tmp == CSVIconInfos.GetString("alias"))
            {
				m_emotion.Insert(m_emotion.length, 1);
				m_emotion[m_emotion.length-1].MaterialName = CSVIconInfos.GetString("material");
				m_emotion[m_emotion.Length-1].MatPosX = 0;
				m_emotion[m_emotion.Length-1].U = csvIconInfos.GetInt("U");
				m_emotion[m_emotion.Length-1].V = csvIconInfos.GetInt("V");
				m_emotion[m_emotion.Length-1].VL = csvIconInfos.GetInt("UL");
				m_emotion[m_emotion.Length-1].UL = csvIconInfos.GetInt("VL");

				bResult = true;
                break;
            }
            else if(CSVIconInfos.GetString("alias") == "")
            {
                bResult = false;
                break;
            }
        }
        return bResult;
    }
}

defaultproperties
{
     m_nWordMax=84
     m_color=(G=246,R=255,A=255)
     m_sFont="heavymedium14"
     m_eShowType=SHOW_RightToLeft
     thickPrado=(B=2,G=2,R=120,A=255)
     colorPrado(0)=(G=246,R=255,A=255)
     colorPrado(1)=(B=6,G=6,R=192,A=255)
     colorPradoShade(0)=(B=2,G=2,R=120,A=255)
     colorPradoShade(1)=(G=253,R=250,A=255)
     shadeWidth=2.000000
}
