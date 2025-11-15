.. _urbanverse-quickstart-urbanversegen:


Real-to-Sim Scene Generation with UrbanVerse-Gen
================================================
write introduction of UrbanVerse-Gen here...

The API format I want is like `import urbanverse as uv`

Prepare Your Video
------------------
The API you can further design would be like `uv.prepare_input_video(xxxxxx)`
At this step, the output should be a folder under the target output dirt like `output_dir/images/` where there are list of images of the input video.
Our UrbanVerse-Gen pipeline can accept:
(1) YouTube video url and the start frame timestamp and the end frame timestamp you want. in this case when you can urbanverse-gen api, it will  use yt-dlp  to download and chop the clip you want into images
(2) a local video file path. This video can be any RGB city-tour videos,  you can also use your phone or camera to film your own city-tour videos and use this as input. In this case when you can urbanverse-gen api, it will use the local video file path to extract the images.
(3) a list of image file paths of your prepared videos in this case when you can urbanverse-gen api, it will use the list of image file paths to extract the images.


Extracting Semantic Scene Layout from Videos
--------------------------------------------
This API would be like `uv.gen.scene_distillation(xxxxxx)`
Also, write a note to reminder user setup their openai api key and add it to the environment variable OPENAI_API_KEY.
The input is the folder where there are list of images of the input video. 
The output would be the extracted scene layout in the folder like:

```
conf # estimateddepth confidence map .npy
depth # estimateddepth npy files... .npy
poses # estimated camera poses... .npy
segmentations_2d # estimated 2D segmentation results images .jpg
distilled_scene_graph.pkl.gz # distilled semantic 3D scene layout in scene graph formatthat includes: object nodes: 3D object's bbox, points, categories, instance ids, observed masks, observed RGB images,...; sky nodes: sky masks and corresponding images; ground nodes: road points masks and corresponding images and sidewalks points and masks and corresponding images .pkl.gz
scene_pcd.glb # reconstructed scene point cloud with posed cameras... .glb
camera.yaml # estimated camera intrinsics...
config_params.json # model and pipeline config parameters...
```



Retrieving 3D Assets and Materialsfrom UrbanVerse-100K
------------------------------------------------------
This API would be like `uv.gen. materialization(xxxxxx)`, where we retrieve digital cousin assets fro each object, sky, road, sidewalk, etc.
The input is the output folder of the scene_distillation api and a preset number of cousins to retrive per object, such as 5 or 32
The output would be like 
```
materliazed_scene_with_cousins.pkl.gz # distilled semantic 3D scene layout in scene graph formatthat includes: object nodes: 3D object's bbox, points, categories, instance ids, observed masks, observed RGB images,...; sky nodes: sky masks and corresponding images; ground nodes: road points masks and corresponding images and sidewalks points and masks and corresponding images .pkl.gz
```



Creating and Instantiating Simulation Scenes
--------------------------------------------
This API would be like `uv.gen.spawn(xxxxxx)`, where we create the simulation scenes with the materialized scene graph with cousins.
The input is the output `materliazed_scene_with_cousins.pkl.gz` from previous step and a output folder where we export the created simulation scene.
The output would be like, where each scene_cousin_01 folder contains a exported (or in isaacsim language, "collected") scene .USD file and corresponding assets for the scene.
These scenes are ready to be instantiated in Isaac Sim and used for training or evaluation.
```
|- scene_cousin_01
...
|- scene_cousin_32

```