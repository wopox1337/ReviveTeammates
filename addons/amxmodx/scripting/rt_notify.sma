#include <amxmodx>
#include <rt_api>

enum CVARS
{
	NOTIFY_DHUD
};

new g_eCvars[CVARS];

new Float:g_fTime;

public plugin_init()
{
	register_plugin("Revive Teammates: Notify", VERSION, AUTHORS);

	register_dictionary("rt_library.txt");

	bind_pcvar_num(create_cvar("rt_notify_dhud", "1", FCVAR_NONE, "Notification under Timer(DHUD)", true, 0.0), g_eCvars[NOTIFY_DHUD]);
}

public plugin_cfg()
{
	UTIL_UploadConfigs();

	g_fTime = get_pcvar_float(get_cvar_pointer("rt_revive_time"));
}

public rt_revive_start(const id, const activator, const modes_struct:mode)
{
	new modes_struct:iMode = get_entvar(id, var_iuser3);

	if(iMode != MODE_PLANT)
	{
		switch(mode)
		{
			case MODE_REVIVE:
			{
				client_print_color(activator, print_team_blue, "%L %L", activator, "RT_CHAT_TAG", activator, "RT_TIMER_REVIVE", id);
			
				if(g_eCvars[NOTIFY_DHUD])
				{
					DisplayDHUDMessage(activator, fmt("%L", activator, "RT_DHUD_REVIVE", id), mode);
					DisplayDHUDMessage(id, fmt("%L %L", id, "RT_CHAT_TAG", id, "RT_DHUD_REVIVE2", activator), mode);
				}
			}
			case MODE_PLANT:
			{
				client_print_color(activator, print_team_blue, "%L %L", activator, "RT_CHAT_TAG", activator, "RT_TIMER_PLANT", id);

				if(g_eCvars[NOTIFY_DHUD])
				{
					DisplayDHUDMessage(activator, fmt("%L", activator, "RT_DHUD_PLANTING", id), mode);
				}
			}
		}
	}
}

public rt_revive_cancelled(const id, const activator, const modes_struct:mode)
{
	switch(mode)
	{
		case MODE_REVIVE:
		{
			client_print_color(activator, print_team_red, "%L %L", activator, "RT_CHAT_TAG", activator, "RT_CANCELLED_REVIVE", id);
		
		}
		case MODE_PLANT:
		{
			client_print_color(activator, print_team_red, "%L %L", activator, "RT_CHAT_TAG", activator, "RT_CANCELLED_PLANT", id);
		}
	}

	if(g_eCvars[NOTIFY_DHUD])
	{
		ClearDHUDMessages(activator);
		ClearDHUDMessages(id);
	}
}

public rt_revive_end(const id, const activator, const modes_struct:mode)
{
	switch(mode)
	{
		case MODE_REVIVE:
		{
			client_print_color(activator, print_team_blue, "%L %L", activator, "RT_CHAT_TAG", activator, "RT_REVIVE", id);
		
		}
		case MODE_PLANT:
		{
			client_print_color(activator, print_team_blue, "%L %L", activator, "RT_CHAT_TAG", activator, "RT_PLANTING", id);
		}
	}

	if(g_eCvars[NOTIFY_DHUD])
	{
		ClearDHUDMessages(activator);
		ClearDHUDMessages(id);
	}
}

stock DisplayDHUDMessage(id, szMessage[], modes_struct:mode)
{
	switch(mode)
	{
		case MODE_REVIVE:
		{
			set_dhudmessage(0, 255, 0, -1.0, 0.81, .holdtime = g_fTime);
		}
		case MODE_PLANT:
		{
			set_dhudmessage(255, 0, 0, -1.0, 0.81, .holdtime = g_fTime);
		}
	}

	show_dhudmessage(id, szMessage);
}

stock ClearDHUDMessages(id, iClear = 8)
{
	for(new i; i < iClear; i++)
	{
		show_dhudmessage(id, "");
	}
}