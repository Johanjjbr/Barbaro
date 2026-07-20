# AGENTS.md

# Proyecto

Nombre: El Bárbaro

Motor:
Godot 4.4 Stable

Lenguaje:
GDScript 2.0

Arquitectura:
Component Based + Data Driven

Repositorio Git obligatorio.

---

# Objetivo

Construir un Action RPG Roguelite inspirado en "Surviving the Game as a Barbarian".

El código debe ser escalable.

No se aceptan soluciones rápidas ("quick fixes") que compliquen el mantenimiento futuro.

Siempre priorizar:

1. Legibilidad
2. Modularidad
3. Reutilización
4. Rendimiento
5. Simplicidad

---

# Reglas generales

Nunca modificar archivos sin explicar el motivo.

Nunca eliminar código existente sin justificarlo.

Nunca romper compatibilidad con sistemas anteriores.

Si una modificación afecta otro sistema,
explicar el impacto.

Siempre indicar:

- archivos creados
- archivos modificados
- dependencias nuevas

---

# Arquitectura

Usar escenas pequeñas.

Evitar escenas gigantes.

Cada sistema debe ser independiente.

Ejemplos:

Player

Enemy

Inventory

Combat

Stats

Camera

Health

Mana

Equipment

AI

Cada uno debe poder reutilizarse.

---

# Scripts

Máximo recomendado:

300 líneas por script.

Si supera ese tamaño,
proponer dividirlo.

---

# Recursos

Todo dato configurable debe usar Resource.

Ejemplos:

EnemyData

ItemData

SkillData

WeaponData

ArmorData

CharacterStats

LootTable

DialogueData

Nunca hardcodear valores.

---

# Escenas

Cada escena debe tener una única responsabilidad.

Ejemplo:

Player.tscn

Enemy.tscn

Chest.tscn

Projectile.tscn

HealthBar.tscn

No mezclar sistemas.

---

# Nombres

Variables

snake_case

Funciones

snake_case

Clases

PascalCase

Constantes

UPPER_CASE

---

# Código

Evitar duplicación.

Preferir composición.

No copiar código entre scripts.

Crear utilidades reutilizables.

---

# Señales

Usar Signals antes que referencias directas cuando sea posible.

Evitar acoplamiento.

---

# Dependencias

No instalar plugins sin autorización.

No agregar addons externos.

Consultar antes.

---

# Assets

Nunca asumir la existencia de sprites.

Usar placeholders si faltan.

No bloquear el desarrollo esperando arte.

---

# IA

La IA debe usar State Machines.

No usar if gigantes.

Estados separados.

Idle

Patrol

Follow

Attack

Dead

---

# UI

Separada del gameplay.

Nunca acceder directamente al Player.

Usar eventos.

---

# Guardado

Todo sistema debe ser serializable.

Pensar siempre en Save/Load.

---

# Rendimiento

Evitar:

get_tree().get_nodes_in_group()

cada frame.

Evitar:

find_child()

cada frame.

Cachear referencias.

---

# Física

Usar CharacterBody2D.

Nunca mover con position +=

Usar move_and_slide().

---

# Input

Todo mediante InputMap.

Nunca usar teclas hardcodeadas.

---

# Git

Cada cambio debe ser pequeño.

Commits descriptivos.

No modificar múltiples sistemas sin necesidad.

---

# Documentación

Cada sistema nuevo debe incluir:

Objetivo

Responsabilidades

Dependencias

Limitaciones

Posibles mejoras

---

# Si tienes dudas

NO inventes.

Pregunta antes de implementar.