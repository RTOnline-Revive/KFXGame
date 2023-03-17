//-----------------------------------------------------------
//
//-----------------------------------------------------------
class RandCoin extends Actor;


var int ResultFace; //³õÊ¼»¯Îª0£¬À¶1£¬ºì2
var float StartRotTime;
var float LastRotTime;
var int LastSpeed;
var int RotAcceler;
var rotator RotYaw;

function postbeginplay()
{
    super.PostBeginPlay();
}

//Ðý×ªÓ²±Ò
function DrawRotCoin(Canvas c)
{
    local Actor ViewActor;
    local vector CameraLocation;
    local rotator CameraRotation;
    local vector CoinAxisX;
    local vector CoinAxisY;
    local vector CoinAxisZ;

    if(StartRotTime == 0.0)
    {
        StartRotTime = level.TimeSeconds;
        LastRotTime = StartRotTime;
    }

    c.GetCameraLocation(CameraLocation,CameraRotation);
    SetLocation(CameraLocation+(vect(300,0,0)>>CameraRotation));

    if(LastSpeed > 0)
    {
        RotYaw.Yaw += LastSpeed*(level.TimeSeconds - LastRotTime);
        RotYaw.Yaw = RotYaw.Yaw%65536;
        LastSpeed -= RotAcceler*(level.TimeSeconds - LastRotTime);
        LastRotTime = level.TimeSeconds;
    }
    if(level.TimeSeconds - StartRotTime>1.8)
    {
        if(ResultFace==1 && RotYaw.Yaw > 49152)
        {
            RotYaw.Yaw = 0;
            LastSpeed = -1;
        }
        else if(ResultFace == 2 && RotYaw.Yaw > 16384 )
        {
            RotYaw.Yaw = 32768;
            LastSpeed = -1;
        }
    }

    CoinAxisX = (vect(1,0,0)>>RotYaw)>>CameraRotation;
    CoinAxisY = (vect(0,1,0)>>RotYaw)>>CameraRotation;
    CoinAxisZ = (vect(0,0,1)>>RotYaw)>>CameraRotation;

    SetRotation(OrthoRotation(CoinAxisX,CoinAxisY,CoinAxisZ));
    c.DrawActorClipped(self,false,0,0,c.SizeX, c.SizeY,true,10);

    //PlayerController(Owner).PlayerCalcView(
}

defaultproperties
{
     LastSpeed=65536
     DrawType=DT_Mesh
     bUnlit=是
}
