.. _urbanverse-gallery-realworld-sidebyside:

Real-World Side-by-Side Comparisons
====================================

This page provides side-by-side comparisons between our ``UrbanVerse-PPO`` policy trained in UrbanVerse scenes, and prior state-of-the-art methods (``PPO-UrbanSim``, ``CityWalker``, ``S2E``, and ``Nomad``) in real-world street environments across two robot platforms. 

All policies are deployed in a zero-shot setting and evaluated under identical robot configurations and real-world scenes, with no fine-tuning or additional training on the target environments.

.. note::

   The videos shown below are the recordings of the actual real-world experiment from which the results reported in the paper were obtained.


.. raw:: html

   <!-- Real-world Side-by-Side Comparison Subsection -->

   <div style="text-align: center; margin-top: 3rem; margin-bottom: 2rem;">

     <h3 class="title is-5" style="background-color: black; color: white; padding: 6px 12px; display: inline-block; margin: 0; font-weight: normal; font-size: 1rem;">Side-by-Side Comparison: COCO Wheeled Robot (3x Speed)</h3>

   </div>

   

   <!-- Scene Selection Buttons -->

   <div style="text-align: center; margin-bottom: 1.5rem;">

     <button class="button is-primary scene-btn active" onclick="showScene('scene05')" style="margin: 0 0.3rem; background-color: #363636; border-color: #363636; font-family: 'Roboto Mono', monospace;">Scene 01</button>

     <button class="button is-primary scene-btn" onclick="showScene('scene06')" style="margin: 0 0.3rem; background-color: #dbdbdb; color: #363636; border-color: #dbdbdb; font-family: 'Roboto Mono', monospace;">Scene 02</button>

     <button class="button is-primary scene-btn" onclick="showScene('scene07')" style="margin: 0 0.3rem; background-color: #dbdbdb; color: #363636; border-color: #dbdbdb; font-family: 'Roboto Mono', monospace;">Scene 03</button>

     <button class="button is-primary scene-btn" onclick="showScene('scene09')" style="margin: 0 0.3rem; background-color: #dbdbdb; color: #363636; border-color: #dbdbdb; font-family: 'Roboto Mono', monospace;">Scene 04</button>

     <button class="button is-primary scene-btn" onclick="showScene('customized')" style="margin: 0 0.3rem; background-color: #dbdbdb; color: #363636; border-color: #dbdbdb; font-family: 'Roboto Mono', monospace;">Scene 05</button>

     <button class="button is-primary scene-btn" onclick="showScene('scene04')" style="margin: 0 0.3rem; background-color: #dbdbdb; color: #363636; border-color: #dbdbdb; font-family: 'Roboto Mono', monospace;">Scene 06</button>

     <button class="button is-primary scene-btn" onclick="showScene('scene02')" style="margin: 0 0.3rem; background-color: #dbdbdb; color: #363636; border-color: #dbdbdb; font-family: 'Roboto Mono', monospace;">Scene 07</button>

   </div>

   

   <!-- Video Container -->

   <div style="text-align: center;">

       <video id="scene02-video" class="scene-video" loop muted playsinline controls controlslist="nodownload" preload="none" data-src="../../_static/SideBySide_COCO_3x/masked_coco_sbs_v2_s02_hq.mp4" poster="../../_static/videos/loading-icon.gif" style="border-radius: 10px; width: 85%; max-width: 1200px; display: none; margin: 0 auto;"></video>

       <video id="scene04-video" class="scene-video" loop muted playsinline controls controlslist="nodownload" preload="none" data-src="../../_static/SideBySide_COCO_3x/masked_coco_sbs_v2_s04_hq.mp4" poster="../../_static/videos/loading-icon.gif" style="border-radius: 10px; width: 85%; max-width: 1200px; display: none; margin: 0 auto;"></video>

       <video id="scene05-video" class="scene-video" autoplay loop muted playsinline controls controlslist="nodownload" preload="metadata" src="../../_static/SideBySide_COCO_3x/coco_sbs_v2_s05_hq.mp4" poster="../../_static/videos/loading-icon.gif" style="border-radius: 10px; width: 85%; max-width: 1200px; display: block; margin: 0 auto;"></video>

       <video id="scene06-video" class="scene-video" loop muted playsinline controls controlslist="nodownload" preload="none" data-src="../../_static/SideBySide_COCO_3x/coco_sbs_v2_s06_hq.mp4" poster="../../_static/videos/loading-icon.gif" style="border-radius: 10px; width: 85%; max-width: 1200px; display: none; margin: 0 auto;"></video>

       <video id="scene07-video" class="scene-video" loop muted playsinline controls controlslist="nodownload" preload="none" data-src="../../_static/SideBySide_COCO_3x/coco_sbs_v2_s07_hq.mp4" poster="../../_static/videos/loading-icon.gif" style="border-radius: 10px; width: 85%; max-width: 1200px; display: none; margin: 0 auto;"></video>

       <video id="scene09-video" class="scene-video" loop muted playsinline controls controlslist="nodownload" preload="none" data-src="../../_static/SideBySide_COCO_3x/coco_sbs_v2_s09_hq.mp4" poster="../../_static/videos/loading-icon.gif" style="border-radius: 10px; width: 85%; max-width: 1200px; display: none; margin: 0 auto;"></video>

       <video id="customized-video" class="scene-video" loop muted playsinline controls controlslist="nodownload" preload="none" data-src="../../_static/SideBySide_COCO_3x/coco_sbs_v2_customized_hq.mp4" poster="../../_static/videos/loading-icon.gif" style="border-radius: 10px; width: 85%; max-width: 1200px; display: none; margin: 0 auto;"></video>

   </div>

   

   <!-- Preview Gallery -->

   <div style="text-align: center; margin-top: 1rem;">

     <div style="display: inline-block; position: relative; background-color: #f5f5f5; border-radius: 10px; padding: 15px; max-width: 800px;">

       <!-- Sliding Indicator Bar -->

       <div id="scene-indicator-bar" style="position: absolute; top: 10px; left: calc(15px + 0%); width: 14.28%; height: 4px; background-color: #363636; border-radius: 2px; transition: left 0.3s ease;"></div>

       

       <!-- Thumbnail Videos -->

       <div style="display: flex; justify-content: space-between; gap: 8px; margin-top: 10px;">

         <div class="scene-thumbnail-container" onclick="showScene('scene05')" style="flex: 1; cursor: pointer; position: relative;">

           <video class="scene-thumbnail-video" muted playsinline src="../../_static/SideBySide_COCO_3x/coco_sbs_v2_s05_hq.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid #363636;"></video>

           <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; font-weight: bold; color: #363636; font-family: 'Roboto Mono', monospace;">Scene 01</div>

         </div>

         <div class="scene-thumbnail-container" onclick="showScene('scene06')" style="flex: 1; cursor: pointer; position: relative;">

           <video class="scene-thumbnail-video" muted playsinline src="../../_static/SideBySide_COCO_3x/coco_sbs_v2_s06_hq.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid transparent;"></video>

           <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; color: #666; font-family: 'Roboto Mono', monospace;">Scene 02</div>

         </div>

         <div class="scene-thumbnail-container" onclick="showScene('scene07')" style="flex: 1; cursor: pointer; position: relative;">

           <video class="scene-thumbnail-video" muted playsinline src="../../_static/SideBySide_COCO_3x/coco_sbs_v2_s07_hq.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid transparent;"></video>

           <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; color: #666; font-family: 'Roboto Mono', monospace;">Scene 03</div>

         </div>

         <div class="scene-thumbnail-container" onclick="showScene('scene09')" style="flex: 1; cursor: pointer; position: relative;">

           <video class="scene-thumbnail-video" muted playsinline src="../../_static/SideBySide_COCO_3x/coco_sbs_v2_s09_hq.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid transparent;"></video>

           <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; color: #666; font-family: 'Roboto Mono', monospace;">Scene 04</div>

         </div>

         <div class="scene-thumbnail-container" onclick="showScene('customized')" style="flex: 1; cursor: pointer; position: relative;">

           <video class="scene-thumbnail-video" muted playsinline src="../../_static/SideBySide_COCO_3x/coco_sbs_v2_customized_hq.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid transparent;"></video>

           <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; color: #666; font-family: 'Roboto Mono', monospace;">Scene 05</div>

         </div>

         <div class="scene-thumbnail-container" onclick="showScene('scene04')" style="flex: 1; cursor: pointer; position: relative;">

           <video class="scene-thumbnail-video" muted playsinline src="../../_static/SideBySide_COCO_3x/masked_coco_sbs_v2_s04_hq.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid transparent;"></video>

           <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; color: #666; font-family: 'Roboto Mono', monospace;">Scene 06</div>

         </div>

         <div class="scene-thumbnail-container" onclick="showScene('scene02')" style="flex: 1; cursor: pointer; position: relative;">

           <video class="scene-thumbnail-video" muted playsinline src="../../_static/SideBySide_COCO_3x/masked_coco_sbs_v2_s02_hq.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid transparent;"></video>

           <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; color: #666; font-family: 'Roboto Mono', monospace;">Scene 07</div>

         </div>

       </div>

     </div>

   </div>

   

   <script>

     function showScene(scene) {

       // Hide all videos

       const videos = document.querySelectorAll('.scene-video');

       videos.forEach(video => {

         video.style.display = 'none';

         video.pause();

       });

       

       // Show selected video and reset to start

       const selectedVideo = document.getElementById(scene + '-video');

       selectedVideo.style.display = 'block';

       

       // Load video source if it's deferred (all scenes except scene05)

       if (selectedVideo.dataset.src && !selectedVideo.src) {

         selectedVideo.src = selectedVideo.dataset.src;

         selectedVideo.preload = 'metadata';

       }

       

       selectedVideo.currentTime = 0; // Reset to beginning

       selectedVideo.play();

       

       // Update button styles

       const buttons = document.querySelectorAll('.scene-btn');

       buttons.forEach(btn => {

         btn.style.backgroundColor = '#dbdbdb';

         btn.style.color = '#363636';

         btn.style.borderColor = '#dbdbdb';

         btn.classList.remove('active');

       });

       

       // Highlight active button

       const activeBtn = event.target;

       if (activeBtn && activeBtn.classList.contains('scene-btn')) {

         activeBtn.style.backgroundColor = '#363636';

         activeBtn.style.color = 'white';

         activeBtn.style.borderColor = '#363636';

         activeBtn.classList.add('active');

       }

       

       // Update thumbnail gallery

       updateSceneThumbnailGallery(scene);

     }

     

     function updateSceneThumbnailGallery(selectedScene) {

       // Update sliding indicator bar position

       const indicatorBar = document.getElementById('scene-indicator-bar');

       const scenePositions = {

         'scene05': '0%',

         'scene06': '14.28%',

         'scene07': '28.56%',

         'scene09': '42.84%',

         'customized': '57.12%',

         'scene04': '71.40%',

         'scene02': '85.68%'

       };

       indicatorBar.style.left = `calc(15px + ${scenePositions[selectedScene]})`;

       

       // Update thumbnail borders and labels

       const thumbnails = document.querySelectorAll('.scene-thumbnail-video');

       const labels = document.querySelectorAll('.scene-thumbnail-container div');

       

       thumbnails.forEach((thumbnail, index) => {

         const scenes = ['scene05', 'scene06', 'scene07', 'scene09', 'customized', 'scene04', 'scene02'];

         const isActive = scenes[index] === selectedScene;

         

         thumbnail.style.border = isActive ? '2px solid #363636' : '2px solid transparent';

         labels[index].style.fontWeight = isActive ? 'bold' : 'normal';

         labels[index].style.color = isActive ? '#363636' : '#666';

       });

       

       // Update button colors to match selected scene

       updateSceneButtonColors(selectedScene);

     }

     

     function updateSceneButtonColors(selectedScene) {

       // Reset all buttons to inactive state

       const buttons = document.querySelectorAll('.scene-btn');

       buttons.forEach(btn => {

         btn.style.backgroundColor = '#dbdbdb';

         btn.style.color = '#363636';

         btn.style.borderColor = '#dbdbdb';

         btn.classList.remove('active');

       });

       

       // Find and highlight the correct button based on scene

       const sceneButtonMap = {

         'scene05': 0,

         'scene06': 1,

         'scene07': 2,

         'scene09': 3,

         'customized': 4,

         'scene04': 5,

         'scene02': 6

       };

       

       const activeButtonIndex = sceneButtonMap[selectedScene];

       if (activeButtonIndex !== undefined && buttons[activeButtonIndex]) {

         const activeBtn = buttons[activeButtonIndex];

         activeBtn.style.backgroundColor = '#363636';

         activeBtn.style.color = 'white';

         activeBtn.style.borderColor = '#363636';

         activeBtn.classList.add('active');

       }

     }

     

     // Initialize the gallery on page load

     document.addEventListener('DOMContentLoaded', function() {

       updateSceneThumbnailGallery('scene05');

     });

   </script>

   

   <!-- Side-by-Side Comparison: Go2 Quadruped Robot Subsection -->

   <div style="text-align: center; margin-top: 3rem; margin-bottom: 2rem;">

     <h3 class="title is-5" style="background-color: black; color: white; padding: 6px 12px; display: inline-block; margin: 0; font-weight: normal; font-size: 1rem;">Side-by-Side Comparison: Go2 Quadruped Robot (3x Speed)</h3>

   </div>

   

   <!-- Go2 Scene Selection Buttons -->

   <div style="text-align: center; margin-bottom: 1.5rem;">

     <button class="button is-primary go2-scene-btn active" onclick="showGo2Scene('s04')" style="margin: 0 0.3rem; background-color: #363636; border-color: #363636; font-family: 'Roboto Mono', monospace;">Scene 01</button>

     <button class="button is-primary go2-scene-btn" onclick="showGo2Scene('s05')" style="margin: 0 0.3rem; background-color: #dbdbdb; color: #363636; border-color: #dbdbdb; font-family: 'Roboto Mono', monospace;">Scene 02</button>

     <button class="button is-primary go2-scene-btn" onclick="showGo2Scene('s07')" style="margin: 0 0.3rem; background-color: #dbdbdb; color: #363636; border-color: #dbdbdb; font-family: 'Roboto Mono', monospace;">Scene 03</button>

     <button class="button is-primary go2-scene-btn" onclick="showGo2Scene('s03')" style="margin: 0 0.3rem; background-color: #dbdbdb; color: #363636; border-color: #dbdbdb; font-family: 'Roboto Mono', monospace;">Scene 04</button>

     <button class="button is-primary go2-scene-btn" onclick="showGo2Scene('s01')" style="margin: 0 0.3rem; background-color: #dbdbdb; color: #363636; border-color: #dbdbdb; font-family: 'Roboto Mono', monospace;">Scene 05</button>

     <button class="button is-primary go2-scene-btn" onclick="showGo2Scene('s16')" style="margin: 0 0.3rem; background-color: #dbdbdb; color: #363636; border-color: #dbdbdb; font-family: 'Roboto Mono', monospace;">Scene 06</button>

     <button class="button is-primary go2-scene-btn" onclick="showGo2Scene('s14')" style="margin: 0 0.3rem; background-color: #dbdbdb; color: #363636; border-color: #dbdbdb; font-family: 'Roboto Mono', monospace;">Scene 07</button>

   </div>

   

   <!-- Go2 Video Container -->

   <div style="text-align: center;">

     <video id="s01-video" class="go2-scene-video" loop muted playsinline controls controlslist="nodownload" preload="none" data-src="../../_static/SideBySide_Go2_3x/go2_sbs_v2_s01_hq.mp4" poster="../../_static/videos/loading-icon.gif" style="border-radius: 10px; width: 85%; max-width: 1200px; display: none; margin: 0 auto;"></video>

     <video id="s03-video" class="go2-scene-video" loop muted playsinline controls controlslist="nodownload" preload="none" data-src="../../_static/SideBySide_Go2_3x/go2_sbs_v2_s03_hq.mp4" poster="../../_static/videos/loading-icon.gif" style="border-radius: 10px; width: 85%; max-width: 1200px; display: none; margin: 0 auto;"></video>

     <video id="s04-video" class="go2-scene-video" autoplay loop muted playsinline controls controlslist="nodownload" preload="metadata" src="../../_static/SideBySide_Go2_3x/go2_sbs_v2_s04_hq.mp4" poster="../../_static/videos/loading-icon.gif" style="border-radius: 10px; width: 85%; max-width: 1200px; display: block; margin: 0 auto;"></video>

     <video id="s05-video" class="go2-scene-video" loop muted playsinline controls controlslist="nodownload" preload="none" data-src="../../_static/SideBySide_Go2_3x/go2_sbs_v2_s05_hq.mp4" poster="../../_static/videos/loading-icon.gif" style="border-radius: 10px; width: 85%; max-width: 1200px; display: none; margin: 0 auto;"></video>

     <video id="s07-video" class="go2-scene-video" loop muted playsinline controls controlslist="nodownload" preload="none" data-src="../../_static/SideBySide_Go2_3x/go2_sbs_v2_s07_hq.mp4" poster="../../_static/videos/loading-icon.gif" style="border-radius: 10px; width: 85%; max-width: 1200px; display: none; margin: 0 auto;"></video>

     <video id="s14-video" class="go2-scene-video" loop muted playsinline controls controlslist="nodownload" preload="none" data-src="../../_static/SideBySide_Go2_3x/go2_sbs_v2_s14_hq.mp4" poster="../../_static/videos/loading-icon.gif" style="border-radius: 10px; width: 85%; max-width: 1200px; display: none; margin: 0 auto;"></video>

     <video id="s16-video" class="go2-scene-video" loop muted playsinline controls controlslist="nodownload" preload="none" data-src="../../_static/SideBySide_Go2_3x/go2_sbs_v2_s16_hq.mp4" poster="../../_static/videos/loading-icon.gif" style="border-radius: 10px; width: 85%; max-width: 1200px; display: none; margin: 0 auto;"></video>

   </div>

   

   <!-- Go2 Preview Gallery -->

   <div style="text-align: center; margin-top: 1rem;">

     <div style="display: inline-block; position: relative; background-color: #f5f5f5; border-radius: 10px; padding: 15px; max-width: 800px;">

       <!-- Sliding Indicator Bar -->

       <div id="go2-scene-indicator-bar" style="position: absolute; top: 10px; left: calc(15px + 0%); width: 14.28%; height: 4px; background-color: #363636; border-radius: 2px; transition: left 0.3s ease;"></div>

       

       <!-- Thumbnail Videos -->

       <div style="display: flex; justify-content: space-between; gap: 8px; margin-top: 10px;">

         <div class="go2-scene-thumbnail-container" onclick="showGo2Scene('s04')" style="flex: 1; cursor: pointer; position: relative;">

           <video class="go2-scene-thumbnail-video" muted playsinline src="../../_static/SideBySide_Go2_3x/go2_sbs_v2_s04_hq.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid #363636;"></video>

           <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; font-weight: bold; color: #363636; font-family: 'Roboto Mono', monospace;">Scene 01</div>

         </div>

         <div class="go2-scene-thumbnail-container" onclick="showGo2Scene('s05')" style="flex: 1; cursor: pointer; position: relative;">

           <video class="go2-scene-thumbnail-video" muted playsinline src="../../_static/SideBySide_Go2_3x/go2_sbs_v2_s05_hq.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid transparent;"></video>

           <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; color: #666; font-family: 'Roboto Mono', monospace;">Scene 02</div>

         </div>

         <div class="go2-scene-thumbnail-container" onclick="showGo2Scene('s07')" style="flex: 1; cursor: pointer; position: relative;">

           <video class="go2-scene-thumbnail-video" muted playsinline src="../../_static/SideBySide_Go2_3x/go2_sbs_v2_s07_hq.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid transparent;"></video>

           <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; color: #666; font-family: 'Roboto Mono', monospace;">Scene 03</div>

         </div>

         <div class="go2-scene-thumbnail-container" onclick="showGo2Scene('s03')" style="flex: 1; cursor: pointer; position: relative;">

           <video class="go2-scene-thumbnail-video" muted playsinline src="../../_static/SideBySide_Go2_3x/go2_sbs_v2_s03_hq.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid transparent;"></video>

           <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; color: #666; font-family: 'Roboto Mono', monospace;">Scene 04</div>

         </div>

         <div class="go2-scene-thumbnail-container" onclick="showGo2Scene('s01')" style="flex: 1; cursor: pointer; position: relative;">

           <video class="go2-scene-thumbnail-video" muted playsinline src="../../_static/SideBySide_Go2_3x/go2_sbs_v2_s01_hq.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid transparent;"></video>

           <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; color: #666; font-family: 'Roboto Mono', monospace;">Scene 05</div>

         </div>

         <div class="go2-scene-thumbnail-container" onclick="showGo2Scene('s16')" style="flex: 1; cursor: pointer; position: relative;">

           <video class="go2-scene-thumbnail-video" muted playsinline src="../../_static/SideBySide_Go2_3x/go2_sbs_v2_s16_hq.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid transparent;"></video>

           <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; color: #666; font-family: 'Roboto Mono', monospace;">Scene 06</div>

         </div>

         <div class="go2-scene-thumbnail-container" onclick="showGo2Scene('s14')" style="flex: 1; cursor: pointer; position: relative;">

           <video class="go2-scene-thumbnail-video" muted playsinline src="../../_static/SideBySide_Go2_3x/go2_sbs_v2_s14_hq.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid transparent;"></video>

           <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; color: #666; font-family: 'Roboto Mono', monospace;">Scene 07</div>

         </div>

       </div>

     </div>

   </div>

   

   <script>

     function showGo2Scene(scene) {

       // Hide all Go2 videos

       const videos = document.querySelectorAll('.go2-scene-video');

       videos.forEach(video => {

         video.style.display = 'none';

         video.pause();

       });

       

       // Show selected video and reset to start

       const selectedVideo = document.getElementById(scene + '-video');

       selectedVideo.style.display = 'block';

       

       // Load video source if it's deferred (all scenes except s04)

       if (selectedVideo.dataset.src && !selectedVideo.src) {

         selectedVideo.src = selectedVideo.dataset.src;

         selectedVideo.preload = 'metadata';

       }

       

       selectedVideo.currentTime = 0; // Reset to beginning

       selectedVideo.play();

       

       // Update button styles

       const buttons = document.querySelectorAll('.go2-scene-btn');

       buttons.forEach(btn => {

         btn.style.backgroundColor = '#dbdbdb';

         btn.style.color = '#363636';

         btn.style.borderColor = '#dbdbdb';

         btn.classList.remove('active');

       });

       

       // Highlight active button

       const activeBtn = event.target;

       if (activeBtn && activeBtn.classList.contains('go2-scene-btn')) {

         activeBtn.style.backgroundColor = '#363636';

         activeBtn.style.color = 'white';

         activeBtn.style.borderColor = '#363636';

         activeBtn.classList.add('active');

       }

       

       // Update thumbnail gallery

       updateGo2SceneThumbnailGallery(scene);

     }

     

     function updateGo2SceneThumbnailGallery(selectedScene) {

       // Update sliding indicator bar position

       const indicatorBar = document.getElementById('go2-scene-indicator-bar');

       const scenePositions = {

         's04': '0%',

         's05': '14.28%',

         's07': '28.56%',

         's03': '42.84%',

         's01': '57.12%',

         's16': '71.40%',

         's14': '85.68%'

       };

       indicatorBar.style.left = `calc(15px + ${scenePositions[selectedScene]})`;

       

       // Update thumbnail borders and labels

       const thumbnails = document.querySelectorAll('.go2-scene-thumbnail-video');

       const labels = document.querySelectorAll('.go2-scene-thumbnail-container div');

       

       thumbnails.forEach((thumbnail, index) => {

         const scenes = ['s04', 's05', 's07', 's03', 's01', 's16', 's14'];

         const isActive = scenes[index] === selectedScene;

         

         thumbnail.style.border = isActive ? '2px solid #363636' : '2px solid transparent';

         labels[index].style.fontWeight = isActive ? 'bold' : 'normal';

         labels[index].style.color = isActive ? '#363636' : '#666';

       });

       

       // Update button colors to match selected scene

       updateGo2SceneButtonColors(selectedScene);

     }

     

     function updateGo2SceneButtonColors(selectedScene) {

       // Reset all buttons to inactive state

       const buttons = document.querySelectorAll('.go2-scene-btn');

       buttons.forEach(btn => {

         btn.style.backgroundColor = '#dbdbdb';

         btn.style.color = '#363636';

         btn.style.borderColor = '#dbdbdb';

         btn.classList.remove('active');

       });

       

       // Find and highlight the correct button based on scene

       const sceneButtonMap = {

         's04': 0,

         's05': 1,

         's07': 2,

         's03': 3,

         's01': 4,

         's16': 5,

         's14': 6

       };

       

       const activeButtonIndex = sceneButtonMap[selectedScene];

       if (activeButtonIndex !== undefined && buttons[activeButtonIndex]) {

         const activeBtn = buttons[activeButtonIndex];

         activeBtn.style.backgroundColor = '#363636';

         activeBtn.style.color = 'white';

         activeBtn.style.borderColor = '#363636';

         activeBtn.classList.add('active');

       }

     }

     

     // Initialize the Go2 gallery on page load

     document.addEventListener('DOMContentLoaded', function() {

       updateGo2SceneThumbnailGallery('s04');

     });

   </script>
