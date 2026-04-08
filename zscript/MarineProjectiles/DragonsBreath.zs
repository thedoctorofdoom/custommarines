Class PBMarine_DragonsBreathTracer : PB_DragonsBreathTracer{
	Default{
		Species "Marines";
		+THRUSPECIES
		+MTHRUSPECIES
		+DONTHARMSPECIES
	}
	mixin PB_HitHandler;
	override int DoSpecialDamage(Actor victim, int damage, Name damagetype){return CM_Damage(victim, damage, damagetype);}
	override int SpecialMissileHit(Actor victim){return CM_ProjHit(victim);}
	override void OnHitActor(Actor target, Name dmgType)
	{
		if(pos.z < floorz)
			SetZ(floorz);
		A_Explode(3, 30, 0);
		A_Spawnitem("PBMarine_DragonBreath");
		spawnflameFlare(pos,true);
		SpawnImpactFx();
	}
	override void OnExplode(int type)
	{
		if(pos.z < floorz)
			SetZ(floorz);
		A_Explode(3, 30, 0);
		A_Spawnitem("PBMarine_DragonBreath");
		spawnflameFlare(pos,true);
		SpawnImpactFx();
	}
}

//this is basically just a port of the one in decorate
Class PBMarine_DragonBreath : PBMarineProjectile{
	default{
		Projectile;
		+RANDOMIZE;
		+FORCEXYBILLBOARD;
		+RIPPER;
		+NOEXTREMEDEATH;
		damage 1;
		radius 1;
		height 1;
		speed 40;
		renderstyle "ADD";
		alpha 0.9;
		scale .15;
		DamageType "Fire";
		SeeSound "Afrit/Hellfire";
		Decal "SmallerScorch";
	}
	states
		{
			Spawn:
				TNT1 A 0 nodelay A_Startsound("Afrit/Hellfire");
				TNT1 A 0 A_Explode(10,66,0);
				//TNT1 AAAA 0 A_SpawnItemEx("DragonsBreathFlare",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				EXPL A 0 A_SpawnItemEx("ExplosionParticleSpawner",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION,0);
				//EXPL AAAAAAAAAAA 0 A_CustomMissile("ShotgunParticles", 6, 0, random(0, 360), 2, random(0, 90));//ShotgunParticles
				TNT1 A 0 A_Jump(76, 2, 3,4);
			TNT1 A 0 A_SpawnItemEx("FireworkSFXType2", random(-15, 15), random(-15, 15));
			TNT1 A 0 A_Spawnprojectile("FireworkSFXType2", 0, 0, random(0, 360), 2, random(-60, -30));
			TNT1 A 0 A_SpawnItemEx("FireworkSFXType2", random(-35, 35), random(-35, 35));
			TNT1 A 0 A_SpawnItemEx("FireworkSFXType2", random(-45, 45), random(-45, 35));
				TNT1 AAAAAAAAAAAAAA 0 A_Spawnprojectile("SparkX", 2, 0, random(0, 360), 2, random(0, 360));
				TNT1 A 0 A_SpawnItemEx("RicoChet",0,0,-5,0,0,0,0,SXF_NOCHECKPOSITION,0);
				Stop;
			Death:
				Stop;
			XDeath:
				TNT1 A 0;
				Stop;
	}
}