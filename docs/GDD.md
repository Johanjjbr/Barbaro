# GDD — El Bárbaro

## Game Design Document

---

### 1. Visión General

**Título:** El Bárbaro  
**Género:** Action RPG Roguelite  
**Inspiración:** "Surviving the Game as a Barbarian"  
**Público objetivo:** Jugadores que disfrutan roguelites de acción con profundidad táctica y narrativa emergente.

---

### 2. Core Loop

```
Explorar Mazmorra → Combatir → Obtener Recompensas → Regresar a Ciudad
      ↑                                                        |
      └──────────── Mejorar Equipo / Stats / Habilidades ──────┘
```

El jugador vive en ciclos de incursión al laberinto mensual, con progresión persistente en la ciudad.

---

### 3. Principios de Diseño

| Principio | Aplicación |
|-----------|-----------|
| Muerte significativa | Al morir, el personaje pierde el equipo no asegurado y debe reentrenar habilidades. |
| Libertad de resolución | El jugador puede combatir, negociar, huir o trabajar para progresar. |
| NPCs relevantes | Los NPCs no son decorativos — son fuente de misiones, entrenamiento e información. |
| Mundo consistente | La ciudad y el laberinto existen en un mismo mundo con reglas narrativas claras. |

---

### 4. Mecánicas Principales

#### 4.1 Combate
- Tiempo real con pausa táctica opcional.
- Armas cuerpo a cuerpo como prioridad del bárbaro.
- Sistema de daño basado en stats + modificadores de equipo.
- Señales para eventos de combate (golpe, bloqueo, muerte).

#### 4.2 Stats
- Fuerza (daño físico, capacidad de carga).
- Aguante (vida, resistencia a efectos).
- Velocidad (velocidad de ataque, movimiento).
- Pericia (precisión, requisitos de equipo).

#### 4.3 Mazmorra
- Generación procedural por habitaciones conectadas.
- Salas de descanso, tesoro, combate, evento, jefe.
- Dificultad escala con profundidad.

#### 4.4 Ciudad
- Hub central con NPCs funcionales.
- Tienda, forja, taberna, gremio, casa del jugador.
- Ciclo económico con impuestos mensuales.

#### 4.5 Progresión
- Nivel del personaje (stats + habilidades).
- Equipo (armas, armaduras, accesorios).
- Reputación con facciones de la ciudad.
- Conocimiento meta (información sobre el mundo).

---

### 5. Economía

| Recurso | Uso | Cómo se obtiene |
|---------|-----|-----------------|
| Oro | Compras, impuestos, mejoras | Mazmorra, trabajos, venta |
| Materiales | Forja, mejoras de equipo | Mazmorra, comercio |
| Reputación | Desbloqueo de NPCs, misiones | Misiones, diálogos |
| Puntos de habilidad | Subir habilidades | Subir de nivel |

---

### 6. Narrativa

- El protagonista despierta en el cuerpo de un bárbaro dentro de un juego.
- Descubre que otros "poseídos" existen.
- Debe sobrevivir en una ciudad devastada, pagando impuestos y adentrándose en el laberinto mensual.
- El lore se descubre mediante diálogos, objetos y eventos.

---

### 7. Interfaces de Usuario

- HUD de combate (vida, stamina, habilidades).
- Inventario y equipamiento.
- Diálogos con NPCs.
- Mapas de mazmorra.
- Pantalla de estado y progresión.
- Chat / notificaciones de sistema.

---

### 8. Plataforma y Motor

- **Motor:** Godot 4.4 Stable
- **Lenguaje:** GDScript 2.0
- **Arquitectura:** Component Based + Data Driven
- **Gráficos:** 2D pixel art
- **Perspectiva:** Top-down
