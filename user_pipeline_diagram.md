                               ┌────────────────────────┐
                               │      Input Sources     │
                               └────────────┬───────────┘
                                            │
                 ┌──────────────────────────┴──────────────────────────┐
                 │                                                     │
     ┌───────────▼───────────┐                            ┌────────────▼────────────┐
     │  (A) Generate Your Own │                           │   (B) Use Built-in UrbanVerse │
     │      Simulation Scenes │                           │       & CraftBench Scenes     │
     └───────────┬───────────┘                            └────────────┬────────────┘
                 │                                                     │
 ┌───────────────┼──────────────┐                       ┌──────────────┼─────────────┐
 │ 1. Prepare Input Video/Image │                       │ 1. Load UrbanVerse-160      │
 │    - YouTube URL             │                       │    (real-to-sim scenes)     │
 │    - Local video file        │                       └──────────────┬─────────────┘
 │    - Phone walk videos       │                                      │
 │    - Pre-extracted frames    │                       ┌──────────────▼─────────────┐
 ├──────────────────────────────┤                       │ 2. Load CraftBench          │
 │ 2. Scene Distillation        │                       │    (artist-designed)        │
 │    - MASt3R depth & poses    │                       └──────────────┬─────────────┘
 │    - YOLO-World + SAM2       │                                      │
 │    - Ground & sky parsing    │                                      │
 ├──────────────────────────────┤                                      │
 │ 3. Materialization           │                                      │
 │    - Retrieve kcousin assets │                                      │
 │    - Match PBR materials     │                                      │
 │    - Match HDRI sky maps     │                                      │
 ├──────────────────────────────┤                                      │
 │ 4. Generate Scene Variants   │                                      │
 │    - USD export (scene_*)    │                                      │
 │    - Ready for train/test    │                                      │
 └───────────┬───────────┬──────┘                                      │
             │           │                                             │
             └───────────┴─────────────────────────────────────────────┘
                             ▼
             ┌────────────────────────────────────────────────────────┐
             │                5. Use Scenes in UrbanVerse             │
             │--------------------------------------------------------│
             │ • Reinforcement learning (PPO)                         │
             │ • Imitation learning (expert demos)                    │
             │ • VR teleoperation data collection                     │
             │ • Closed-loop robot evaluation                         │
             │ • Multimodal dataset generation                        │
             │ • Zero-shot sim2real deployment                        │
             └────────────────────────────────────────────────────────┘
