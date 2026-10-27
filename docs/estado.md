# Estado en EcoTrack Meta: ChangeNotifier contra provider

Cada respuesta cita una clase, un archivo o una prueba del proyecto.

## Tipos de estado

| Tipo | Dónde vive | Evidencia |
|---|---|---|
| Efímero | En el `State` de la vista que lo usa: laboratorio elegido, texto de litros y pestaña activa. | `_FormularioRegistroState._laboratorio` y `_litros`, `_PantallasEcoTrackState._indice` en `lib/presentacion/vistas.dart` |
| Compartido | En el ViewModel, único dueño: `consumos`, `meta`, `error` y `guardando`. | `ConsumosViewModel` en `lib/presentacion/consumos_view_model.dart` |
| Derivado | Getters que se calculan con cada lectura, nunca se guardan. | `get total`, `get avance` y `get metaSuperada` en `consumos_view_model.dart`. Prueba `total, avance y metaSuperada se derivan de consumos y meta` |
| Persistido | En el repositorio, la fuente de verdad. El ViewModel relee con `todos()` después de guardar. | `MemoriaConsumoRepository._consumos` en `lib/datos/memoria_consumo_repository.dart` |

## Criterios de A02

| Criterio | A · ChangeNotifier | B · provider |
|---|---|---|
| Dato compartido | Un solo `ConsumosViewModel` creado en `_AppChangeNotifierState` llega a las tres pestañas por constructor y cada adaptador lo escucha con `ListenableBuilder`. Prueba `Dato compartido: Registro guarda, Historial y Meta lo ven` en `test/etapa4_change_notifier_test.dart`. | Un solo `ConsumosViewModel` colgado con `ChangeNotifierProvider` en `AppProvider`. Los adaptadores lo piden con `context.watch<ConsumosViewModel>()`. Misma prueba en `test/etapa5_provider_test.dart`. |
| Capas | `vistas.dart` solo importa `material.dart` y `dominio/consumo.dart`. La regla de litros vive en `validarLitros` y llega a la vista como `error`. Prueba `Capas: el error del dominio aparece y no se guarda nada`. `verificar_estado.sh` secciones 2 a 4 en OK. | Mismas vistas y mismo ViewModel sin cambios entre etapa 4 y 5 (`git diff 161786f 6be5749 -- lib/presentacion` vacío). Misma prueba `Capas` en etapa 5. |
| Sustitución | El ViewModel recibe `ConsumoRepository` por constructor. Con `RepositorioEspia` las pantallas no cambian. Prueba `Sustitución: con otra fuente de datos las pantallas no cambian` en etapa 4. Solo `main_change_notifier.dart` importa `MemoriaConsumoRepository`. | `AppProvider(repositorio:)` recibe el contrato y el `create` lo pasa al ViewModel. Misma prueba `Sustitución` en etapa 5. Solo `main.dart` importa la implementación en memoria. |
| Costo | Tres adaptadores con `required this.vm` y tres `ListenableBuilder`. Hay que escribir el `State` que crea el ViewModel y su `dispose()` en `_AppChangeNotifierState`. Sin dependencias extra. | Adaptadores `const` sin parámetros, una línea de `context.watch` en cada uno y sin `dispose()` propio: lo hace `ChangeNotifierProvider`. Cuesta la dependencia `provider` en `pubspec.yaml`. |

## Preguntas de control

| Pregunta | Respuesta con evidencia |
|---|---|
| ¿`laboratoriosUtez` es estado? ¿Y `metaInicial`? | `laboratoriosUtez` no: es una constante que nunca cambia (`const` en `lib/dominio/consumo.dart`). `metaInicial` tampoco: es el valor de arranque, el estado es `ConsumosViewModel.meta`. |
| ¿Quién es la fuente de verdad? | El repositorio. `ConsumosViewModel.guardar` reasigna `consumos = await _repositorio.todos()` en lugar de agregar a su lista. |
| ¿Qué pasa si falta el último `notifyListeners()` de `guardar`? | `guardando` se queda en verdadero en pantalla, el botón Guardar sigue desactivado y Historial no muestra el consumo. Lo detecta la prueba `guardar avisa "guardando" y luego "listo"`. |
| ¿Por qué `total` es getter? | Así no se puede desincronizar de `consumos`. `verificar_estado.sh` sección 3 confirma que es estado derivado. |
| ¿Cuántos constructores reciben `vm`? | En A, tres: `RegistroCN`, `HistorialCN` y `MetaCN`. Con una subpantalla de detalle en Meta serían cuatro. En B, ninguno: los adaptadores son `const` y lo piden al árbol. |
| Entre A y B, ¿qué archivos cambiaron? | Se agregó `lib/variantes/b_provider.dart` y cambió `lib/main.dart`. `consumos_view_model.dart` y `vistas.dart` no cambiaron una línea. |
| ¿Quién hace el `dispose()` en B? | `ChangeNotifierProvider`, que lo llama al desmontarse porque él creó el ViewModel en `create`. |
