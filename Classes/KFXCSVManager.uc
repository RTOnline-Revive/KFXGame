//-----------------------------------------------------------
//
//-----------------------------------------------------------
class KFXCSVManager extends CSVManager
native;


event KFXCSVTable GetConfigTableByIndex(int TableIndex)
{
    return class'KFXTools'.static.GetConfigTable(TableIndex);
}

defaultproperties
{
}
