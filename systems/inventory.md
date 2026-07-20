# Inventory System

## Objetivo
Gestionar los items que el jugador lleva consigo — almacenamiento, organización, uso de consumibles.

## Responsabilidades
- Almacenar items en slots con límite de peso (basado en Strength)
- Añadir y remover items
- Usar items consumibles (pociones, pergaminos)
- Transferir items entre inventario y equipo
- Persistencia del estado del inventario

## Dependencias
- `ItemData` (Resource) — datos de cada item
- `StatsComponent` — capacidad de carga
- `EquipmentComponent` — slots de equipo
- `SaveManager` — persistencia

## Señales Emitidas
- `item_added(item: ItemData, quantity: int)`
- `item_removed(item: ItemData, quantity: int)`
- `item_used(item: ItemData, user: Node)`
- `inventory_updated()`

## Limitaciones
- Capacidad limitada por peso, no por slots
- Sin sistema de stacks en MVP (cada item ocupa un slot)
- Sin ordenamiento automático

## Posibles Mejoras
- Sistema de stacks para items consumibles
- Categorías y filtros en UI
- Quick slots para consumibles
- Búsqueda y ordenamiento
