# Combat System

## Objetivo
Procesar eventos de combate — cálculo de daño, aplicación de efectos, detección de golpes.

## Responsabilidades
- Detectar colisiones de hitbox contra hurtbox (Area2D)
- Calcular daño usando fórmula: `damage = atacante.strength * weapon_modifier - defensor.endurance * armor_modifier`
- Aplicar daño al HealthComponent del defensor
- Gestionar tiempos de ataque (cooldown, animación)
- Emitir eventos de combate al EventBus

## Dependencias
- `StatsComponent` — stats de atacante y defensor
- `HealthComponent` — receptor de daño
- `EquipmentComponent` — modificadores de arma y armadura
- `EventBus` — señales globales

## Señales Emitidas
- `attack_started(attacker: Node)`
- `hit_landed(attacker: Node, target: Node, damage: int)`
- `hit_blocked(attacker: Node, target: Node)`
- `target_killed(killer: Node, target: Node)`

## Limitaciones
- Combate cuerpo a cuerpo solo (sin ranged en MVP)
- Sin sistema de estados (stun, poison) en MVP
- Sin parry o contraataque en MVP

## Posibles Mejoras
- Añadir sistema de combos
- Damage types (físico, mágico, verdadero)
- Resistencia y penetración
- Efectos de estado (veneno, sangrado, quemadura)
- Ataques cargados y especiales
