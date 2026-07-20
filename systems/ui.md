# UI System

## Objetivo
Gestionar todas las interfaces de usuario del juego, manteniéndolas separadas de la lógica de gameplay.

## Responsabilidades
- Escuchar eventos del EventBus para actualizar UI
- Gestionar el stack de pantallas (menú, HUD, inventario, diálogo)
- Mostrar/ocultar paneles según contexto
- Proveer feedback visual al jugador (daño, notificaciones, cambios de estado)
- Soporte para navegación por teclado/ratón

## Dependencias
- `EventBus` — fuente de eventos
- Ninguna referencia directa a Player o sistemas de gameplay

## Señales Emitidas
- `ui_opened(panel_name: String)`
- `ui_closed(panel_name: String)`
- `player_action_requested(action: String, data: Dictionary)`

## Paneles de UI

| Panel | Propósito | Activación |
|-------|-----------|------------|
| `HUD` | Vida, stamina, minimapa, oro | Siempre visible en gameplay |
| `InventoryUI` | Grid de inventario y slots de equipo | Tecla I |
| `EquipmentUI` | Slots de equipo con stats | Tecla E |
| `DialogueUI` | Diálogos con NPCs | Automático al hablar |
| `ShopUI` | Comprar/vender items | Al interactuar con tienda |
| `ForgeUI` | Mejorar/reparar equipo | Al interactuar con forja |
| `QuestUI` | Misiones activas y completadas | Tecla Q |
| `MapUI` | Mapa de mazmorra | Tecla M |
| `PauseMenu` | Pausa, opciones, salir | Tecla Escape |
| `SaveUI` | Slots de guardado | Al dormir en casa |
| `NotificationUI` | Notificaciones del sistema | Automático |
| `DeathUI` | Pantalla de muerte | Al morir |

## Arquitectura de UI

```
UILayer (CanvasLayer raíz)
├── HUD
├── PanelStack (controla visibilidad)
│   ├── InventoryUI
│   ├── EquipmentUI
│   ├── DialogueUI
│   ├── ShopUI
│   ├── QuestUI
│   ├── MapUI
│   └── SaveUI
├── Overlays
│   ├── NotificationUI
│   ├── DeathUI
│   └── PauseMenu
```

## Limitaciones
- Sin sistema de tooltips contextual en MVP
- Sin animaciones de transición complejas en MVP
- Sin soporte de gamepad en MVP
- Sin personalización de HUD en MVP

## Posibles Mejoras
- Sistema de tooltips con descripción detallada
- Animaciones de apertura/cierre de paneles
- Soporte completo para gamepad
- HUD personalizable (posición de elementos)
- Temas visuales intercambiables
- Sistema de tutorial interactivo
