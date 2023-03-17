//-----------------------------------------------------------
//  Class:      KFXGame.KFXVoiceReplicationInfo
//  Creator:    zhangjinpin@kingsoft 张金品
//  Data:       2007-03-26
//  Desc:       语音同步信息
//  Update:
//  Special:    超级麻烦
//-----------------------------------------------------------

class KFXVoiceReplicationInfo extends VoiceChatReplicationInfo;

simulated event PostNetBeginPlay()
{
	local PlayerReplicationInfo PRI;

	Super.PostNetBeginPlay();

	foreach DynamicActors(class'PlayerReplicationInfo', PRI)
	{
		PRI.VoiceInfo = Self;
	}
}

simulated event SetGRI(GameReplicationInfo NewGRI)
{
	// SetGRI is called at the end of GameReplicationInfo.PostNetBeginPlay()
	GRI = NewGRI;
	GRI.VoiceReplicationInfo = Self;
}

simulated function InitChannels()
{
	local VoiceChatRoom VCR;

	Super.InitChannels();

	// Add Public channel
	AddVoiceChannel();
	if ( bAllowLocalBroadcast )
	{
		// Add Local channel
		VCR = AddVoiceChannel();
		VCR.bLocal = True;
	}
}

simulated function AddVoiceChatter(PlayerReplicationInfo NewPRI)
{
	if ( NewPRI == None )
	{
		log("AddVoiceChatter() not executing: NewPRI is NONE!",'VoiceChat');
		return;
	}


	if (!bEnableVoiceChat || NewPRI.bOnlySpectator || NewPRI.bBot || (NewPRI.Owner != None && KFXPlayer(NewPRI.Owner) == None) )
		return;

	log("AddVoiceChatter:"$NewPRI@NewPRI.PlayerName@NewPRI.VoiceID,'VoiceChat');
	AddVoiceChannel(NewPRI);
}
simulated function RemoveVoiceChatter(PlayerReplicationInfo PRI)
{
	local PlayerController PC;
	if (PRI == None)
		return;

	log("RemoveVoiceChatter:"$PRI@PRI.PlayerName,'VoiceChat');

	// Player logging out - remove their ban tracking information and their personal chat channel
	if ( Role < ROLE_Authority )
	{
		PC = Level.GetLocalPlayerController();
		if ( PC != None && PC.ChatManager != None )
			PC.ChatManager.UntrackPlayer(PRI.PlayerID);
	}

	RemoveVoiceChannel(PRI);
}

simulated function bool CanJoinChannel(string ChannelTitle, PlayerReplicationInfo PRI)
{
	local VoiceChatRoom VCR;
	local int i;

	if ( PRI != None && PRI.Team != None)
		i = PRI.Team.TeamIndex;

	VCR = GetChannel(ChannelTitle, i);
	if (VCR == None)
		return false;

	return VCR.CanJoinChannel(PRI);
}

// Joins / Leaves
function VoiceChatRoom.EJoinChatResult JoinChannel(string ChannelTitle, PlayerReplicationInfo PRI, string Password)
{
	local VoiceChatRoom VCR;
	local int i;

	if (PRI != None && PRI.Team != None)
		i = PRI.Team.TeamIndex;

	VCR = GetChannel(ChannelTitle, i);
	if (VCR == None)
		return JCR_Invalid;

	return VCR.JoinChannel(PRI, Password);
}
function VoiceChatRoom.EJoinChatResult JoinChannelAt(int ChannelIndex, PlayerReplicationInfo PRI, string Password)
{
	local VoiceChatRoom VCR;

	VCR = GetChannelAt(ChannelIndex);
	if ( VCR == None )
		return JCR_Invalid;

	return VCR.JoinChannel(PRI, Password);
}
function bool LeaveChannel(string ChannelTitle, PlayerReplicationInfo PRI)
{
	local VoiceChatRoom VCR;
	local int i;

	if (PRI != None && PRI.Team != None)
		i = PRI.Team.TeamIndex;

	VCR = GetChannel(ChannelTitle, i);
	return VCR.LeaveChannel(PRI);
}

// Channel management
// player joined - create a private chatroom for that player
// Must happen after PRI.PlayerID has been assigned and replicated
simulated function VoiceChatRoom AddVoiceChannel(optional PlayerReplicationInfo PRI)
{
	local int i, cnt;
	local VoiceChatRoom VCR;

	log(Name@"AddVoiceChannel PRI:"$PRI,'VoiceChat');
	VCR = CreateNewVoiceChannel(PRI);
	if (VCR != None)
	{
		VCR.VoiceChatManager = Self;
		i = Channels.Length;
		cnt = GetPublicChannelCount();
		if (PRI == None)
			VCR.ChannelIndex = i;
		else
		{
			VCR.ChannelIndex = cnt + PRI.PlayerID;
			PRI.PrivateChatRoom = VCR;

			// Owner of the channel is always a member
			VCR.AddMember(PRI);
		}

		for ( i = 0; i < Channels.Length; i++ )
			if ( Channels[i] != None && Channels[i].ChannelIndex > VCR.ChannelIndex )
				break;

		Channels.Insert(i, 1);
		Channels[i] = VCR;
	}

	return VCR;
}
// player left - destroy the private chatroom for that player
simulated function bool	RemoveVoiceChannel(PlayerReplicationInfo PRI)
{
	local VoiceChatRoom VCR;
	local int i;

	if ( PRI != None && Role == ROLE_Authority )
		PRI.ActiveChannel = -1;

	// Remove this PRI from all channels that they were a member of
	for (i = Channels.Length - 1; i >= 0; i--)
	{
		if (Channels[i] != None)
		{
			if (Channels[i].Owner == PRI)
			{
				VCR = Channels[i];
				Channels.Remove(i,1);
			}

			else Channels[i].RemoveMember(PRI);
		}

		else Channels.Remove(i,1);
	}

	// already destroyed
	if (VCR == None)
		return Super.RemoveVoiceChannel(PRI);

	DestroyVoiceChannel(VCR);
	return Super.RemoveVoiceChannel(PRI);
}

// Query Functions
// return a single chat room
simulated function VoiceChatRoom GetChannel(string ChatRoomName, optional int TeamIndex)
{
	local int i;

	for (i = 0; i < Channels.Length; i++)
		if (Channels[i] != None && Channels[i].GetTitle() ~= ChatRoomName && Channels[i].Owner != None)
			return Channels[i];

	return Super.GetChannel(ChatRoomName, TeamIndex);
}
simulated function VoiceChatRoom GetChannelAt(int Index)
{
	local int i;

	if ( Index < 0 )
		return None;

	for (i = 0; i < Channels.Length; i++)
		if (Channels[i] != None && Channels[i].ChannelIndex == Index && Channels[i].Owner != None)
			return Channels[i];

	return Super.GetChannelAt(Index);
}
simulated function array<int> GetChannelMembers(string ChatRoomName, optional int TeamIndex)
{
	local VoiceChatRoom Room;
	local array<PlayerReplicationInfo> Members;
	local array<int> MemberIds;
	local int i;

	Room = GetChannel(ChatRoomName, TeamIndex);

	if (Room != None)
	{
		Members = Room.GetMembers();
		MemberIds.Length = Members.Length;
		for (i = 0; i < Members.Length; i++)
		{
			if ( Members[i] != None )
				MemberIds[i] = Members[i].PlayerID;
		}
	}

	return MemberIds;
}
simulated function array<int> GetChannelMembersAt(int Index)
{
	local VoiceChatRoom Room;
	local array<PlayerReplicationInfo> Members;
	local array<int> MemberIds;
	local int i;

	Room = GetChannelAt(Index);
	if (Room != None)
	{
		Members = Room.GetMembers();
		MemberIds.Length = Members.Length;
		for (i = 0; i < Members.Length; i++)
		{
			if ( Members[i] != None )
				MemberIds[i] = Members[i].PlayerID;
		}
	}

	return MemberIds;
}

simulated function array<int> GetMemberChannels(PlayerReplicationInfo PRI)
{
	local array<int> ChannelIndexArray;
	local int i;

	for ( i = 0; i < Channels.Length; i++ )
		if ( Channels[i] != None && Channels[i].IsMember(PRI) )
			ChannelIndexArray[ChannelIndexArray.Length] = Channels[i].ChannelIndex;

	return ChannelIndexArray;
}

simulated function array<VoiceChatRoom> GetChannels()
{
	return Channels;
}
simulated event int GetChannelCount()
{
	return Channels.Length;
}
simulated event int GetChannelIndex(string ChannelTitle, optional int TeamIndex)
{
	local int i;

	for (i = 0; i < Channels.Length; i++)
		if (Channels[i] != None && Channels[i].GetTitle() ~= ChannelTitle)
			return Channels[i].ChannelIndex;

	return Super.GetChannelIndex(ChannelTitle, TeamIndex);
}
simulated function array<VoiceChatRoom>	GetPublicChannels()
{
	local array<VoiceChatRoom> Rooms;
	local int i;

	for (i = 0; i < Channels.Length; i++)
		if (Channels[i] != None && Channels[i].Owner == Self)
			Rooms[Rooms.Length] = Channels[i];

	return Rooms;
}
simulated function array<VoiceChatRoom>	GetPlayerChannels()
{
	local array<VoiceChatRoom> Rooms;
	local int i;

	for (i = 0; i < Channels.Length; i++)
	{
		if (Channels[i] != None && Channels[i].Owner != None && Channels[i].Owner != Self)
			Rooms[Rooms.Length] = Channels[i];
	}

	return Rooms;
}
simulated function int GetPublicChannelCount(optional bool bSingleTeam)
{
	local int i, cnt;

	for ( i = 0; i < Channels.Length; i++ )
		if ( Channels[i] != None && Channels[i].Owner == Self && (Channels[i].GetTeam() == 0 || !bSingleTeam) )
			cnt++;

	return cnt;
}
simulated function int GetPlayerChannelCount()
{
	local array<VoiceChatRoom> Arr;
	Arr = GetPlayerChannels();
	return Arr.Length;
}

simulated function bool IsMember(PlayerReplicationInfo TestPRI, int ChannelIndex, optional bool bNoCascade)
{
	local VoiceChatRoom VCR;

	if ( TestPRI == None )
		return false;

	VCR = GetChannelAt(ChannelIndex);
	if ( VCR == None )
		return false;

	return VCR.IsMember(TestPRI, bNoCascade);
}

// Internal functions
simulated protected function VoiceChatRoom	CreateNewVoiceChannel(optional PlayerReplicationInfo PRI)
{
	local int i;

	if (PRI == None)
		return Spawn(ChatRoomClass, Self);

	for (i = 0; i < Channels.Length; i++)
		if (Channels[i].Owner == PRI)
			return Super.CreateNewVoiceChannel(PRI);

	return Spawn(ChatRoomClass, PRI);
}
simulated protected function DestroyVoiceChannel(VoiceChatRoom Channel)
{
	if (Channel != None)
	{
		Channel.Destroy();
		bRefresh = True;
	}
}

defaultproperties
{
     ChatRoomClass=Class'KFXGame.KFXVoiceChatRoom'
     DefaultChannel=1
}
