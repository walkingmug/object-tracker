# Object Tracking with Template Matching

## Description

Tracks moving objects in a video using template matching by comparing their histograms. It is also possible to use online learning.

![object_tracker](https://user-images.githubusercontent.com/29484054/193376545-b3bbc962-f46e-45bf-8cdd-8bb5e675b941.gif)

[View source](https://www.flickr.com/photos/14615186@N02/5262700641/in/photolist-923HxX-dK9zTv-dK9dGK-dKa4HR-dK8zMe-8UoUcr-HG9akj-J4CCUm-788L45-Hbtoh7-5yv4yf-J2J3bn-J2W5Yn-HULDtm-8hq3Wc-2ioHurg-dDHCwP-5q78EF-HWJnQz-23GYGXK-kwxgWa-p9LwCv-2hnjA6P-Fqzf7N-2hybWwD-2me12iF-2iM2gHJ-9goEbg-2jqmWfY-K4oPLE-SyHNNB-bygrLV-2keA3uJ-7uYRfp-2h7jadd-ne1wWi-57voFu-ctYf17-dZBpqY-2h6Qdtf-GrqPSP-gij1eK-7kLzhj-2jbxRJc-GrqQpv-G8Yhee-N9bQxv-hMhvJ2-51mxiy-GrqQw4)

## Getting Started

### Dependencies

* Required packages: MathWorks Computer Vision Toolbox.
* Developed with MATLAB R2022b.

### Executing program

* Put the video source in the same directory as the main file. To test with the original file, [download it from here](https://www.flickr.com/photos/14615186@N02/5262700641/in/photolist-923HxX-dK9zTv-dK9dGK-dKa4HR-dK8zMe-8UoUcr-HG9akj-J4CCUm-788L45-Hbtoh7-5yv4yf-J2J3bn-J2W5Yn-HULDtm-8hq3Wc-2ioHurg-dDHCwP-5q78EF-HWJnQz-23GYGXK-kwxgWa-p9LwCv-2hnjA6P-Fqzf7N-2hybWwD-2me12iF-2iM2gHJ-9goEbg-2jqmWfY-K4oPLE-SyHNNB-bygrLV-2keA3uJ-7uYRfp-2h7jadd-ne1wWi-57voFu-ctYf17-dZBpqY-2h6Qdtf-GrqPSP-gij1eK-7kLzhj-2jbxRJc-GrqQpv-G8Yhee-N9bQxv-hMhvJ2-51mxiy-GrqQw4) .
* Run the file 'object-tracker.m'
* Mark two diagonal points of the object to be tracked (top-down, left to right).
* The video result is saved in the same directory.

### Changing the data
* A video other than the default one can be tracked by changing the source file:
```
% read the video
video = VideoReader('source.mp4');
```

## Help
* If the tracking is not optimal, try enabling online learning by uncommenting these lines:
```
% % uncomment for online learning (update template each frame)
% [countsT, binLocationsT] = imhist(template_new);
```
* The program may be further debugged by enabling the markers that show what area of a frame is being scanned for the object:
```
% % uncomment to mark the searching environment
% mark_env = insertShape(mark_obj, 'Rectangle', [env_x(1) env_y(1) ...
%     abs(env_x(1)-env_x(2)) abs(env_y(1)-env_y(2))], 'LineWidth', 2);
% video_with_markers(:, :, :, frame) = mark_env;
```

## Authors

Vulnet Alija 

## Version History
* 0.1
    * Initial Release
