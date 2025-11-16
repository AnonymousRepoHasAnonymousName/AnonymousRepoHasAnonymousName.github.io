.. _urbanverse-gallery-gen:

UrbanVerse-Gen Gallery
=======================

This gallery visualizes the real-world 3D semantic scene layouts distilled from uncalibrated RGB YouTube city-tour videos by the UrbanVerse-Gen pipeline. For detailed usage instructions, see :doc:`../quickstart/urbanverse_gen`.


.. raw:: html

   <!-- Real-world Scene Distillation -->

   <section class="section" id="scene-distillation">

     <div class="container">



       <!-- Scene Selection Buttons -->

       <div style="text-align: center; margin-bottom: 1.5rem;">

         <button class="button is-primary distillation-btn active" onclick="showDistillationScene('rek')" style="margin: 0 0.5rem; background-color: #363636; border-color: #363636; font-family: 'Roboto Mono', monospace;">Scene 01</button>

         <button class="button is-primary distillation-btn" onclick="showDistillationScene('sorrento')" style="margin: 0 0.5rem; background-color: #dbdbdb; color: #363636; border-color: #dbdbdb; font-family: 'Roboto Mono', monospace;">Scene 02</button>

         <button class="button is-primary distillation-btn" onclick="showDistillationScene('rek2')" style="margin: 0 0.5rem; background-color: #dbdbdb; color: #363636; border-color: #dbdbdb; font-family: 'Roboto Mono', monospace;">Scene 03</button>

       </div>

       

       <!-- Video Container -->

       <div class="columns is-centered">

         <div class="column is-full">

           <div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; border: none; outline: none;">

              <video id="sorrento-video" class="distillation-video" loop muted playsinline controls controlslist="nodownload" preload="none" data-src="../../_static/recon_videos_3x/sorrento_dirty.mp4" poster="./static/videos/loading-icon.gif" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: none; border-radius: 0; outline: none; object-fit: cover; display: none;"></video>

              <video id="rek2-video" class="distillation-video" loop muted playsinline controls controlslist="nodownload" preload="none" data-src="../../_static/recon_videos_3x/rek2_dirty.mp4" poster="./static/videos/loading-icon.gif" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: none; border-radius: 0; outline: none; object-fit: cover; display: none;"></video>

             <video id="rek-video" class="distillation-video" autoplay loop muted playsinline controls controlslist="nodownload" preload="metadata"  src="../../_static/recon_videos_3x/rek_dirty.mp4" poster="./static/videos/loading-icon.gif" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: none; border-radius: 0; outline: none; object-fit: cover; display: block;"></video>

           </div>

         </div>

       </div>

       

       <!-- Preview Gallery -->

       <div style="text-align: center; margin-top: 1rem;">

         <div style="display: inline-block; position: relative; background-color: #f5f5f5; border-radius: 10px; padding: 15px; max-width: 600px;">

           <div id="distillation-indicator-bar" style="position: absolute; top: 10px; left: calc(15px + 0%); width: 33.33%; height: 4px; background-color: #363636; border-radius: 2px; transition: left 0.3s ease;"></div>

           <div style="display: flex; justify-content: space-between; gap: 8px; margin-top: 10px;">

             <div class="distillation-thumbnail-container" onclick="showDistillationScene('rek')" style="flex: 1; cursor: pointer; position: relative;">

               <video class="distillation-thumbnail-video" muted playsinline src="../../_static/recon_videos_3x/rek_dirty.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid #363636;"></video>

               <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; font-weight: bold; color: #363636; font-family: 'Roboto Mono', monospace;">Scene 01</div>

             </div>

             <div class="distillation-thumbnail-container" onclick="showDistillationScene('sorrento')" style="flex: 1; cursor: pointer; position: relative;">

               <video class="distillation-thumbnail-video" muted playsinline src="../../_static/recon_videos_3x/sorrento_dirty.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid transparent;"></video>

               <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; color: #666; font-family: 'Roboto Mono', monospace;">Scene 02</div>

             </div>

             <div class="distillation-thumbnail-container" onclick="showDistillationScene('rek2')" style="flex: 1; cursor: pointer; position: relative;">

               <video class="distillation-thumbnail-video" muted playsinline src="../../_static/recon_videos_3x/rek2_dirty.mp4" style="width: 100%; height: 60px; object-fit: cover; border-radius: 5px; border: 2px solid transparent;"></video>

               <div style="text-align: center; margin-top: 3px; font-size: 0.7rem; color: #666; font-family: 'Roboto Mono', monospace;">Scene 03</div>

             </div>

           </div>

         </div>

       </div>

     </div>

   </section>

   <script>
     function showDistillationScene(scene) {
       // Hide all videos
       const videos = document.querySelectorAll('.distillation-video');
       videos.forEach(video => {
         video.style.display = 'none';
         video.pause();
       });
       
       // Show selected video
       const selectedVideo = document.getElementById(scene + '-video');
       if (selectedVideo) {
         selectedVideo.style.display = 'block';
         
         // Load video source if it's deferred (sorrento, rek2)
         if (selectedVideo.dataset.src && !selectedVideo.src) {
           selectedVideo.src = selectedVideo.dataset.src;
           selectedVideo.preload = 'metadata';
         }
         
         selectedVideo.play();
       }
       
       // Update thumbnail gallery
       updateDistillationThumbnailGallery(scene);
       
       // Update button colors
       updateDistillationButtonColors(scene);
     }
     
     function updateDistillationThumbnailGallery(selectedScene) {
       const indicatorBar = document.getElementById('distillation-indicator-bar');
       const scenePositions = {
         'rek': '0%',
         'sorrento': '33.33%',
         'rek2': '66.66%'
       };
       indicatorBar.style.left = `calc(15px + ${scenePositions[selectedScene]})`;
       
       // Update thumbnail borders
       const thumbnails = document.querySelectorAll('.distillation-thumbnail-container');
       thumbnails.forEach(container => {
         const video = container.querySelector('.distillation-thumbnail-video');
         const label = container.querySelector('div:last-child');
         
         if (container.onclick.toString().includes(selectedScene)) {
           video.style.border = '2px solid #363636';
           label.style.color = '#363636';
           label.style.fontWeight = 'bold';
         } else {
           video.style.border = '2px solid transparent';
           label.style.color = '#666';
           label.style.fontWeight = 'normal';
         }
       });
     }
     
     function updateDistillationButtonColors(selectedScene) {
       const buttons = document.querySelectorAll('.distillation-btn');
       const sceneButtonMap = {
         'rek': 0,
         'sorrento': 1,
         'rek2': 2
       };
       
       buttons.forEach((button, index) => {
         if (index === sceneButtonMap[selectedScene]) {
           button.style.backgroundColor = '#363636';
           button.style.borderColor = '#363636';
           button.style.color = 'white';
           button.classList.add('active');
         } else {
           button.style.backgroundColor = '#dbdbdb';
           button.style.borderColor = '#dbdbdb';
           button.style.color = '#363636';
           button.classList.remove('active');
         }
       });
     }
     
     document.addEventListener('DOMContentLoaded', function() {
       updateDistillationThumbnailGallery('rek');
     });
   </script>
