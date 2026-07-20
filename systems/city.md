# City System

## Objetivo
Gestionar el hub central del juego — la ciudad donde el jugador descansa, comercia y progresa entre runs.

## Responsabilidades
- Mantener el estado de la ciudad (NPCs, edificios, economía)
- Ciclo económico mensual (impuestos, fechas)
- Interacciones con NPCs (diálogo, comercio, misiones)
- Gestión de edificios funcionales (tienda, forja, taberna, gremio, casa)
- Reputación con facciones
- Transición entre ciudad y mazmorra

## Dependencias
- `DialogueSystem` — conversaciones con NPCs
- `EconomyManager` — oro, precios, impuestos
- `QuestManager` — misiones disponibles
- `ReputationData` (Resource) — valores de reputación
- `SaveManager` — persistencia

## Señales Emitidas
- `city_entered()`
- `city_exited()`
- `day_passed(day: int)`
- `tax_collected(amount: int)`
- `reputation_changed(faction: String, value: int)`
- `quest_available(quest: Resource)`
- `quest_completed(quest: Resource)`

## Edificios Funcionales

| Edificio | Función | NPC Asociado |
|----------|---------|-------------|
| Tienda | Comprar/vender items | Merchant |
| Forja | Mejorar/reparar equipo | Blacksmith |
| Taberna | Información, trabajos alternativos | Bartender |
| Gremio | Misiones, reputación | Guild Master |
| Casa | Descanso, guardado, almacenamiento | (none) |

## Ciclo Económico

```
Cada día en ciudad:
├── Se paga mantenimiento (casa, almacén)
├── Los precios fluctúan ligeramente
└── Nuevas misiones disponibles

Cada 30 días (fin de mes):
├── Se cobran impuestos obligatorios
├── El laberinto se abre
└── Eventos especiales pueden ocurrir
```

## Limitaciones
- Ciudad estática (mismos NPCs y edificios siempre) en MVP
- Sin ciclo día/noche visual en MVP
- Sin NPCs con rutinas diarias en MVP

## Posibles Mejoras
- Ciclo día/noche visual con cambios en NPCs
- Eventos aleatorios en ciudad (mercado especial, festival)
- Expansión de ciudad con mejoras (inversión)
- NPCs con rutinas diarias y horarios
- Misiones secundarias ramificadas
