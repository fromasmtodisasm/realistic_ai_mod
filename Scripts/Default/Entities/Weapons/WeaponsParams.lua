-- MaxAmmo
MaxAmmo =
{
	Battery=100,
	Pistol=150,
	SMG=300,
	Assault=300,
	Sniper=30,
	Minigun=100,
	Shotgun=50,
	MortarShells=1,
	Grenades=3,
	HandGrenade=3,
	Rock=0,
	FlashbangGrenade=3,
	GlowStick=3,
	SmokeGrenade=3,
	FlareGrenade=3,
	Rocket=8,
	OICWGrenade=5,
	AG36Grenade=10,
	StickyExplosive=1,
	HealthPack=6,
	VehicleMG=1500, -- 1500 -- 500
	VehicleRocket=10,
	Stamina=9999999, -- ?
}

--aim_recoil_modifier=mulitplier applied to recoil ... 0=no recoil,1=original recoil,>1 more than original recoil
--min_accuracy=the worst the gun ever gets: 1=good,0=bad,(ending)
--max_accuracy=the best the gun ever gets: 1=good,0=bad,(starting)
--reload_time=
--fire_rate=seconds between rounds (pretty good now)
--distance=distance the shot travels
--damage=units of damage at end of first paratime
--damage_drop_per_meter=begns at beginning of second paratime,
--bullet_per_shot=1,
--min_recoil=The best it gets
--max_recoil=The worst it gets
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

WeaponsParams={
----------------------------------------------------------------------
--Falcon (Pistol/small cannon)
----------------------------------------------------------------------
	Falcon={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				BulletRejectType=BULLET_REJECT_TYPE_SINGLE,
				fire_mode_type=FireMode_Bullet,
				fire_activation=bor(FireActivation_OnPress),
				FModeActivationTime=0,
				AmmoType="Pistol",
				projectile_class="Bullet",
				damage_type="normal",
				hud_icon="single",
				HasCrosshair=1,
				aim_improvement=.03,
				aim_recoil_modifier=.5,
				accuracy_decay_on_run=.8,
				min_accuracy=.1, -- .75
				max_accuracy=.95, -- .90
				reload_time=1.62,
				fire_rate=.2,
				tap_fire_rate=.2,
				distance=170, -- Дистанция, на которую может пролететь воображаемая пуля.
				damage=300, -- Урон.
				damage_drop_per_meter=.008,
				bullet_per_shot=1,
				bullets_per_clip=15,
				min_recoil=2,
				max_recoil=2.5,
				iImpactForceMul=20,
				iImpactForceMulFinal=65.02,
				iImpactForceMulFinalTorso=130,
				accuracy_modifier_prone=.5,
				accuracy_modifier_crouch=.7,
				recoil_modifier_standing=1,
			},
			--MELEE FIRE-------------------------------------------------
			{
				fire_mode_type=FireMode_Melee,
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				FModeActivationTime=0,
				AmmoType="Unlimited",
				damage_type="normal",
				hud_icon="melee",
				no_ammo=1,
				no_zoom=1,
				mat_effect="melee_slash", -- Включает в себя звук и то, что остаётся на поверхности материала.
				shoot_underwater=1,
				min_accuracy=1,
				max_accuracy=1,
				damage=60,
				min_recoil=0,
				max_recoil=0,
				reload_time=.01,
				fire_rate=.9,
				distance=1.4,
				bullet_per_shot=1,
				bullets_per_clip=1,
				iImpactForceMul=80,
				iImpactForceMulFinal=80,
				no_reload=1,
			},
		},
	},
----------------------------------------------------------------------
--M4 (Assault rifle)
----------------------------------------------------------------------
	M4={
		--standard weapon params
		Std=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{
				BulletRejectType=BULLET_REJECT_TYPE_RAPID,
				-- fire_mode_type=FireMode_Instant,
				fire_mode_type=FireMode_Bullet,
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				FModeActivationTime=0,
				AmmoType="Assault",
				projectile_class="Bullet",
				damage_type="normal",
				hud_icon="auto",
				HasCrosshair=1,
				aim_improvement=.02, -- .04
				aim_recoil_modifier=.6,
				accuracy_decay_on_run=.5,
				min_accuracy=.50, -- .65 - 1 - точность при стрельбе, всегда точно.
				max_accuracy=.85, -- .93 - 1 - изначально точно, а при стрельбе, максимум, по параметру min_accuracy.
				reload_time=2.3,
				fire_rate=.082,
				distance=750,
				damage=300,
				damage_drop_per_meter=.008,
				bullet_per_shot=1,
				bullets_per_clip=30,
				-- recoil values
				min_recoil=0,
				max_recoil=.9,	-- its only a small recoil as more people seem to like it that way
				iImpactForceMul=20,
				iImpactForceMulFinal=45,
				iImpactForceMulFinalTorso=130,
				accuracy_modifier_prone=.5,
				accuracy_modifier_crouch=.7,
				recoil_modifier_standing=1,
				-- view shaking: weapon_viewshake is the frequency of the shake,
				-- weapon_viewshake_amt is optional: if not present will be used an ammount equal to (weapon_viewshake*.001)
				weapon_viewshake=6,
				weapon_viewshake_amt=.01,
			},
			--SINGLE SHOT-------------------------------------------------
			{
				BulletRejectType=BULLET_REJECT_TYPE_SINGLE,
				fire_mode_type=FireMode_Bullet,
				fire_activation=FireActivation_OnPress,
				FModeActivationTime=0,
				AmmoType="Assault",
				projectile_class="Bullet",
				damage_type="normal",
				hud_icon="single",
				HasCrosshair=1,
				aim_improvement=.03,
				aim_recoil_modifier=.5,
				accuracy_decay_on_run=.6,
				min_accuracy=.25, -- .65
				max_accuracy=.97,
				reload_time=2.3,
				fire_rate=.2,
				distance=750,
				damage=310,
				damage_drop_per_meter=.008,
				bullet_per_shot=1,
				bullets_per_clip=30,
				paratimes=2,
				angle_decay=10,		-- default 25
				-- more recoil,more power,travels further
				-- recoil values
				min_recoil=2,
				max_recoil=2.5, -- more recoil
				iImpactForceMul=10,
				iImpactForceMulFinal=45,
				iImpactForceMulFinalTorso=130,
				accuracy_modifier_prone=.5,
				accuracy_modifier_crouch=.7,
			    recoil_modifier_standing=1,
				-- ammo=120,
			},
		},
	},
----------------------------------------------------------------------
--AG36 (Assault rifle with grenade launcher)
----------------------------------------------------------------------
	AG36={
		Std=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{
				BulletRejectType=BULLET_REJECT_TYPE_RAPID,
				fire_mode_type=FireMode_Bullet,
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				FModeActivationTime=0,
				AmmoType="Assault",
				projectile_class="Bullet",
				damage_type="normal",
				hud_icon="auto",
				HasCrosshair=1,
				allow_hold_breath=1,
				aim_improvement=.06,
				aim_recoil_modifier=.6,
				accuracy_decay_on_run=.75,
				min_accuracy=.5,
				max_accuracy=1,
				reload_time=2.6,
				fire_rate=.1,
				distance=1100,
				damage=305,
				damage_drop_per_meter=.011,
				bullet_per_shot=1,
				bullets_per_clip=30,
				min_recoil=.3,
				max_recoil=.8,
				iImpactForceMul=20,
				iImpactForceMulFinal=65,
				iImpactForceMulFinalTorso=130,
				accuracy_modifier_prone=.5,
				accuracy_modifier_crouch=.7,
			    recoil_modifier_standing=1,
				weapon_viewshake=6.5,
				weapon_viewshake_amt=.01,
			},
			--GRENADE-----------------------------------------------------
			{
				fire_mode_type=FireMode_Projectile,
				fire_activation=FireActivation_OnPress,
				FModeActivationTime=0,
				AmmoType="AG36Grenade",
				projectile_class="AG36Grenade",
				damage_type="normal",
				hud_icon="grenade",
				HasCrosshair=1,
				no_zoom=1,
				reload_time=2.5,
				fire_rate=1,
				distance=50,
				bullet_per_shot=1,
				bullets_per_clip=1,
				DontUseWeaponOnMelee=8, -- Расстояние взял из параметра radius в таблице ExplosionParams снаряда.
			},
		},
	},
----------------------------------------------------------------------
--OICW (Assault rifle with 20mm secondary fire)
----------------------------------------------------------------------
	OICW={
		Std=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{
				BulletRejectType=BULLET_REJECT_TYPE_RAPID,
				fire_mode_type=FireMode_Bullet,
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				FModeActivationTime=0,
				AmmoType="Assault",
				projectile_class="Bullet",
				damage_type="normal",
				hud_icon="auto",
				HasCrosshair=1,
				allow_hold_breath=1, -- Проверить.
				aim_improvement=2, -- .06 Сжатие перекрестия в режиме прицела. Чем выше, тем всегда точнее.
				aim_recoil_modifier=.5, -- .6 Отдача (вверх) в режиме прицела.
				accuracy_decay_on_run=.35,
				min_accuracy=.7, -- .5 - 1 - точность при стрельбе, всегда точно.
				max_accuracy=1, -- .95 - 1 - изначально точно, а при стрельбе, максимум, по параметру min_accuracy.
				reload_time=2.02,
				fire_rate=.052, -- .05 (1200) 60/.052=1153 60/1153=.052 - это чтобы рассчитать скорострельнось, то есть нужно минуту (60 секунд) разделать на общее количество патронов в магазине.
				distance=1600,
				damage=330,
				damage_drop_per_meter=.007,
				bullet_per_shot=1,
				bullets_per_clip=20,
				-- recoil values
				min_recoil=0,
				max_recoil=.8,	-- its only a small recoil as more people seem to like it that way
				iImpactForceMul=20,
				iImpactForceMulFinal=100,
				iImpactForceMulFinalTorso=130,
				accuracy_modifier_prone=.5,
				accuracy_modifier_crouch=.7,
			    recoil_modifier_standing=1,
				weapon_viewshake=7,
				weapon_viewshake_amt=.01,
			},
			--grenade (not 20MM)-----------------------------------------------------
			{
				fire_mode_type=FireMode_Projectile,
				fire_activation=FireActivation_OnPress,
				FModeActivationTime=0,
				AmmoType="OICWGrenade",
				projectile_class="OICWGrenade",
				damage_type="normal",
				hud_icon="grenade",
				no_zoom=1,
				HasCrosshair=1,
				accuracy_decay_on_run=.8,
				min_accuracy=.65,
				max_accuracy=.99,
				reload_time=2.5,
				fire_rate=1,
				distance=100,
				damage=130,
				damage_drop_per_meter=.06,
				bullet_per_shot=1,
				bullets_per_clip=5,
				min_recoil=.5,
				max_recoil=1.2,
				DontUseWeaponOnMelee=12,
			},
		},
	},
----------------------------------------------------------------------
--MP5 (Sub machine gun)
----------------------------------------------------------------------
	MP5={

		--standard weapon params
		Std=
		{
		--AUTOMATIC FIRE----------------------------------------------
			{
				BulletRejectType=BULLET_REJECT_TYPE_RAPID,
				fire_mode_type=FireMode_Bullet,
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				FModeActivationTime=0,
				AmmoType="SMG",
				projectile_class="Bullet",
				damage_type="normal",
				hud_icon="auto",
				HasCrosshair=1,
				aim_improvement=.05, -- .05
				aim_recoil_modifier=.6,
				accuracy_decay_on_run=.5,
				min_accuracy=.50, -- .6 -- .8
				max_accuracy=.85, -- .92
				reload_time=2.6,
				fire_rate=.1,
				distance=300,
				damage=280,
				damage_drop_per_meter=.011, -- Больше потерь урона.
				bullet_per_shot=1,
				bullets_per_clip=30,
				min_recoil=0,
				max_recoil=1.5,	-- 2.1 default .6 its only a small recoil as more people seem to like it that way
				iImpactForceMul=20,
				iImpactForceMulFinal=45,
				iImpactForceMulFinalTorso=75,
				accuracy_modifier_prone=.5,
				accuracy_modifier_crouch=.7,
			    recoil_modifier_standing=1,
				--weapon_viewshake=2,
				--weapon_viewshake_amt=.01,

			},
			--SINGLE SHOT-------------------------------------------------
			{
				BulletRejectType=BULLET_REJECT_TYPE_SINGLE,
				fire_mode_type=FireMode_Bullet,
				fire_activation=FireActivation_OnPress,
				FModeActivationTime=0,
				AmmoType="SMG",
				projectile_class="Bullet",
				damage_type="normal",
				hud_icon="single",
				HasCrosshair=1,
				aim_improvement=.05,
				aim_recoil_modifier=.5,
				accuracy_decay_on_run=.8,
				min_accuracy=.8,
				max_accuracy=.95,
				reload_time=2.3,	-- default 2.8
				fire_rate=.2,
				distance=300,
				damage=290,
				damage_drop_per_meter=.011,
				bullet_per_shot=1,
				bullets_per_clip=30,
				min_recoil=2,
				max_recoil=2.5, -- more recoil
				iImpactForceMul=10,
				iImpactForceMulFinal=45,
				iImpactForceMulFinalTorso=75,
				accuracy_modifier_prone=.5,
				accuracy_modifier_crouch=.7,
			    recoil_modifier_standing=1,
				-- ammo=120,
			},
		},
	},
----------------------------------------------------------------------
--P90 (Sub machine gun)
----------------------------------------------------------------------
	P90={
		Std=
		{
			--AUTOMATIC FIRE----------------------------------------------
			{
				BulletRejectType=BULLET_REJECT_TYPE_RAPID,
				fire_mode_type=FireMode_Bullet,
				projectile_class="Bullet",
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				FModeActivationTime=0,
				AmmoType="SMG",
				projectile_class="Bullet",
				damage_type="normal",
				hud_icon="auto",
				HasCrosshair=1,
				aim_improvement=.01, -- .02
				aim_recoil_modifier=.6,
				accuracy_decay_on_run=.3,
				min_accuracy=.65, -- .75
				max_accuracy=.90, -- .90
				reload_time=2.6,
				fire_rate=.1,
				distance=100,
				damage=270,
				damage_drop_per_meter=.012,
				bullet_per_shot=1,
				bullets_per_clip=50,
				min_recoil=.3,
				max_recoil=.6,
				iImpactForceMul=20,
				iImpactForceMulFinal=45,
				iImpactForceMulFinalTorso=100,
				accuracy_modifier_prone=.5,
				accuracy_modifier_crouch=.7,
			    recoil_modifier_standing=1,
				weapon_viewshake=5,
				weapon_viewshake_amt=.01,
			},
		},
	},

----------------------------------------------------------------------
--SniperRifle (Sniper rifle/camping device)
----------------------------------------------------------------------
	SniperRifle={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				BulletRejectType=BULLET_REJECT_TYPE_SINGLE,
				fire_mode_type=FireMode_Projectile,
				fire_activation=FireActivation_OnPress,
				FModeActivationTime=0,
				AmmoType="Sniper",
				projectile_class="SniperBullet",
				damage_type="normal",
				allow_hold_breath=1,
				aim_improvement=.9,
				aim_recoil_modifier=.5,
				accuracy_decay_on_run=0,
				min_accuracy=.9,
				max_accuracy=.99,
				sprint_penalty=0,
				reload_time=2.5,
				fire_rate=1.35,
				distance=3500,
				damage=700, -- Пока что урон находится в параметрах пули...
				damage_drop_per_meter=.005,
				bullet_per_shot=1,
				bullets_per_clip=5,
				min_recoil=2.3,
				max_recoil=2.4,
				iImpactForceMul=20,
				iImpactForceMulFinal=120,
				iImpactForceMulFinalTorso=300,
				hud_icon="single",
				accuracy_modifier_prone=.5,
				accuracy_modifier_crouch=.7,
			    recoil_modifier_standing=1,
				accuracy_modifier_standing=.75,
			},
		},
	},
----------------------------------------------------------------------
--Shotgun (Semi automatic shotgun)
----------------------------------------------------------------------
	Shotgun={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				BulletRejectType=BULLET_REJECT_TYPE_SINGLE,
				fire_mode_type=FireMode_Bullet,
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				FModeActivationTime=0,
				AmmoType="Shotgun",
				projectile_class="Bullet",
				damage_type="normal",
				mat_effect="pancor_bullet_hit",
				hud_icon="auto",
				HasCrosshair=1,
				aim_improvement=.1,
				aim_recoil_modifier=.5,
				accuracy_decay_on_run=1,
				min_accuracy=.65,
				max_accuracy=.65,
				reload_time=2.4,
				fire_rate=.35, -- Реалистично.
				distance=110, -- 90
				damage=500,
				damage_drop_per_meter=.02,
				bullet_per_shot=5,
				bullets_per_clip=10,
				min_recoil=3,
				max_recoil=3,
				iImpactForceMul=25, -- 5 bullets divided by 10
				iImpactForceMulFinal=100, -- 5 bullets divided by 10
				iImpactForceMulFinalTorso=24,
				accuracy_modifier_prone=.5,
				accuracy_modifier_crouch=.7,
			    recoil_modifier_standing=1,
				weapon_viewshake=5,
				weapon_viewshake_amt=.02,
			},
		},
	},
----------------------------------------------------------------------
--M249 (Heavy machine gun)
----------------------------------------------------------------------
	M249={
		Std=
		{
			--AUTOMATIC FIRE-------------------------------------------------
			{
				fire_mode_type=FireMode_Bullet,
				FModeActivationTime=0,
				AmmoType="Assault",
				projectile_class="Bullet",
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				damage_type="normal",
				hud_icon="auto",
				HasCrosshair=1,
				aim_improvement=.02,
				aim_recoil_modifier=.8,
				accuracy_decay_on_run=.7,
				min_accuracy=.65, -- .75
				max_accuracy=.85,
				reload_time=3.3,
				fire_rate=.082,
				distance=1100,
				damage=300,
				damage_drop_per_meter=.004,
				bullet_per_shot=1,
				bullets_per_clip=100,
				min_recoil=.2,
				max_recoil=.3,
				iImpactForceMul=50,
				iImpactForceMulFinal=140,
				iImpactForceMulFinalTorso=100,
				accuracy_modifier_prone=.5,
				accuracy_modifier_crouch=.7,
				recoil_modifier_standing=1,
				weapon_viewshake=8,
				weapon_viewshake_amt=.01,
			},
		},
	},
----------------------------------------------------------------------
--Shocker (Purse weapon/women's self defence weapon)
----------------------------------------------------------------------
	Shocker={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type=FireMode_Melee,
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				FModeActivationTime=0,
				AmmoType="Unlimited",
				damage_type="normal",
				min_accuracy=1,
				max_accuracy=1,
				reload_time=.1,
				fire_rate=.3,
				distance=1.4,
				damage=200,
				--damage_drop_per_meter [doesn't apply]
				min_recoil=0,
				max_recoil=0,
				no_ammo=1,
				bullet_per_shot=1,
				bullets_per_clip=1,
				iImpactForceMul=0,
				iImpactForceMulFinal=0,
				no_reload=1,
			},
		},
	},
----------------------------------------------------------------------
--Machete (Butcher weapon)
----------------------------------------------------------------------
	Machete={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type=FireMode_Melee,
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				FModeActivationTime=0,
				AmmoType="Unlimited",
				damage_type="normal",
				mat_effect="melee_slash",
				shoot_underwater=1,
				min_accuracy=1,
				max_accuracy=1,
				fire_rate=.9,
				distance=1.4,
				damage=200,
				min_recoil=0,
				max_recoil=0,
				no_ammo=1,
				reload_time=.01,
				bullet_per_shot=1,
				bullets_per_clip=0,
				iImpactForceMul=80,
				iImpactForceMulFinal=80,
				no_reload=1,
			},
		},
	},

	Hands={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type=FireMode_Melee,
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				FModeActivationTime=0,
				AmmoType="Unlimited",
				damage_type="normal",
				mat_effect="melee_punch",
				shoot_underwater=1,
				min_accuracy=1,
				max_accuracy=1,
				fire_rate=.4,
				distance=1, -- Добавить ботам больше.
				damage=30,
				min_recoil=0,
				max_recoil=0,
				no_ammo=1,
				reload_time=.01,
				bullet_per_shot=1,
				bullets_per_clip=0,
				iImpactForceMul=200,
				iImpactForceMulFinal=80,
				no_reload=1,
			},
		},
	},
----------------------------------------------------------------------
--RL (Rocket Launcher)
----------------------------------------------------------------------
	RL={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type=FireMode_Projectile,
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				FModeActivationTime=0,
				damage_type="normal",
				hud_icon="rocket",
				AmmoType="Rocket",
				projectile_class="Rocket",
				reload_time=4.5,
				fire_rate=.5,
				bullet_per_shot=1,
				bullets_per_clip=4,
				iImpactForceMul=10,
				distance=10000, -- Для функции WeaponManger.
				DontUseWeaponOnMelee=20,
			},
		},
	},
----------------------------------------------------------------------
--COVERRL (Rocket Launcher used by AI)
----------------------------------------------------------------------
	COVERRL={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type=FireMode_Projectile,
				fire_activation=FireActivation_OnPress,
				FModeActivationTime=0,
				AmmoType="Unlimited",
				projectile_class="MutantRocket",
				damage_type="normal",
				reload_time=.3, -- default 3.82
				fire_rate=.3,
				HasCrosshair=1,
				-- ammo=130,
				bullet_per_shot=1,
				bullets_per_clip=1,
				iImpactForceMul=10,
				distance=10000, -- Для функции WeaponManger.
				DontUseWeaponOnMelee=5.5,
			},
		},
	},
----------------------------------------------------------------------
--MG (Mounted Machine Gun)
----------------------------------------------------------------------
	MG={
		Std=
		{
			{
				fire_mode_type=FireMode_Bullet,
				FModeActivationTime=0,
				AmmoType="Unlimited",
				projectile_class="BulletMG",
				damage_type="normal",
				mat_effect="mg_hit", -- Вряд ли для других MG подойдёт.
				hud_icon="auto",
				no_zoom=1,
				HasCrosshair=1,
				aim_improvement=.3,
				aim_recoil_modifier=.5,
				min_accuracy=.90, -- .85
				max_accuracy=1, -- .95
				reload_time=.1, -- default 2.8
				fire_rate=.010, -- .082 -- 60/.010=6000
				distance=3600,
				damage=350,
				damage_drop_per_meter=.2,
				bullet_per_shot=1,
				bullets_per_clip=1,
				min_recoil=0,
				max_recoil=.2,
				iImpactForceMul=50, -- 5 bullets divided by 10
				iImpactForceMulFinal=140,
				iImpactForceMulFinalTorso=130,
				weapon_viewshake=10,
				weapon_viewshake_amt=.01,
				no_ammo=1,
			},
		},
	},
----------------------------------------------------------------------
--Mortar (Mounted Grenade Launcher)
----------------------------------------------------------------------
	Mortar={
		Std=
		{
			{-- Сделать ещё один режим.
				FireOnRelease=1,
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnRelease), -- По моему, может быть и автоматическим.
				fire_mode_type=FireMode_Projectile,
				FModeActivationTime=0,
				AmmoType="Unlimited",
				projectile_class="MortarShell",
				damage_type="normal",
				hud_icon="single",
				no_ammo=1,
				HasCrosshair=1,
				min_accuracy=.75,
				max_accuracy=.95,
				reload_time=2,
				fire_rate=.6, -- 100
				distance=3000,
				damage=3000,
				damage_drop_per_meter=.2,
				bullet_per_shot=1,
				bullets_per_clip=1,
				min_recoil=0,
				max_recoil=0,
			},
			{
				FireOnRelease=1,
				FreeFire=1,
				fire_mode_type=FireMode_Projectile,
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				FModeActivationTime=0,
				AmmoType="Unlimited",
				projectile_class="MortarShell",
				damage_type="normal",
				hud_icon="auto",
				no_ammo=1,
				HasCrosshair=1,
				min_accuracy=.75,
				max_accuracy=.95,
				reload_time=2,
				fire_rate=.5, -- 100 .6 - .17
				distance=3000,
				damage=3000,
				damage_drop_per_meter=.2,
				bullet_per_shot=1,
				bullets_per_clip=1,
				min_recoil=0,
				max_recoil=0,

				-- aim_improvement=.04,
				-- aim_recoil_modifier=.6,
				-- accuracy_decay_on_run=.5,
				-- iImpactForceMul=20,
				-- iImpactForceMulFinal=45,
				-- iImpactForceMulFinalTorso=130,
				-- accuracy_modifier_prone=.5,
				-- accuracy_modifier_crouch=.7,
				-- recoil_modifier_standing=1,
				-- weapon_viewshake=6,
				-- weapon_viewshake_amt=.01,
			},
		},
	},
----------------------------------------------------------------------
--Mutant Shotgun (used by Mutant Big)
----------------------------------------------------------------------
	MutantShotgun={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				BulletRejectType=BULLET_REJECT_TYPE_SINGLE,
				fire_mode_type=FireMode_Bullet,
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				-- fire_activation=FireActivation_OnPress,
				FModeActivationTime=0,
				AmmoType="Shotgun",
				projectile_class="Bullet",
				damage_type="normal",
				mat_effect="pancor_bullet_hit",
				hud_icon="auto",
				HasCrosshair=1,
				aim_improvement=.1,
				aim_recoil_modifier=.5,
				accuracy_decay_on_run=1,
				min_accuracy=.65,
				max_accuracy=.65,
				reload_time=.3,
				fire_rate=.7,
				distance=110,
				damage=500,
				damage_drop_per_meter=.08,
				bullet_per_shot=5,
				bullets_per_clip=10,
				min_recoil=3,
				max_recoil=3,
				iImpactForceMul=25, -- 5 bullets divided by 10
				iImpactForceMulFinal=100, -- 5 bullets divided by 10
				iImpactForceMulFinalTorso=24,
				accuracy_modifier_prone=.5,
				accuracy_modifier_crouch=.7,
			    recoil_modifier_standing=1,
				weapon_viewshake=5,
				weapon_viewshake_amt=.02,
				-- ammo=98,
			},
		},
	},
----------------------------------------------------------------------
--Engineer Tool
----------------------------------------------------------------------
	EngineerTool={
		Std=
		{
			--BUILDING -------------------------------------------------
			{
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				fire_mode_type=FireMode_Melee,
				AmmoType="Unlimited",
				damage_type="building",
				mat_effect="building",
				min_accuracy=1,
				max_accuracy=1,
				reload_time=.01,
				fire_rate=.3,
				distance=1.4,		-- used to detect work range
				damage=160,
				min_recoil=0,
				max_recoil=0,
				no_ammo=1,
				bullet_per_shot=1,
				bullets_per_clip=20,
				FModeActivationTime=0,
				iImpactForceMul=80,
				iImpactForceMulFinal=80,
			},
		},
	},
----------------------------------------------------------------------
--Medic Tool
----------------------------------------------------------------------
	MedicTool={
		Std=
		{
			--DISTANCE-------------------------------------------------
			{
				fire_activation=bor(FireActivation_OnPress),
				fire_mode_type=FireMode_Projectile,
				FModeActivationTime=0,
				AmmoType="HealthPack",
				projectile_class="Health",
				damage_type="normal",
				aim_improvement=.2,
				accuracy_decay_on_run=.8,
				min_accuracy=.75,
				max_accuracy=.75,
				reload_time=3,
				fire_rate=3,
				distance=1.4,
				damage=-75, --50 								-- negative damage to heal
				bullet_per_shot=1,
				bullets_per_clip=1,
				min_recoil=.7,
				max_recoil=1,
				iImpactForceMul=80,
				iImpactForceMulFinal=80,
				iImpactForceMulFinalTorso=130,
				hud_icon="single",
				no_reload=1, --dont play player reload animation
				accuracy=1,
				no_ammo=1,
			},
		},
	},
---------------------------------------------------------------------
-- Wrench=Engineer Tool in melee attack
----------------------------------------------------------------------
	Wrench={
		Std=
		{
			--SINGLE FIRE-------------------------------------------------
			{
				fire_mode_type=FireMode_Melee,
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				FModeActivationTime=0,
				AmmoType="Unlimited",
				damage_type="normal",
				mat_effect="melee_slash",
				shoot_underwater=1,
				min_accuracy=1,
				max_accuracy=1,
				reload_time=.01,
				fire_rate=.9,		-- less than Machete
				distance=1.6,
				damage=50,			-- more than Machete
				--damage_drop_per_meter [doesn't apply]
				min_recoil=0,
				max_recoil=0,
				no_ammo=1,
				reload_time=.01,
				bullet_per_shot=1,
				bullets_per_clip=20,
				iImpactForceMul=80,
				iImpactForceMulFinal=80,
				accuracy=1,
				no_reload=1,
			},
		},

	--In multiplayer,if this table exist will be merged with the table above for the firemodes in common.
	Mp=
		{
				--AUTOMATIC FIRE IS BUILDING-------------------------------------------------
			{
				fire_mode_type=FireMode_Melee,
				damage_type="building",
				min_accuracy=1,
				max_accuracy=1,
				reload_time=.1,
				fire_rate=.6,
				distance=1.6,		-- used to detect work range
				damage=160,
				min_recoil=0,
				max_recoil=0,
				no_ammo=1,
				mat_effect="building",
			},
				--SINGLE FIRE IS SWINGING-------------------------------------------------
			{
				fire_mode_type=FireMode_Melee,
				damage_type="normal",
				min_accuracy=1,
				max_accuracy=1,
				reload_time=.1,
				fire_rate=1,		-- less than Machete
				distance=1.6,
				damage=50,			-- more than Machete
				--damage_drop_per_meter [doesn't apply]
				min_recoil=0,
				max_recoil=0,
				no_ammo=1,
				mat_effect="melee_slash",
			},
		},
	},
----------------------------------------------------------------------
--ScoutTool
----------------------------------------------------------------------
	ScoutTool={
		Std=
		{
			--place sticky explosive-----------------------------------------------------
			{
				fire_activation=FireActivation_OnPress,
				AmmoType="StickyExplosive",
				projectile_class="StickyExplosive",
				fire_mode_type=FireMode_Projectile,
				FModeActivationTime=0,
				damage_type="normal",
				no_reload=1, --dont play player reload animation
				accuracy_decay_on_run=.8,
				min_accuracy=.65,
				max_accuracy=.99,
				reload_time=2.5,
				fire_rate=1,
				distance=120,
				damage=800,
				damage_drop_per_meter=.06,
				bullet_per_shot=1,
				bullets_per_clip=1,
				min_recoil=.5,
				max_recoil=1.2,
				hud_icon="grenade",
			},
		},
	},
----------------------------------------------------------------------
--VehicleMountedMG (Mounted Machine Gun on vehicle)
----------------------------------------------------------------------
	VehicleMountedMG={ -- Когда сижу за пулемётом или когда человек на боевом вертолёте сидит и стреляет.
		Std=
		{
			{
				vehicleWeapon=1,
				fire_mode_type=FireMode_Bullet,
				FModeActivationTime=0,
				AmmoType="VehicleMG",
				-- AmmoType="Unlimited",
				projectile_class="BulletMG",
				damage_type="normal",
				mat_effect="mg_hit",
				hud_icon="auto",
				HasCrosshair=1,
				no_zoom=1,
				draw_thirdperson=1,
				auto_aiming_dist=0,
				aim_improvement=.3,
				aim_recoil_modifier=.5,
				min_accuracy=.85,
				max_accuracy=.95,
				reload_time=.1, -- 2.3
				fire_rate=.082,
				distance=3600,
				damage=500,
				damage_drop_per_meter=.004,
				bullet_per_shot=1,
				bullets_per_clip=500,
				min_recoil=0,
				max_recoil=0,
				iImpactForceMul=50,
				iImpactForceMulFinal=140,
				iImpactForceMulFinalTorso=130,
				weapon_viewshake=5,
				weapon_viewshake_amt=.01,
			},
			{
				vehicleWeapon=1,
				fire_mode_type=FireMode_Projectile,
				FModeActivationTime=0,
				AmmoType="VehicleRocket",
				projectile_class="VehicleRocket",
				damage_type="normal",
				reload_time=4.5,
				fire_rate=3.65,
				distance=10000, -- Для функции WeaponManger.
				hud_icon="rocket",
				HasCrosshair=1,
				no_zoom=1,
				draw_thirdperson=1,
				auto_aiming_dist=0,
				bullet_per_shot=1,
				bullets_per_clip=11, -- Сколько окажется патронов в магазине после перезарядки.
				iImpactForceMul=10,
				aim_improvement=.3,
				aim_recoil_modifier=.5,
				DontUseWeaponOnMelee=22,
			},
			{-- Копия первого блока.
				ai_mode=1, -- Убрать, как только получится устранить баг с пропадающими патронами при повторной посадке ИИ (ai_mode, в том числе, означает, что у ботов на этом оружии бесконечные патроны).
				vehicleWeapon=1,
				fire_mode_type=FireMode_Bullet,
				FModeActivationTime=0,
				AmmoType="Unlimited",
				projectile_class="BulletMG",
				damage_type="normal",
				mat_effect="mg_hit",
				hud_icon="auto",
				HasCrosshair=1,
				no_zoom=1,
				draw_thirdperson=1,
				auto_aiming_dist=0,
				aim_improvement=.3,
				aim_recoil_modifier=.5,
				min_accuracy=.85,
				max_accuracy=.95,
				reload_time=.1,
				fire_rate=.082,
				distance=3600,
				damage=500,
				damage_drop_per_meter=.004,
				bullet_per_shot=1,
				bullets_per_clip=500,
				min_recoil=0,
				max_recoil=0,
				iImpactForceMul=50,
				iImpactForceMulFinal=140,
				iImpactForceMulFinalTorso=130,
				weapon_viewshake=5,
				weapon_viewshake_amt=.01,
			},
			{
				ai_mode=1,
				vehicleWeapon=1,
				fire_mode_type=FireMode_Projectile,
				FModeActivationTime=0,
				AmmoType="Unlimited",
				projectile_class="VehicleRocket",
				damage_type="normal",
				reload_time=4.5,
				fire_rate=3.65,
				distance=10000, -- Для функции WeaponManger.
				hud_icon="rocket",
				HasCrosshair=1,
				no_zoom=1,
				draw_thirdperson=1,
				auto_aiming_dist=0,
				bullet_per_shot=1,
				bullets_per_clip=11,
				iImpactForceMul=10,
				aim_improvement=.3,
				aim_recoil_modifier=.5,
				DontUseWeaponOnMelee=22,
			},
		},
	},
----------------------------------------------------------------------
--VehicleMountedAutoMG (Mounted Machine Gun on vehicle with auto aiming)
----------------------------------------------------------------------
	VehicleMountedAutoMG={-- Когда сижу в багги за водительским креслом.
		Std=
		{
			{
				vehicleWeapon=1,
				fire_mode_type=FireMode_Bullet,
				FModeActivationTime=0,
				AmmoType="VehicleMG",
				projectile_class="BulletMG",
				damage_type="normal",
				mat_effect="mg_hit",
				hud_icon="auto",
				autoaim_sprite=System:LoadImage("Textures/hud/crosshair/roundcross.dds"),
				HasCrosshair=1,
				no_zoom=1,
				draw_thirdperson=1,
				auto_aiming_dist=25, -- 25
				aim_improvement=.3,
				aim_recoil_modifier=.5,
				min_accuracy=.85,
				max_accuracy=.95,
				reload_time=.1,
				fire_rate=.082,
				distance=3600,
				damage=500,
				damage_drop_per_meter=.004,
				bullet_per_shot=1,
				bullets_per_clip=500,
				min_recoil=0,
				max_recoil=0,
				iImpactForceMul=50,
				iImpactForceMulFinal=140,
				iImpactForceMulFinalTorso=130,
				weapon_viewshake=5,
				weapon_viewshake_amt=.01,
			},
			{-- Копия первого блока.
				ai_mode=1,
				vehicleWeapon=1,
				fire_mode_type=FireMode_Bullet,
				FModeActivationTime=0,
				AmmoType="Unlimited",
				projectile_class="BulletMG",
				damage_type="normal",
				mat_effect="mg_hit",
				hud_icon="auto",
				HasCrosshair=1,
				no_zoom=1,
				draw_thirdperson=1,
				auto_aiming_dist=0,
				aim_improvement=.3,
				aim_recoil_modifier=.5,
				min_accuracy=.85,
				max_accuracy=.95,
				reload_time=.1,
				fire_rate=.082,
				distance=3600,
				damage=500,
				damage_drop_per_meter=.004,
				bullet_per_shot=1,
				bullets_per_clip=500,
				min_recoil=0,
				max_recoil=0,
				iImpactForceMul=50,
				iImpactForceMulFinal=140,
				iImpactForceMulFinalTorso=130,
				weapon_viewshake=5,
				weapon_viewshake_amt=.01,
			},
		},
	},
----------------------------------------------------------------------
--VehicleMountedRocketMG (Mounted Machine Gun with a RocketLauncher firemode on vehicle)
----------------------------------------------------------------------
	VehicleMountedRocketMG={-- Когда сижу за водительским креслом.
		Std=
		{
			{-- Копия VehicleMountedMG.
				vehicleWeapon=1,
				fire_mode_type=FireMode_Bullet,
				FModeActivationTime=0,
				AmmoType="VehicleMG",
				projectile_class="BulletMG",
				damage_type="normal",
				mat_effect="mg_hit",
				hud_icon="auto",
				--filippo, its the autoaim reticule sprite, if this is not present will be used the classic square reticule.
				autoaim_sprite=System:LoadImage("Textures/hud/crosshair/roundcross.dds"),
				HasCrosshair=1,
				no_zoom=1,
				draw_thirdperson=1, -- Разрешает показывать прицел в режиме от третьего лица. Если auto_aiming_dist>0, хотя в оригинале и без этого отборажает.
				auto_aiming_dist=25, -- 25
				aim_improvement=.3,
				aim_recoil_modifier=.5,
				min_accuracy=.85,
				max_accuracy=.95,
				reload_time=.1,
				fire_rate=.082,
				distance=3600,
				damage=500,
				damage_drop_per_meter=.004,
				bullet_per_shot=1,
				bullets_per_clip=500,
				min_recoil=0,
				max_recoil=0,
				iImpactForceMul=50,
				iImpactForceMulFinal=140,
				iImpactForceMulFinalTorso=130,
				weapon_viewshake=5,
				weapon_viewshake_amt=.01,
			},
			{
				vehicleWeapon=1,
				fire_mode_type=FireMode_Projectile,
				FModeActivationTime=0,
				AmmoType="VehicleRocket",
				projectile_class="VehicleRocket",
				damage_type="normal",
				reload_time=4.5,
				fire_rate=3.65,
				distance=10000, -- Для функции WeaponManger.
				hud_icon="rocket",
				HasCrosshair=1,
				no_zoom=1,
				draw_thirdperson=1, -- Не помогает в этом режиме.
				auto_aiming_dist=0,
				bullet_per_shot=1,
				bullets_per_clip=11,
				iImpactForceMul=10,
				aim_improvement=.3,
				aim_recoil_modifier=.5,
				DontUseWeaponOnMelee=22,
			},
			{
				ai_mode=1,
				vehicleWeapon=1,
				fire_mode_type=FireMode_Bullet,
				FModeActivationTime=0,
				AmmoType="Unlimited",
				projectile_class="BulletMG",
				mat_effect="mg_hit",
				damage_type="normal",
				hud_icon="auto",
				HasCrosshair=1,
				no_zoom=1,
				draw_thirdperson=1,
				auto_aiming_dist=0,
				aim_improvement=.3,
				aim_recoil_modifier=.5,
				min_accuracy=.85,
				max_accuracy=.95,
				reload_time=.1,
				fire_rate=.082,
				distance=3600,
				damage=500,
				damage_drop_per_meter=.004,
				bullet_per_shot=1,
				bullets_per_clip=500,
				min_recoil=0,
				max_recoil=0,
				iImpactForceMul=50,
				iImpactForceMulFinal=140,
				iImpactForceMulFinalTorso=130,
				weapon_viewshake=5,
				weapon_viewshake_amt=.01,
			},
			{
				ai_mode=1,
				vehicleWeapon=1,
				fire_mode_type=FireMode_Projectile,
				FModeActivationTime=0,
				AmmoType="Unlimited",
				projectile_class="VehicleRocket",
				damage_type="normal",
				reload_time=4.5,
				fire_rate=3.65,
				distance=10000, -- Для функции WeaponManger.
				hud_icon="rocket",
				HasCrosshair=1,
				no_zoom=1,
				draw_thirdperson=1,
				auto_aiming_dist=0,
				bullet_per_shot=1,
				bullets_per_clip=11,
				iImpactForceMul=10,
				aim_improvement=.3,
				aim_recoil_modifier=.5,
				DontUseWeaponOnMelee=22,
			},
		},
	},
----------------------------------------------------------------------
--VehicleMountedRocket (Mounted dumb fire rockets on vehicle)
----------------------------------------------------------------------
	VehicleMountedRocket={-- Не знаю для чего.
		Std=
		{
			{
				vehicleWeapon=1,
				fire_mode_type=FireMode_Projectile,
				FModeActivationTime=0,
				AmmoType="VehicleRocket",
				projectile_class="VehicleRocket",
				damage_type="normal",
				reload_time=4.5,
				fire_rate=3.65,
				hud_icon="rocket",
				HasCrosshair=1,
				no_zoom=1,
				draw_thirdperson=1,
				auto_aiming_dist=0,
				bullet_per_shot=1,
				bullets_per_clip=11,
				iImpactForceMul=10,
				aim_improvement=.3,
				aim_recoil_modifier=.5,
			},
			{
				ai_mode=1,
				vehicleWeapon=1,
				fire_mode_type=FireMode_Projectile,
				FModeActivationTime=0,
				AmmoType="Unlimited",
				projectile_class="VehicleRocket",
				damage_type="normal",
				reload_time=4.5,
				fire_rate=3.65,
				hud_icon="rocket",
				HasCrosshair=1,
				no_zoom=1,
				draw_thirdperson=1,
				auto_aiming_dist=0,
				bullet_per_shot=1,
				bullets_per_clip=11,
				iImpactForceMul=10,
				aim_improvement=.3,
				aim_recoil_modifier=.5,
				DontUseWeaponOnMelee=22,
			},
		},
	},
----------------------------------------------------------------------
-- Special 'invisible' weapon for mutant big
----------------------------------------------------------------------
	MutantMG={
		Std=
		{
			{
				fire_mode_type=FireMode_Bullet,
				FModeActivationTime=0,
				AmmoType="Assault",
				-- ammo=122,
				projectile_class="Bullet",
				fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),
				damage_type="normal",
				mat_effect="mg_hit",
				hud_icon="auto",
				HasCrosshair=1,
				aim_improvement=.02,
				aim_recoil_modifier=.8,
				accuracy_decay_on_run=.7,
				min_accuracy=.75,
				max_accuracy=.85,
				reload_time=3.3,
				fire_rate=.082,
				distance=1100,
				damage=500,
				damage_drop_per_meter=.1,
				bullet_per_shot=1,
				bullets_per_clip=50,
				min_recoil=.2,
				max_recoil=.3,
				iImpactForceMul=50,
				iImpactForceMulFinal=140,
				iImpactForceMulFinalTorso=100,
				accuracy_modifier_prone=.5,
				accuracy_modifier_crouch=.7,
				recoil_modifier_standing=1,
				weapon_viewshake=8,
				weapon_viewshake_amt=.01,
			},
		},
	},
}

-- Короче, такой способ клонирования работает 50 на 50.
-- Table.Weapon={
	-- Std={{mode1: param1,param2,param3},{mode2: param1,param2,param3},{mode3: param1,param2,param3},},
	-- Mp={{mode1: param1,param2,param3},{mode2: param1,param2,param3},{mode3: param1,param2,param3},},
--},
-- Table.Weapon={Std={{mode1: param1,param2,param3},{mode2: param1,param2,param3},{mode3: param1,param2,param3},},Mp={{mode1: param1,param2,param3},{mode2: param1,param2,param3},{mode3: param1,param2,param3},},},

-- WeaponsParams.VehicleMountedMG.Std[3] = WeaponsParams.VehicleMountedMG.Std[1]
-- WeaponsParams.VehicleMountedMG.Std[3].ai_mode = 1
-- WeaponsParams.VehicleMountedMG.Std[3].AmmoType = "Unlimited"

-- System:Log("PROJECTILE: "..WeaponsParams.VehicleMountedMG.Std[3].projectile_class)

-- WeaponsParams.VehicleMountedAutoMG.Std[2] = WeaponsParams.VehicleMountedAutoMG.Std[1]
-- WeaponsParams.VehicleMountedAutoMG.Std[2].ai_mode = 1
-- WeaponsParams.VehicleMountedAutoMG.Std[2].AmmoType = "Unlimited"
