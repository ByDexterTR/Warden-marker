#include <sourcemod>
#include <sdktools>
#include <warden>
#include <multicolors>

#pragma semicolon 1
#pragma newdecls required

int g_Beam = -1, g_Halo = -1, g_MarkerColor[] =  { 0, 175, 255, 255 }, g_MarkerColorStat = 0, g_MarkerSpeed = 10, g_MarkerType = 0;
float g_MarkerPos[3], g_MarkerSize = 150.0, g_MarkerWidht = 3.0, g_MarkerAmplitude = 0.0;

public Plugin myinfo = 
{
	name = "Komutçu Marker", 
	author = "ByDexter", 
	description = "", 
	version = "1.0", 
	url = "https://steamcommunity.com/id/ByDexterTR - ByDexter#2947"
};

public void OnPluginStart()
{
	AddCommandListener(CommandListener_Marker, "+lookatweapon");
	CreateTimer(1.0, Timer_MarkerOlusturma, _, TIMER_REPEAT);
	RegConsoleCmd("sm_marker", Command_Marker);
	HookEvent("round_start", Event_DeleteMarker, EventHookMode_PostNoCopy);
	HookEvent("round_end", Event_DeleteMarker, EventHookMode_PostNoCopy);
}

public void OnMapStart()
{
	g_Beam = PrecacheModel("materials/sprites/laser_dexter.vmt");
	g_Halo = PrecacheModel("materials/sprites/halo.vmt");
	g_MarkerType = 0;
	PrecacheModel("materials/sprites/white.vmt");
	AddFileToDownloadsTable("materials/sprites/laser_dexter.vmt");
}

public Action CommandListener_Marker(int client, const char[] command, int argc)
{
	if (warden_iswarden(client) && IsPlayerAlive(client))
	{
		GetClientAimTargetPos(client, g_MarkerPos);
		g_MarkerPos[2] += 10.0;
	}
}

public Action Command_Marker(int client, int args)
{
	if (warden_iswarden(client))
	{
		Menu menu = new Menu(Menu_CallBack);
		menu.SetTitle("[ByDexter] Marker - Özellikleri ?\n ");
		if (g_MarkerSize == 100.0)
			menu.AddItem("Buyult", "Boyut: Small");
		else if (g_MarkerSize == 150.0)
			menu.AddItem("Buyult", "Boyut: Medium");
		else if (g_MarkerSize == 200.0)
			menu.AddItem("Buyult", "Boyut: Large");
		else if (g_MarkerSize == 250.0)
			menu.AddItem("Buyult", "Boyut: XLarge");
		else if (g_MarkerSize == 300.0)
			menu.AddItem("Buyult", "Boyut: XXLarge");
		if (g_MarkerColorStat == 0)
			menu.AddItem("RazerYap", "Renk: Mavi");
		else if (g_MarkerColorStat == 1)
			menu.AddItem("RazerYap", "Renk: Kırmızı");
		else if (g_MarkerColorStat == 2)
			menu.AddItem("RazerYap", "Renk: Yeşil");
		else if (g_MarkerColorStat == 3)
			menu.AddItem("RazerYap", "Renk: Sarı");
		else if (g_MarkerColorStat == 4)
			menu.AddItem("RazerYap", "Renk: Beyaz");
		else if (g_MarkerColorStat == 5)
			menu.AddItem("RazerYap", "Renk: Pembe");
		else if (g_MarkerColorStat == 6)
			menu.AddItem("RazerYap", "Renk: Gökkuşağı");
		if (g_MarkerWidht == 3.0)
			menu.AddItem("Kalinlastir", "Kalınlık: 3.0");
		else if (g_MarkerWidht == 5.0)
			menu.AddItem("Kalinlastir", "Kalınlık: 5.0");
		else if (g_MarkerWidht == 8.0)
			menu.AddItem("Kalinlastir", "Kalınlık: 8.0");
		else if (g_MarkerWidht == 10.0)
			menu.AddItem("Kalinlastir", "Kalınlık: 10.0");
		if (g_MarkerType == 0)
		{
			if (g_MarkerSpeed == 0)
				menu.AddItem("Akisyukselt", "Akış: Kapalı");
			else if (g_MarkerSpeed == 10)
				menu.AddItem("Akisyukselt", "Akış: Yavaş");
			else if (g_MarkerSpeed == 35)
				menu.AddItem("Akisyukselt", "Akış: Orta");
			else if (g_MarkerSpeed == 50)
				menu.AddItem("Akisyukselt", "Akış: Hızlı");
			else if (g_MarkerSpeed == 100)
				menu.AddItem("Akisyukselt", "Akış: Yüksek Dozlu");
		}
		else if (g_MarkerType == 1)
			menu.AddItem("Akisyukselt", "Akış: Devre dışı", ITEMDRAW_DISABLED);
		if (g_MarkerAmplitude == 0.0)
			menu.AddItem("Titresimyukselt", "Titreşim: Kapalı");
		else if (g_MarkerAmplitude == 1.0)
			menu.AddItem("Titresimyukselt", "Titreşim: Hafif");
		else if (g_MarkerAmplitude == 3.0)
			menu.AddItem("Titresimyukselt", "Titreşim: Orta");
		else if (g_MarkerAmplitude == 5.0)
			menu.AddItem("Titresimyukselt", "Titreşim: Yüksek");
		else if (g_MarkerAmplitude == 10.0)
			menu.AddItem("Titresimyukselt", "Titreşim: Yüksek Dozlu");
		if (g_MarkerType == 0)
			menu.AddItem("Gorunumdegis", "Görünüm: Işın");
		else if (g_MarkerType == 1)
			menu.AddItem("Gorunumdegis", "Görünüm: Pürüzsüz");
		menu.Display(client, MENU_TIME_FOREVER);
		return Plugin_Handled;
	}
	else
	{
		CReplyToCommand(client, "{green}[ByDexter] {default}Bu komutu sadece {blue}komutçu kullanabilir!");
		return Plugin_Handled;
	}
}

public int Menu_CallBack(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		if (IsPlayerAlive(param1))
		{
			char Item[32];
			menu.GetItem(param2, Item, sizeof(Item));
			if (StrEqual(Item, "Buyult", true))
			{
				if (g_MarkerSize == 100.0)
					g_MarkerSize = 150.0;
				else if (g_MarkerSize == 150.0)
					g_MarkerSize = 200.0;
				else if (g_MarkerSize == 200.0)
					g_MarkerSize = 250.0;
				else if (g_MarkerSize == 250.0)
					g_MarkerSize = 300.0;
				else if (g_MarkerSize == 300.0)
					g_MarkerSize = 100.0;
			}
			else if (StrEqual(Item, "RazerYap", true))
			{
				g_MarkerColorStat++;
				if (g_MarkerColorStat == 1)
					g_MarkerColor =  { 125, 50, 50, 255 };
				else if (g_MarkerColorStat == 2)
					g_MarkerColor =  { 0, 255, 0, 255 };
				else if (g_MarkerColorStat == 3)
					g_MarkerColor =  { 255, 251, 0, 255 };
				else if (g_MarkerColorStat == 4)
					g_MarkerColor =  { 255, 255, 255, 255 };
				else if (g_MarkerColorStat == 5)
					g_MarkerColor =  { 255, 0, 75, 255 };
				else if (g_MarkerColorStat == 7)
				{
					g_MarkerColorStat = 0;
					g_MarkerColor =  { 0, 175, 255, 255 };
				}
			}
			else if (StrEqual(Item, "Kalinlastir", true))
			{
				if (g_MarkerWidht == 3.0)
					g_MarkerWidht = 5.0;
				else if (g_MarkerWidht == 5.0)
					g_MarkerWidht = 8.0;
				else if (g_MarkerWidht == 8.0)
					g_MarkerWidht = 10.0;
				else if (g_MarkerWidht == 10.0)
					g_MarkerWidht = 3.0;
			}
			else if (StrEqual(Item, "Akisyukselt", true))
			{
				if (g_MarkerSpeed == 0)
					g_MarkerSpeed = 10;
				else if (g_MarkerSpeed == 10)
					g_MarkerSpeed = 35;
				else if (g_MarkerSpeed == 35)
					g_MarkerSpeed = 50;
				else if (g_MarkerSpeed == 50)
					g_MarkerSpeed = 100;
				else if (g_MarkerSpeed == 100)
					g_MarkerSpeed = 0;
			}
			else if (StrEqual(Item, "Titresimyukselt", true))
			{
				if (g_MarkerAmplitude == 0.0)
					g_MarkerAmplitude = 1.0;
				else if (g_MarkerAmplitude == 1.0)
					g_MarkerAmplitude = 3.0;
				else if (g_MarkerAmplitude == 3.0)
					g_MarkerAmplitude = 5.0;
				else if (g_MarkerAmplitude == 5.0)
					g_MarkerAmplitude = 10.0;
				else if (g_MarkerAmplitude == 10.0)
					g_MarkerAmplitude = 0.0;
			}
			else if (StrEqual(Item, "Gorunumdegis", true))
			{
				g_MarkerType++;
				if (g_MarkerType == 1)
					g_Beam = PrecacheModel("materials/sprites/white.vmt");
				else if (g_MarkerType == 2)
				{
					g_MarkerType = 0;
					g_Beam = PrecacheModel("materials/sprites/laser_dexter.vmt");
				}
			}
			Marker_Olustur();
			FakeClientCommand(param1, "sm_marker");
		}
		else
		{
			CReplyToCommand(param1, "{green}[ByDexter] {default}Ölü olduğun için {blue}ayarlar yapılmadı!");
			delete menu;
		}
	}
	else if (action == MenuAction_End)
		delete menu;
}

public Action Event_DeleteMarker(Event event, const char[] name, bool dontBroadcast)
{
	if (g_MarkerPos[0] == 0.0)
		return;
	Marker_Sifirla();
}

public Action Timer_MarkerOlusturma(Handle timer, any data)
{
	Marker_Olustur();
	return Plugin_Continue;
}

void Marker_Olustur()
{
	if (g_MarkerPos[0] == 0.0)
		return;
	if (g_MarkerColorStat == 6)
	{
		int G_Color[4];
		G_Color[0] = GetRandomInt(1, 255);
		G_Color[1] = GetRandomInt(1, 255);
		G_Color[2] = GetRandomInt(1, 255);
		G_Color[3] = 255;
		TE_SetupBeamRingPoint(g_MarkerPos, g_MarkerSize, g_MarkerSize + 0.1, g_Beam, g_Halo, 0, 10, 1.0, g_MarkerWidht, g_MarkerAmplitude, G_Color, g_MarkerSpeed, 0);
		
	}
	else if (g_MarkerColorStat != 6)
		TE_SetupBeamRingPoint(g_MarkerPos, g_MarkerSize, g_MarkerSize + 0.1, g_Beam, g_Halo, 0, 10, 1.0, g_MarkerWidht, g_MarkerAmplitude, g_MarkerColor, g_MarkerSpeed, 0);
	TE_SendToAll();
}

void Marker_Sifirla()
{
	for (int i = 0; i < 3; i++)
	g_MarkerPos[i] = 0.0;
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
	pos[2] += 5.0;
	int entity = TR_GetEntityIndex(trace);
	delete trace;
	return entity;
}

public bool TraceFilterAllEntities(int entity, int contentsMask, any client)
{
	if (entity == client)
		return false;
	if (entity > MaxClients)
		return false;
	if (!IsClientInGame(entity))
		return false;
	if (!IsPlayerAlive(entity))
		return false;
	return true;
} 