# Equipment System

## Objetivo
Gestionar qué items equipa el personaje y cómo afectan sus stats.

## Responsabilidades
- Definir slots de equipo (arma, armadura, casco, accesorio x2)
- Equipar/desequipar items desde el inventario
- Aplicar modificadores de stats del equipo al StatsComponent
- Validar requisitos (skill necesaria para equipar un item)

## Dependencias
- `InventoryComponent` — origen/destino de items
- `StatsComponent` — aplicación de modificadores
- `EquipmentData` (Resource) — definición de cada slot
- `SaveManager` — persistencia

## Señales Emitidas
- `item_equipped(item: ItemData, slot: String)`
- `item_unequipped(item: ItemData, slot: String)`
- `equipment_changed()`

## Limitaciones
- Slots fijos (no expandibles sin modificación)
- Sin sistema de sets o bonificaciones por conjunto en MVP
- Sin durabilidad de equipo en MVP

## Posibles Mejoras
- Bonificaciones por sets de equipo
- Sistema de durabilidad y reparación
- Gemas / encantamientos en slots secundarios
- Transmog / apariencia
