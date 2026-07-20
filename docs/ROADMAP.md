# ROADMAP.md — Plan de Desarrollo

## Fases

### Fase 0 — Fundación (Prioridad: Crítica)
Establecer la base técnica del proyecto.

- [ ] Estructura de carpetas y escenas base
- [ ] Sistema de recursos (`Resource`) para datos
- [ ] EventBus global (autoload)
- [ ] Sistema de logging / debug
- [ ] Configuración de InputMap
- [ ] Escena placeholder de Player (CharacterBody2D)
- [ ] Escena placeholder de test room

### Fase 1 — Jugador y Movimiento (Prioridad: Crítica)
- [ ] PlayerController con `move_and_slide()`
- [ ] Animaciones placeholder
- [ ] Cámara seguidora
- [ ] InputMap completo

### Fase 2 — Stats y Salud (Prioridad: Alta)
- [ ] Sistema de Stats (basado en Resource)
- [ ] Componente Health (vida, muerte, regeneración)
- [ ] Componente Stamina / Mana
- [ ] UI de barras (HealthBar, StaminaBar)

### Fase 3 — Combate (Prioridad: Alta)
- [ ] Sistema de Combate (melee básico)
- [ ] Sistema de Daño (fórmula con stats)
- [ ] Animaciones de ataque placeholder
- [ ] Hitbox / Hurtbox system

### Fase 4 — Inventario y Equipo (Prioridad: Alta)
- [ ] Sistema de Inventario (Resource-based)
- [ ] Sistema de Equipamiento
- [ ] Items: armas, armaduras, consumibles
- [ ] UI de inventario y equipamiento

### Fase 5 — Mazmorra (Prioridad: Alta)
- [ ] Generación procedural de salas
- [ ] Sistema de habitaciones (combate, tesoro, descanso, evento, jefe)
- [ ] Transiciones entre salas
- [ ] Mini-mapa
- [ ] Enemigos placeholder con AI básica

### Fase 6 — IA de Enemigos (Prioridad: Alta)
- [ ] State Machine: Idle, Patrol, Follow, Attack, Dead
- [ ] Diferentes comportamientos por tipo de enemigo
- [ ] Sistema de detección (rango visual / audición)

### Fase 7 — Ciudad (Prioridad: Media)
- [ ] Escena de ciudad con NPCs funcionales
- [ ] Tienda (comprar/vender)
- [ ] Forja (mejorar equipo)
- [ ] Taberna (trabajo alternativo, información)
- [ ] Gremio (misiones)
- [ ] Casa del jugador (descanso, guardado)
- [ ] Sistema de impuestos mensuales

### Fase 8 — Progresión (Prioridad: Media)
- [ ] Sistema de niveles y experiencia
- [ ] Árbol de habilidades
- [ ] Reputación con facciones
- [ ] Meta-conocimiento (información reusable entre runs)

### Fase 9 — Persistencia (Prioridad: Media)
- [ ] Sistema de guardado/carga
- [ ] Serialización de cada sistema
- [ ] Persistencia entre runs (progresión permanente)

### Fase 10 — Audio (Prioridad: Baja)
- [ ] Sistema de audio (SFX + música)
- [ ] Mezcla por capas
- [ ] Audio espacial

### Fase 11 — Pulido (Prioridad: Baja)
- [ ] Transiciones y efectos visuales
- [ ] Tutorial / onboarding
- [ ] Balance de dificultad
- [ ] Optimización de performance

---

## Prioridades MVP

**MVP mínimo:** Fases 0-5 (movimiento, combate, stats, inventario, mazmorra básica).
**MVP extendido:** + Fase 6 (IA), Fase 7 (Ciudad con tienda).
**v1.0:** Fases 0-9 (todo excepto audio y pulido fino).
