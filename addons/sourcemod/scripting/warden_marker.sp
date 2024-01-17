#include <sourcemod>
#include <sdktools>
#include <warden>

#pragma semicolon 1
#pragma newdecls required

int g_Beam = -1, g_Halo = -1, g_MarkerColor[] = { 0, 175, 255, 255 }, g_MarkerColorStat = 0, g_MarkerSpeed = 10, g_MarkerType = 0, g_MarkerNum = 1;
float g_MarkerPos[3], g_MarkerSize = 150.0, g_MarkerWidht = 3.0, g_MarkerAmplitude = 0.0, g_MarkerHeight = 16.0, g_MarkerBase[3];

public Plugin myinfo = 
{
	name = "Komutçu Marker", 
	author = "ByDexter", 
	description = "", 
	version = "1.3b", 
	url = "https://steamcommunity.com/id/ByDexterTR - ByDexter#5494"
};

public void OnPluginStart()
{
	LoadTranslations("wardenmarker.phrases");
	AddCommandListener(CommandListener_Marker, "+lookatweapon");
	RegConsoleCmd("sm_marker", Command_Marker);
	HookEvent("round_start", OnRoundStart, EventHookMode_PostNoCopy);
}

public void OnMapStart()
{
	PrecacheModel("materials/marker/white.vmt", true);
	PrecacheModel("materials/marker/laserbeam.vmt", true);
	PrecacheModel("materials/marker/white_norez.vmt", true);
	PrecacheModel("materials/marker/laser_dexter.vmt", true);
	
	g_MarkerType = 0;
	g_Beam = PrecacheModel("materials/marker/laser_dexter.vmt", true);
	g_Halo = PrecacheModel("materials/marker/light_glow02.vmt", true);
	
	AddFileToDownloadsTable("materials/marker/light_glow02.vmt");
	AddFileToDownloadsTable("materials/marker/light_glow02.vtf");
	AddFileToDownloadsTable("materials/marker/laser_dexter.vmt");
	AddFileToDownloadsTable("materials/marker/laserbeam.vmt");
	AddFileToDownloadsTable("materials/marker/laserbeam.vtf");
	AddFileToDownloadsTable("materials/marker/white.vmt");
	AddFileToDownloadsTable("materials/marker/white.vtf");
	AddFileToDownloadsTable("materials/marker/white_norez.vmt");
	
	CreateTimer(1.0, Timer_MarkerOlusturma, _, TIMER_FLAG_NO_MAPCHANGE | TIMER_REPEAT);
}

public Action CommandListener_Marker(int client, const char[] command, int argc)
{
	if (warden_iswarden(client))
	{
		GetClientAimTargetPos(client, g_MarkerPos);
		g_MarkerPos[2] += 16.0;
	}
	return Plugin_Continue;
}

public Action Command_Marker(int client, int args)
{
	if (!warden_iswarden(client))
	{
		ReplyToCommand(client, "[SM] %t", "Access Menu");
		return Plugin_Handled;
	}
	
	Warden_Marker().Display(client, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

Menu Warden_Marker()
{
	char mformat[32];
	Menu menu = new Menu(Menu_CallBack);
	menu.SetTitle("▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\n   ★ Marker ★\n▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬");
	
	if (g_MarkerSize == 100.0)
		Format(mformat, 32, "%t S", "Marker Size");
	else if (g_MarkerSize == 150.0)
		Format(mformat, 32, "%t M", "Marker Size");
	else if (g_MarkerSize == 200.0)
		Format(mformat, 32, "%t L", "Marker Size");
	else if (g_MarkerSize == 250.0)
		Format(mformat, 32, "%t XL", "Marker Size");
	else if (g_MarkerSize == 300.0)
		Format(mformat, 32, "%t XXL", "Marker Size");
	
	menu.AddItem("1", mformat);
	
	if (g_MarkerColorStat == 0)
		Format(mformat, 32, "%t B", "Marker Color");
	else if (g_MarkerColorStat == 1)
		Format(mformat, 32, "%t R", "Marker Color");
	else if (g_MarkerColorStat == 2)
		Format(mformat, 32, "%t G", "Marker Color");
	else if (g_MarkerColorStat == 3)
		Format(mformat, 32, "%t Y", "Marker Color");
	else if (g_MarkerColorStat == 4)
		Format(mformat, 32, "%t W", "Marker Color");
	else if (g_MarkerColorStat == 5)
		Format(mformat, 32, "%t P", "Marker Color");
	else if (g_MarkerColorStat == 6)
		Format(mformat, 32, "%t RGB", "Marker Color");
	
	menu.AddItem("2", mformat);
	
	if (g_MarkerWidht == 2.0)
		Format(mformat, 32, "%t 2", "Marker Widht");
	else if (g_MarkerWidht == 4.0)
		Format(mformat, 32, "%t 4", "Marker Widht");
	else if (g_MarkerWidht == 6.0)
		Format(mformat, 32, "%t 6", "Marker Widht");
	else if (g_MarkerWidht == 8.0)
		Format(mformat, 32, "%t 8", "Marker Widht");
	else if (g_MarkerWidht == 10.0)
		Format(mformat, 32, "%t 10", "Marker Widht");
	
	menu.AddItem("3", mformat);
	
	if (g_MarkerType == 0 || g_MarkerType == 2)
	{
		if (g_MarkerSpeed == 0)
			Format(mformat, 32, "%t 0", "Marker Flow");
		else if (g_MarkerSpeed == 25)
			Format(mformat, 32, "%t 25", "Marker Flow");
		else if (g_MarkerSpeed == 50)
			Format(mformat, 32, "%t 50", "Marker Flow");
		else if (g_MarkerSpeed == 75)
			Format(mformat, 32, "%t 75", "Marker Flow");
		else if (g_MarkerSpeed == 100)
			Format(mformat, 32, "%t 100", "Marker Flow");
		
		menu.AddItem("4", mformat);
	}
	else if (g_MarkerType == 1 || g_MarkerType == 3)
	{
		Format(mformat, 32, "%t 𝕏", "Marker Flow");
		menu.AddItem("4", mformat, ITEMDRAW_DISABLED);
	}
	
	if (g_MarkerAmplitude == 0.0)
		Format(mformat, 32, "%t 0", "Marker Amplitude");
	else if (g_MarkerAmplitude == 2.0)
		Format(mformat, 32, "%t 2", "Marker Amplitude");
	else if (g_MarkerAmplitude == 4.0)
		Format(mformat, 32, "%t 4", "Marker Amplitude");
	else if (g_MarkerAmplitude == 6.0)
		Format(mformat, 32, "%t 6", "Marker Amplitude");
	else if (g_MarkerAmplitude == 8.0)
		Format(mformat, 32, "%t 8", "Marker Amplitude");
	else if (g_MarkerAmplitude == 10.0)
		Format(mformat, 32, "%t 10", "Marker Amplitude");
	
	menu.AddItem("5", mformat);
	
	if (g_MarkerType == 0)
		Format(mformat, 32, "%t Fluorescent (WH)", "Marker Type");
	else if (g_MarkerType == 1)
		Format(mformat, 32, "%t LED (WH)", "Marker Type");
	else if (g_MarkerType == 2)
		Format(mformat, 32, "%t Fluorescent", "Marker Type");
	else if (g_MarkerType == 3)
		Format(mformat, 32, "%t LED", "Marker Type");
	
	menu.AddItem("6", mformat);
	
	if (g_MarkerNum == 1)
		menu.AddItem("7", "Marker: 1");
	else if (g_MarkerNum == 2)
		menu.AddItem("7", "Marker: 2");
	else if (g_MarkerNum == 3)
		menu.AddItem("7", "Marker: 3");
	
	menu.AddItem("7", mformat);
	
	if (g_MarkerNum == 1)
	{
		Format(mformat, 32, "%t 𝕏", "Marker Height Distance");
		menu.AddItem("8", mformat, ITEMDRAW_DISABLED);
	}
	else
	{
		if (g_MarkerHeight == 16.0)
			Format(mformat, 32, "%t S", "Marker Height Distance");
		else if (g_MarkerHeight == 20.0)
			Format(mformat, 32, "%t M", "Marker Height Distance");
		else if (g_MarkerHeight == 24.0)
			Format(mformat, 32, "%t L", "Marker Height Distance");
		else if (g_MarkerHeight == 32.0)
			Format(mformat, 32, "%t XL", "Marker Height Distance");
		
		menu.AddItem("8", mformat);
	}
	return menu;
}

public int Menu_CallBack(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		if (warden_iswarden(param1))
		{
			char Item[4];
			menu.GetItem(param2, Item, sizeof(Item));
			int item = StringToInt(Item);
			if (item == 1)
			{
				g_MarkerSize = (g_MarkerSize == 300.0) ? 100.0 : g_MarkerSize + 50.0;
			}
			else if (item == 2)
			{
				g_MarkerColorStat++;
				if (g_MarkerColorStat == 1)
					g_MarkerColor = { 255, 50, 50, 255 };
				else if (g_MarkerColorStat == 2)
					g_MarkerColor = { 0, 255, 0, 255 };
				else if (g_MarkerColorStat == 3)
					g_MarkerColor = { 255, 251, 0, 255 };
				else if (g_MarkerColorStat == 4)
					g_MarkerColor = { 255, 255, 255, 255 };
				else if (g_MarkerColorStat == 5)
					g_MarkerColor = { 255, 0, 75, 255 };
				else if (g_MarkerColorStat == 7)
				{
					g_MarkerColorStat = 0;
					g_MarkerColor = { 0, 175, 255, 255 };
				}
			}
			else if (item == 3)
			{
				g_MarkerWidht = (g_MarkerWidht == 10.0) ? 2.0 : g_MarkerWidht + 2.0;
			}
			else if (item == 4)
			{
				g_MarkerSpeed = (g_MarkerSpeed == 100) ? 0 : g_MarkerSpeed + 25;
			}
			else if (item == 5)
			{
				g_MarkerAmplitude = (g_MarkerAmplitude == 10.0) ? 0.0 : g_MarkerAmplitude + 2.0;
			}
			else if (item == 6)
			{
				g_MarkerType++;
				if (g_MarkerType == 1)
					g_Beam = PrecacheModel("materials/marker/white.vmt", true);
				else if (g_MarkerType == 2)
					g_Beam = PrecacheModel("materials/marker/laserbeam.vmt", true);
				else if (g_MarkerType == 3)
					g_Beam = PrecacheModel("materials/marker/white_norez.vmt", true);
				else if (g_MarkerType == 4)
				{
					g_MarkerType = 0;
					g_Beam = PrecacheModel("materials/marker/laser_dexter.vmt", true);
				}
			}
			else if (item == 7)
			{
				g_MarkerNum = (g_MarkerNum == 4 || g_MarkerNum == 0) ? 1 : g_MarkerNum + 1;
			}
			else if (item == 8)
			{
				g_MarkerHeight = (g_MarkerHeight == 32.0) ? 16.0 : g_MarkerHeight + 4.0;
			}
			Warden_Marker().Display(param1, MENU_TIME_FOREVER);
		}
		else
		{
			PrintToChat(param1, "[SM] %t", "Access Menu");
		}
	}
	else if (action == MenuAction_End)
		delete menu;
	return 0;
}

public Action OnRoundStart(Event event, const char[] name, bool dontBroadcast)
{
	for (int i = 0; i < 3; i++)g_MarkerPos[i] = 0.0;
	return Plugin_Continue;
}

public Action Timer_MarkerOlusturma(Handle timer, any data)
{
	if (g_MarkerPos[0] != 0.0)
	{
		int markerCount = (g_MarkerNum == 1) ? 1 : ((g_MarkerNum == 2) ? 2 : 3);
		int G_Color[4];
		
		if (g_MarkerColorStat == 6)
		{
			G_Color[0] = GetRandomInt(1, 255);
			G_Color[1] = GetRandomInt(1, 255);
			G_Color[2] = GetRandomInt(1, 255);
			G_Color[3] = 255;
		}
		
		for (int i = 0; i < markerCount; ++i)
		{
			TE_SetupBeamRingPoint(g_MarkerPos, g_MarkerSize, g_MarkerSize + 0.1, g_Beam, g_Halo, 0, 10, 1.0, g_MarkerWidht, g_MarkerAmplitude, g_MarkerColorStat == 6 ? G_Color : g_MarkerColor, g_MarkerSpeed, 0);
			TE_SendToAll();
			if (i < markerCount - 1)
				g_MarkerPos[2] += g_MarkerHeight;
		}
		
		if (g_MarkerNum != 1)
			g_MarkerPos[2] = g_MarkerBase[2];
	}
	return Plugin_Continue;
}

int GetClientAimTargetPos(int client, float pos[3])
{
	if (!client)
		return -1;
	float vAngles[3]; float vOrigin[3];
	GetClientEyePosition(client, vOrigin);
	GetClientEyeAngles(client, vAngles);
	Handle trace = TR_TraceRayFilterEx(vOrigin, vAngles, MASK_SHOT, RayType_Infinite, TraceFilterAllEntities, client);
	TR_GetEndPosition(pos, trace);
	int entity = TR_GetEntityIndex(trace);
	delete trace;
	return entity;
}

public bool TraceFilterAllEntities(int entity, int contentsMask, any client) { return (entity != client) && (entity <= MaxClients) && IsClientInGame(entity) && IsPlayerAlive(entity); } 