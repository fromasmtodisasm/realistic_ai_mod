
//////////////////////////////////////////////////////////////////////////
//
//	Crytek Source code
//	Copyright (c) Crytek 2001-2004
//
//	File: ProjectDefines.h
//  Description: To get some defines available in every CryEngine project.
//
//	History:
//	- 3/30/2004: File created by Martin Mittring
//	- February 2005: Modified by Marco Corbetta for SDK release
//
//////////////////////////////////////////////////////////////////////////

#ifndef PROJECTDEFINES_H
#define PROJECTDEFINES_H

#define GAME_IS_FARCRY
#define FARCRY_MOD_NAME "Mods/realistic_ai_mod"

#if defined(LINUX)

#if defined(LINUX64)
	#define NOT_USE_PUNKBUSTER_SDK
#endif
	#define _DATAPROBE
	#define NOT_USE_BINK_SDK					// mainly needed for licencees to compile without the Bink integration
	#define NOT_USE_DIVX_SDK					// mainly needed for licencees to compile without the DivX integration
	#define EXCLUDE_UBICOM_CLIENT_SDK			// to compile a standalone server without the client integration
#else

	#define _DATAPROBE
	#define NOT_USE_UBICOM_SDK					// mainly needed for licencees to compile without the UBI.com integration

	#define NOT_USE_PUNKBUSTER_SDK				// mainly needed for licencees to compile without the Punkbuster integration
	// #define NOT_USE_BINK_SDK	// Закомментировал.				// mainly needed for licencees to compile without the Bink integration
	// Ещё переделка в UIVideoPanel.cpp и, в UIDivX_Video.cpp
	#define NOT_USE_DIVX_SDK	// Теперь при убирании комментирования возвращаются ролики из папки мода. // Старое. При комментировании в UIDivX_Video.h пишет что #include <dsound.h> отсутствует // mainly needed for licencees to compile without the DivX integration
	#define NOT_USE_ASE_SDK						// mainly needed for licencees to compile without the ASE integration
	#define EXCLUDE_UBICOM_CLIENT_SDK			// to compile a standalone server without the client integration

#endif //LINUX

#endif // PROJECTDEFINES_H
