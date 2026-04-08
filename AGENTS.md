# PB Custom Marines — Agent Guide

This is a GZDoom/UZDoom add-on mod for **Project Brutality** that adds friendly AI marine allies to the player's squad. Marines spawn via tier-based progression, persist across maps, and fight alongside the player using Project Brutality's weapon systems.

**Author:** HyperExia (Elite Marines by AresFallen)
**Engine:** GZDoom / UZDoom (ZScript version 4.10)
**Dependency:** Project Brutality (PB classes like `PB_WeaponBase`, `PB_GlobalStats`, `PBRandomSpawner` must be present at runtime)

---

## Reference Documentation

When evaluating or modifying code in this project, consult these authoritative references:

- **Primary authoritative ZScript reference:** <https://github.com/zdoom-docs/stable>
- **UZDoom source (versioned engine context):** <https://github.com/UZDoom/UZDoom/tree/4.14.3>
- **DECORATE format specifications:** <https://zdoom.org/w/index.php?title=DECORATE_format_specifications>
- **Action functions:** <https://zdoom.org/w/index.php?title=Action_functions>
- **Classes:** <https://zdoom.org/w/index.php?title=Classes>
- **Actor flags:** <https://zdoom.org/w/index.php?title=Actor_flags>
- **Actor properties:** <https://zdoom.org/w/index.php?title=Actor_properties>
- **Actor states:** <https://zdoom.org/w/index.php?title=Actor_states>
- **DECORATE expressions:** <https://zdoom.org/w/index.php?title=DECORATE_expressions>
- **Project Brutality source (PB_Staging branch):** <https://github.com/pa1nki113r/Project_Brutality/tree/PB_Staging> — the upstream mod this add-on depends on. Consult when debugging class resolution failures, missing base class members, or API incompatibilities with PB types such as `PB_WeaponBase`, `PB_GlobalStats`, `PBRandomSpawner`, and `PB_SpawnerBase`.

---

## Project Structure

```
├── AGENTS.md                 # This file
├── CREDITS                   # Attribution
├── CVARINFO                  # 47 server CVARs for configuration
├── DECORATE                  # DECORATE include manifest (marine actors)
├── KEYCONF.txt               # Key bindings (beacon, guard, mobilize, teleport)
├── MENUDEF                   # Options menus (PBMarinesSettings, PBMarineBehaviorSettings)
├── SNDINFO                   # Sound definitions and random groups
├── ZMAPINFO                  # Registers AllyMarinesHandler event handler
├── ZSCRIPT.txt               # ZScript entry point and include manifest
│
├── actors/                   # DECORATE actor definitions
│   ├── Friendly Marines/     # 26 standard marine .dec files (one per weapon)
│   │   └── Elites/           # 6 elite marine .dec files
│   ├── AllyCount.dec         # NumberOfAllies* inventory counters
│   ├── AllyOrders.txt        # Guard/Mobilize/Teleport order inventory items
│   ├── FX.dec                # Visual effect actors
│   ├── MarineDrops.dec       # Weapon drop actors
│   └── MarineSpawners.dec    # Marine_Spawn* intermediary spawners
│
├── zscript/                  # ZScript source (core logic)
│   ├── BaseMarine.zc         # PBMarine class — abstract base for all marines
│   ├── BaseMarine_Functions.zc         # extend class PBMarine — helper functions
│   ├── BaseMarine_Reload_Functions.zc  # extend class PBMarine — reload system
│   ├── BaseMarine_States.zc            # extend class PBMarine — shared state labels
│   ├── BaseMarine_States_Actions.zc    # extend class PBMarine — attack action states
│   ├── BaseMarine_States_Attack_Seq.zc # extend class PBMarine — attack sequences
│   ├── BaseMarine_States_Missile.zc    # extend class PBMarine — missile/firing states
│   ├── BaseMarine_States_Melee.zc      # extend class PBMarine — melee/execution states
│   ├── BaseMarine_States_Death.zc      # extend class PBMarine — death states
│   ├── BaseMarine_States_Moving.zc     # extend class PBMarine — movement states
│   ├── BaseMarine_States_Waiting.zc    # extend class PBMarine — idle/waiting states
│   ├── BaseEliteMarine.zc    # EliteMarine_Base class (extends PBMarine)
│   ├── MarineMixins.zsc      # Mixin classes (names, spawn handling, tiers, damage)
│   ├── MarineEventHandler.zc # AllyMarinesHandler — event handler for map transitions
│   ├── AllyPathfinder.zc     # AllyPathfinder — navigation actor for warping
│   ├── MarineSpawnerBase.zc  # PB_MarineSpawner — weighted random spawn logic
│   ├── MarineProjectiles.zc  # PBMarineProjectile/PBMarineFastProjectile base classes
│   ├── MarineDrops.zc        # Weapon drop logic
│   ├── EasySpawner.zc        # Simplified spawner utilities
│   │
│   ├── Spawner/              # Spawner variants
│   │   ├── PBMarineSpawner.zc          # Main tier-based spawner
│   │   ├── PBMarineMapSpawner.zc       # Map-start spawner (persistent)
│   │   ├── PBMarineSpawnerNoKeep.zc    # Temporary spawner
│   │   ├── PBMarineMapSpawnerNoKeep.zc # Map-start temporary spawner
│   │   ├── PBScriptedMarineSpawner.zc  # Scripted spawner
│   │   └── CapturedMarine.zc           # Rescuable captured marines
│   │
│   ├── MarineProjectiles/    # Projectile definitions by category
│   │   ├── BulletProjectile.zsc        # Base bullet projectile
│   │   ├── BulletDef.SmallCal.zsc      # Small caliber rounds
│   │   ├── BulletDef.Shell.zsc         # Shotgun shells
│   │   ├── BulletDef.HighCal.zsc       # High caliber rounds
│   │   ├── BulletDef.SpecialProjectiles.zsc # Special ammo types
│   │   ├── EnergyProjectile.zsc        # Plasma/energy projectiles
│   │   ├── RailGunPj.zs               # Railgun projectile
│   │   ├── DragonsBreath.zs            # Dragon's breath rounds
│   │   ├── Shrapnel.zsc                # Shrapnel fragments
│   │   ├── ExplosiveFX.zc              # Explosion effects
│   │   ├── Explosives.zc               # Rocket/grenade projectiles
│   │   └── BFGBall.zsc                 # BFG projectile
│   │
│   └── MarineEffects/        # Visual effect actors
│       ├── MarineFX.zc                 # General marine effects
│       ├── MarineReloadFX.zc           # Reload animation effects
│       ├── MarineWeaponFX.zc           # Weapon visual effects
│       └── MarineAttackFX.zc           # Muzzle flash / fire effects
│
├── SOUNDS/                   # Sound assets
│   └── Doomguy and Marines/MARINES/    # Marine voice lines
│
└── SPRITES/                  # Sprite graphics
    └── Marines/              # Organized by weapon type
```

---

## Architecture Overview

### Class Hierarchy

```
Actor
├── SGMKAllyActor                    # Utility base (player proximity checks)
│   └── AllyPathfinder               # Navigation actor for warping marines
├── SwitchableDecoration
│   └── PBMarine (abstract)          # Core marine base class
│       ├── Marine_Rifle             # (defined in DECORATE, inherits PBMarine)
│       ├── Marine_Shotgun           # ...one per weapon type (26 total)
│       └── EliteMarine_Base         # Elite marine base
│           ├── EliteMarine_Carbine  # (defined in DECORATE)
│           └── TheMarshall          # Boss-tier elite
├── PBMarineProjectile               # Projectile base (standard speed)
│   └── [per-ammo-type projectiles]
├── PBMarineFastProjectile           # Projectile base (fast/hitscan-like)
│   └── [per-ammo-type projectiles]
├── PBRandomSpawner (from PB)
│   └── PB_MarineSpawner             # Weighted random marine spawner
│       ├── PB_MarineSpawnerT1-T4    # Tier-specific spawner pools
│       └── PB_EliteMarineSpawner    # Elite spawner pool
├── EventHandler
│   └── AllyMarinesHandler           # Map transition / spawn management
└── Inventory / CustomInventory
    ├── AllySummoner                  # Radio beacon (summon marines)
    ├── MarineManager                # Squad tracking (holds MarineList array)
    ├── MarineCommandGuard/Follow    # Legacy command items
    ├── OrderToGuard/Mobilize/Teleport  # Active order items
    └── NumberOfAllies*              # Per-weapon-type counters (persistence)
```

### Mixin Classes (MarineMixins.zsc)

- **`PB_RandomMarineNameHandler`** — Random name generation with military ranks, first/last names. Used in `PBMarine.PostBeginPlay()` via `PickRandomName(RANK_MILITARY)`.
- **`PB_MarineSpawnHandler`** — Tier lists (`Marine_T1..T4_List_Initial`), `InitializeMarineLists()`, `getMarineNumberCount()`. Used by spawners and the event handler.
- **`PB_MarineHandler`** — Weapon array management (`WeaponArray`, `WeaponAmmoLoadedArray`, `MagazineMaxFillArray`), reload FX dispatch (`D_GetReloadFX`/`D_GetPartialReloadFX`). Mixed into `PBMarine`.
- **`PB_TierHandler`** — `GetPBTier()` progression tier based on `PB_GlobalStats.Counter_LevelsCompleted`. Mixed into `PBMarine`.
- **`PB_HitHandler`** — `CM_Damage()` and `CM_ProjHit()` for damage factor application. Mixed into projectile classes.

### Dual-Language Design (ZScript + DECORATE)

The mod uses a **hybrid architecture**:

- **ZScript** (`zscript/`) handles the core engine: the abstract `PBMarine` base class with all its extended logic (functions, state machine, reload system, pathfinding, projectiles, effects, event handling, spawners).
- **DECORATE** (`actors/`) defines the concrete marine variants. Each `.dec` file inherits from `PBMarine` (or `EliteMarine_Base`) and specifies weapon-specific properties, sprite frames, and attack state overrides.

When adding a new marine type, you create a `.dec` file in `actors/Friendly Marines/` that inherits from `PBMarine`, set its properties (weapon, ally counter, drops), and override the weapon-specific states (Active, Missile, Missile.Left/Right/Retreat). The shared states (See, FollowPlayer, Waits, Death, etc.) are inherited from the base ZScript states.

### State Machine Pattern

Marines use GZDoom's actor state machine. Key state labels and their roles:

| State Label | Purpose |
|---|---|
| `Spawn` | Initial spawn, calls `A_Look` |
| `See` | Chase/follow behavior, alternates FRIENDLY flag |
| `FollowPlayer` | Follow master when no enemies |
| `Waits` / `Waits2-4` | Idle near player, look for enemies, voice lines |
| `Missile` / `Missile2` | Begin attack sequence |
| `Missile.Rifle` (etc.) | Weapon-specific firing loop |
| `Missile.Left` / `Missile.Right` / `Missile.Retreat` | Strafing-while-firing variants |
| `StrafeLeft` / `StrafeRight` | Dodge maneuvers |
| `Active` | Mode switch (guard/follow toggle via `MarineModeSpawn`) |
| `GiveAmmo` / `GiveWeapon*` / `GiveHealth*` | Item handover to player |
| `AttackPunch` / `AttackKick` | Melee attacks |
| `AttackExecute` / `Execution_Generic` | Glory kill sequences |
| `CheckRetreat` | Retreat from dangerous enemies |
| `GetToPlayer` / `Pathfind` / `Warped` | Teleport/pathfind to player |
| `Death` / `XDeath` | Death sequences |
| `Missile.NoFire` | Chase without attacking (reloading/cooldown) |
| `MarineSequenceGuarding` | Guarding-mode behavior |

### Marine Persistence System

Marines persist across maps using inventory counters on the player:
1. Each marine type has a `NumberOfAllies*` inventory item tracking the global count and a `NumberOfAllies*ThisMap` tracking the current-map count.
2. `AllyMarinesHandler.PlayerEntered()` respawns marines based on these counters when `pb_autospawnmarines` is enabled.
3. The `AllySummoner` (radio beacon) can also re-summon previously spawned marines from other maps.
4. `MarineModeSpawn()` handles guard/follow mode switching by destroying the current actor and respawning a variant (e.g., `Marine_Rifle` <-> `RifleMarineGuarding`), transferring health, ammo, armor, and weapon state.

### Projectile System

All marine projectiles derive from `PBMarineProjectile` (standard) or `PBMarineFastProjectile` (hitscan-like). Both override:
- `DoSpecialDamage` — applies `pb_marine_damage_factor` and `pb_marine_boss_damage_factor` multipliers, prevents friendly damage.
- `SpecialMissileHit` — passes through players and marines (returns 1 = no collision).

Projectiles are spawned via `PBCM_SpawnProjectile()` which sets species to `"Marines"` and enables all friendly-fire prevention flags.

### Friendly Fire Prevention

Multiple layers prevent marines from harming the player or each other:
1. **Species** set to `"Marines"` with `+DONTHURTSPECIES`, `+THRUSPECIES`, `+MTHRUSPECIES`
2. **DamageFactor** entries for friendly damage types (bullet, shotgun, ssg, etc.) set to 0.0
3. **`CanCollideWith()`** override — missiles from players/marines pass through
4. **`TakeSpecialDamage()`** and **`DamageMobj()`** overrides — zero out player/marine source damage
5. **Projectile overrides** — `DoSpecialDamage` returns 0 for PlayerPawn/PBMarine targets

### Reload System

Marines track ammo per weapon via parallel arrays (`WeaponArray`, `WeaponAmmoLoadedArray`, `MagazineMaxFillArray`). Key functions:
- `D_DepleteWeaponAmmo()` — decrements ammo on fire
- `D_StartReloadIfEmpty()` / `D_StartReloadIfNotFullIdle()` — triggers reload FX actor
- `D_DoMarineReloadFX()` — spawns a `MarineReloadFX` actor as a child, blocks firing until complete
- `D_AbortAndReloadIfEmpty()` — interrupts attack state to reload

Controlled by the `pb_marinesreload` CVAR.

---

## Key CVARs

All CVARs are `server` scope and prefixed with `pb_` or `pbmarine_`:

| CVAR | Type | Default | Purpose |
|---|---|---|---|
| `pb_autospawnmarines` | bool | true | Surviving marines auto-spawn on map start |
| `pb_marinesdropweapons` | bool | true | Marines drop weapons on death (vs ammo) |
| `pb_marinesstartingarmor` | bool | true | Marines spawn with armor |
| `pb_marinesrandomizedhealth` | bool | true | Marines get 100-300 HP randomly |
| `pb_marine_damage_factor` | float | 1.0 | Damage dealt multiplier (0.0-1.0) |
| `pb_marine_boss_damage_factor` | float | 1.0 | Damage to bosses multiplier |
| `pb_marine_damage_taken` | float | 1.0 | Damage received multiplier (0.0-3.0) |
| `pb_marinesreload` | bool | true | Enable reload mechanics |
| `pb_marinesglorykill` | bool | true | Enable glory kill executions |
| `pb_marinespickupitems` | bool | true | Marines pick up health/armor |
| `pb_marine_behavior_num_adaptation` | bool | true | Squad-size-based behavior scaling |
| `pb_quietmarines` | bool | false | Suppress marine voice lines |
| `pb_mapstartnewmarine` | bool | false | Spawn new marine each map |
| `pb_elitemarines` | bool | false | Enable elite marine spawns |
| `debugLogCustomMarines` | bool | false | Debug logging |

---

## Coding Conventions

### ZScript Style
- **ZScript version 4.10** — do not use features from later versions without verifying engine support.
- Classes use PascalCase (`PBMarine`, `AllyPathfinder`, `MarineReloadFX`).
- Custom functions use a mix of `A_` prefix (action functions callable from states), `D_` prefix (dynamic/data functions), `PB_` prefix (Project Brutality integration), and `PBCM_` prefix (PB Custom Marines specific).
- The `extend class PBMarine` pattern is used extensively to split the base marine across multiple files while keeping it as a single class.
- Mixin classes are defined with `mixin class` and included with the `mixin` keyword in the target class body.
- Boolean flags are accessed via `bFLAGNAME` syntax (e.g., `bSHOOTABLE`, `bFRIENDLY`) or `A_ChangeFlag()`.

### DECORATE Style
- Actors inherit from ZScript base classes (`PBMarine`, `EliteMarine_Base`).
- Properties are set using `PBMarine.PropertyName "Value"` syntax.
- States use standard DECORATE format: `SPRITE FRAME DURATION [BRIGHT] [Action]`.
- `TNT1 A 0` is the invisible zero-duration frame used for logic-only ticks.
- `#### #` notation inherits the previous sprite/frame (used in shared base states).

### Adding a New Marine Variant
1. Create `actors/Friendly Marines/Marine-NewWeapon.dec` inheriting `PBMarine`
2. Set properties: `AllyCountedInventory`, `AllyMapCounter`, `MarineWeapon`, `DropItem`
3. Define weapon-specific states: `Active`, `Missile.*`, `StrafeLeft/Right`, `Retreat`
4. Create the guarding variant actor inheriting the main one (Speed 0, `+NODROPOFF`)
5. Add `NumberOfAllies*` and `NumberOfAllies*ThisMap` counter inventory items in `AllyCount.dec`
6. Add the `#include` line to the `DECORATE` file
7. Add spawn entries to `AllySummoner` (ZSCRIPT.txt) and `AllyMarinesHandler.PlayerEntered()`
8. Add the marine to appropriate tier list in spawner configuration
9. Add drop actor in `MarineDrops.dec` / `MarineDrops.zc`

---

## Build & Packaging

This project is source-only (no build scripts). To package for distribution:
1. Compress the entire directory into a `.pk3` file (ZIP format with `.pk3` extension)
2. The `.pk3` is loaded after Project Brutality in the GZDoom/UZDoom load order
3. No compilation step is needed — the engine parses ZScript and DECORATE at runtime

---

## Testing

To test changes:
1. Launch GZDoom/UZDoom with Project Brutality loaded first, then this mod
2. Use the marine beacon key binding to summon marines
3. Enable `debugLogCustomMarines` CVAR for console debug output
4. The options menu under "Addon - Marines Settings" controls all marine behaviors
5. Console commands: `summon Marine_Rifle` (or any marine class name) for direct spawning
