Class PBMarine_GaussSiegeDamageAndPuff : PBMarineFastProjectile{
	Default{
		Speed 4000;
		Radius 2;
		Height 2;
		RenderStyle "None";
		Decal "D4GaussPrimary";
		Damage(20);
		+RIPPER
		-CANNOTPUSH
		+NODAMAGETHRUST
		+EXTREMEDEATH
		+FORCERADIUSDMG
		DamageType "SSG";
		Obituary "%o was railed by %k.";
	}
	States
	{
	Spawn:
		TNT1 A 1;
		Loop;
	Death:
		TNT1 A 2 A_SpawnItemEx("GaussCannonPuffSiege",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION);
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_Explode(120,15);
		TNT1 A 0 A_SpawnItem("WhiteShockwave");
		TNT1 A 0 A_SpawnItemEx("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		TNT1 A 0 A_SpawnItemEx("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		TNT1 A 0 A_SpawnItemEx("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		TNT1 A 0 A_SpawnItemEx("RailgunImpactExplosionSFX", 0, 0, 0, 0, 0, 0, 0, 128);
		TNT1 A 0 A_CustomMissile("FireworkSFXType2", 0, 0, random(0, 360), 2, random(30, 60));
		TNT1 AA 0 A_CustomMissile("ExplosionParticleHeavy", 0, 0, random(0, 360), 2, random(0, 180));
		X005 ABCDEFGHIJKLMNOPQRSTUVWX 1 BRIGHT;
		TNT1 AAA 10 A_CustomMissile("BigBlackSmoke", 0, 0, random(0, 360), 2, random(40, 160));
		Stop;
	}
}
Class PBMarine_RailgunLaserBlast1 : PBMarineFastProjectile{
	default{
		Speed 300;
		Radius 12;
		Height 16;
		Damage 20;
		Renderstyle "Add";
		+RIPPER;
		-CANNOTPUSH;
		+NODAMAGETHRUST;
		+EXTREMEDEATH;
		+FORCERADIUSDMG;
		DamageType "Incinerate";
		DeathSound "";
		MissileType "LaserTrail"; //this is actually not needed anymore
		MissileHeight 10;
		Decal "BigScorch";
		DeathSound "belphegor/missile";
		Scale 1.5;
	}
	states
	{
		Spawn:
			TNT1 A 0 nodelay A_startsound("Weapons/StachanovFly",6,CHANF_LOOPING);
		Fly:
			TNT1 A 4;
			Loop;
		Death:
			TNT1 A 0;
			TNT1 A 0 A_StopSound(6);
			TNT1 A 0 A_startsound("Weapons/YamatoExp",5);
			TNT1 AAA 0 A_SpawnItemEx("ObeliskTrailSpark", random(19,-19), random(19,-19), random(19,-19), 0, 0, 0, 0, 128, 0);
			TNT1 A 0 A_SpawnItemEx("ObeliskExplode",0,0,0,0,0,0,0,128,0);
			TNT1 A 0 A_Explode(200,15,0,1);
			TNT1 A 0 A_SpawnItem("WhiteShockwave");
			TNT1 A 0 A_SpawnItemEx("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 A 0 A_SpawnItemEx("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
			TNT1 AAA 0 A_Spawnprojectile("FireworkSFXType2", 0, 0, random(0, 360), 2, random(-60, -30));
			EXPL AAA 0 A_Spawnprojectile("FlamethrowerFireParticles", 6, 0, random(0, 360), 2, random(-90,0));
			TNT1 AAA 0 A_Spawnprojectile("ExplosionParticleHeavy", 0, 0, random(0, 360), 2, random(-180,0));
			EXPL A 0 Radius_Quake(3, 120, 0, 120, 0);
			BEXP B 0 BRIGHT A_Scream();
			X001 ABCDEFGHIJKLMNOPQRSTUVWXYZ 1 BRIGHT;
			TNT1 AAA 10 A_Spawnprojectile("BigBlackSmoke", 0, 0, random(0, 360), 2, random(40, 160));
			stop;
	}
	
	override void Effect()
	{
		//copied from gzdoom.pk3/Zscript/Actors/Shared/Fastprojectile.zs
		//basically this is made to replace the actors trail for a lighter version with textured particles
		double hitz = pos.z - 8;
		if(hitz < floorz)
		{
			hitz = floorz;
		}
		// Do not clip this offset to the floor.
		hitz += MissileHeight;
		
		SpawnLaserTrail((pos.xy, hitz));
	}
	
	void SpawnLaserTrail(vector3 where)
	{
		FSpawnParticleParams LaserGun;
		LaserGun.Texture = TexMan.CheckForTexture("YAE4A0");
		LaserGun.Style = STYLE_ADD;
		LaserGun.Color1 = "FFFFFF";
		LaserGun.Flags =SPF_FULLBRIGHT|SPF_NOTIMEFREEZE;
		LaserGun.StartAlpha = 1.0;
		LaserGun.FadeStep = 0.25;
		LaserGun.Size = 10;
		LaserGun.SizeStep = -10;
		LaserGun.Lifetime = 10; 
		LaserGun.Pos = where;
		Level.SpawnParticle(LaserGun);
	}
}
Class PBMarine_RailgunWallPenetrationHitscan: PBMarineFastProjectile {
	Default{
		+RANDOMIZE
		+FORCEXYBILLBOARD
		+DONTSPLASH
		damage 0;
		radius 2;
		height 2;
		speed 900;
		renderstyle "Add";
		alpha 0.9;
		scale .3;
	}
	states{
		Spawn:
			TRAC A 1 BRIGHT;
			Loop;
		Death:
			TNT1 A 0;
			TNT1 A 0 A_CheckFloor("Nothing");
			TNT1 A 0 A_CheckCeiling("Nothing");
			tnt1 A 2;
			Stop;
			
		Nothing:
			TNT1 A 0;
			Stop;
			
		XDeath:
			TNT1 A 0;
			Stop;
	}
}
Class PBMarine_LaserCannon : PBMarine_RailgunLaserBlast1{
	Default{
	Speed 100;
	Radius 12;
	Height 8;
	Damage 0;
	Renderstyle "Add";
	// +RIPPER
	-CANNOTPUSH
	+NODAMAGETHRUST
	+EXTREMEDEATH
	+FORCERADIUSDMG
	DamageType "ExplosiveImpact";
	DeathSound "belphegor/missile";
	MissileType "PB_MarineLaserTrail";
	MissileHeight 10;
	Decal "BFGLightning";
	Decal "BigScorch";
	}
	states{
	Spawn:
		TNT1 A 0;
		TNT1 A 0 A_PlaySound("Weapons/StachanovFly",6,1.0,1);
		Fly:
		TNT1 A 6;
		Loop;
	Death:
		TNT1 A 0;
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_PlaySound("Weapons/YamatoExp",5);
		TNT1 AAAAA 0 A_SpawnItemEx("ObeliskTrailSpark", random(19,-19), random(19,-19), random(19,-19), 0, 0, 0, 0, 128, 0);
		TNT1 A 0 A_SpawnItemEx("ObeliskExplode",0,0,0,0,0,0,0,128,0);
		TNT1 A 0 A_Explode(200,250,0,1);
		TNT1 A 0 A_SpawnItemEx("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		TNT1 A 0 A_SpawnItemEx("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		TNT1 A 0 A_SpawnItemEx("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		TNT1 A 0 A_CustomMissile("ExcavatorExploFX", random(1,5), random(-10,10), random(0, 360), 2, random(0, 360));
		TNT1 AAA 0 A_CustomMissile("FireworkSFXType2", 0, 0, random(0, 360), 2, random(30, 60));
		EXPL AAA 0 A_CustomMissile("FlamethrowerFireParticles", 6, 0, random(0, 360), 2, random(0, 90));
		TNT1 AAAAAAAAAAA 0 A_CustomMissile("ExplosionParticleHeavy", 0, 0, random(0, 360), 2, random(0, 180));
		TNT1 AAAAAA 0 A_CustomMissile("ExplosionParticleHeavy", 0, 0, random(0, 360), 2, random(0, 180));
		EXPL A 0 Radius_Quake(3, 120, 0, 120, 0);
		BEXP B 0 BRIGHT A_Scream;
		EXP1 ABCDEFGHIJKLMN 2 BRIGHT;
		stop;
	}
}
Class PBMarine_RailProjectile : PBMarine_RailgunLaserBlast1{
	Default{
		Speed 100;
		Radius 12;
		Height 8;
		Damage 0;
		Renderstyle "Add";
		// +RIPPER
		-CANNOTPUSH
		+NODAMAGETHRUST
		+EXTREMEDEATH
		+FORCERADIUSDMG
		DamageType "ExplosiveImpact";
		DeathSound "belphegor/missile";
		MissileType "PB_MarineRailTrail2";
		MissileHeight 10;
		Decal "BFGLightning";
		Decal "BigScorch";
	}
	states{
	Spawn:
		TNT1 A 0;
		TNT1 A 0 A_PlaySound("Weapons/StachanovFly",6,1.0,1);
		Fly:
		TNT1 A 6;
		Loop;
	Death:
		TNT1 A 0;
		TNT1 A 0 A_StopSound(6);
		TNT1 A 0 A_PlaySound("Weapons/YamatoExp",5);
		TNT1 AAAAA 0 A_SpawnItemEx("ObeliskTrailSpark", random(19,-19), random(19,-19), random(19,-19), 0, 0, 0, 0, 128, 0);
		TNT1 A 0 A_SpawnItemEx("ObeliskExplode",0,0,0,0,0,0,0,128,0);
		TNT1 A 0 A_Explode(200,250,0,1);
		TNT1 A 0 A_SpawnItemEx("DetectFloorCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		TNT1 A 0 A_SpawnItemEx("DetectCeilCrater",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		TNT1 A 0 A_SpawnItemEx("ExplosionFlareSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
		TNT1 A 0 A_CustomMissile("ExcavatorExploFX", random(1,5), random(-10,10), random(0, 360), 2, random(0, 360));
		TNT1 AAA 0 A_CustomMissile("FireworkSFXType2", 0, 0, random(0, 360), 2, random(30, 60));
		EXPL AAA 0 A_CustomMissile("FlamethrowerFireParticles", 6, 0, random(0, 360), 2, random(0, 90));
		TNT1 AAAAAAAAAAA 0 A_CustomMissile("ExplosionParticleHeavy", 0, 0, random(0, 360), 2, random(0, 180));
		TNT1 AAAAAA 0 A_CustomMissile("ExplosionParticleHeavy", 0, 0, random(0, 360), 2, random(0, 180));
		EXPL A 0 Radius_Quake(3, 120, 0, 120, 0);
		BEXP B 0 BRIGHT A_Scream;
		EXP1 ABCDEFGHIJKLMN 2 BRIGHT;
		stop;
	}
	override void Effect()
	{
		//copied from gzdoom.pk3/Zscript/Actors/Shared/Fastprojectile.zs
		//basically this is made to replace the actors trail for a lighter version with textured particles
		double hitz = pos.z - 8;
		if(hitz < floorz)
		{
			hitz = floorz;
		}
		// Do not clip this offset to the floor.
		hitz += MissileHeight;
		
		SpawnLaserTrail((pos.xy, hitz));
	}
	
	void SpawnLaserTrail(vector3 where)
	{
		FSpawnParticleParams LaserGun;
		LaserGun.Texture = TexMan.CheckForTexture("YAE5A0");
		LaserGun.Style = STYLE_ADD;
		LaserGun.Color1 = "FFFFFF";
		LaserGun.Flags =SPF_FULLBRIGHT|SPF_NOTIMEFREEZE;
		LaserGun.StartAlpha = 1.0;
		LaserGun.FadeStep = 0.25;
		LaserGun.Size = 10;
		LaserGun.SizeStep = -10;
		LaserGun.Lifetime = 10; 
		LaserGun.Pos = where;
		Level.SpawnParticle(LaserGun);
	}
}
Class PB_MarineRailTrail2 : actor{
	Default{
	RenderStyle "Add";
	Scale 0.11;
	Alpha 0.9;
	+NOINTERACTION
	+NOGRAVITY
	//Translation "[256,0,0]:[0,0,0]=[64,64,256]:[0,0,0]";
		//+CLIENTSIDEONLY
	}
	States{
	Spawn:
		TNT1 A 0;
		YAE5 A 3 bright; //A_SpawnItemEx("ObeliskTrailSpark", random(4,-4), random(4,-4), random(4,-4), 0, 0, 0, 0, 128, 0)
		YAE5 A 3 bright;
	Trolololo:
	 // YAE4 A 0 A_JumpIf(ScaleY <= 0, "NULL")
		YAE5 A 1 bright {A_SetScale(ScaleX -0.01, ScaleY -0.01);A_FadeOut(0.1);}
		Wait;
	}
}
Class PB_MarineLaserTrail : actor{
	Default{
	RenderStyle "Add";
	Scale 0.11;
	Alpha 0.9;
	+NOINTERACTION
	+NOGRAVITY
		//+CLIENTSIDEONLY
	}
	States{
	Spawn:
		TNT1 A 0;
		YAE4 A 3 bright; //A_SpawnItemEx("ObeliskTrailSpark", random(4,-4), random(4,-4), random(4,-4), 0, 0, 0, 0, 128, 0)
		YAE4 A 3 bright;
	Trolololo:
	 // YAE4 A 0 A_JumpIf(ScaleY <= 0, "NULL")
		YAE4 A 0 A_SetScale(ScaleX -0.01, ScaleY -0.01);
		YAE4 A 1 bright A_FadeOut(0.1);
		Loop;
	}
}