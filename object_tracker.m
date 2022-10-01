% clear environment
clear;
close all;
clc;

% read the video
video = VideoReader('source.mp4');

% initialize final video
video_with_markers = zeros(video.Height, video.Width, 3, video.NumFrames);

% iterate over frames
for frame = 1:video.NumFrames
    % use the first frame to learn the moving object
    if frame == 1
        % ask user to mark two diagonal points of the moving object
        figure('Name', 'Mark one moving object using 2 diagonal points');
        frameRGB = read(video, 1);
        imshow(frameRGB);
        hold on;
        [x, y] = ginput(2);
        x = round(x);
        y = round(y);

        % show the marked points on frame
        plot(x, y, 'y*');
        hold on;

        % set the location of the moving object to its center
        object_pos = [x(1)+((x(2)-x(1))/2), y(1)+((y(2)-y(1))/2)];

        % create a reference template of the marked moving object
        % this is used to compare frames
        template = zeros(y(2)-y(1)+1, x(2)-x(1)+1);
        frameGRAY = rgb2gray(frameRGB);
        template(:) = frameGRAY(y(1):y(2), x(1):x(2)); 
        template = uint8(template);
        [countsT, binLocationsT] = imhist(template);
        frameGRAY = double(frameGRAY);
        template_new = zeros(size(template, 1), size(template, 2));
    % for all frames other than the first frame
    else
        % read the frame and convert it to grayscale
        frameRGB = read(video, frame); 
        frameGRAY = rgb2gray(frameRGB);
        frameGRAY = double(frameGRAY);
%         % uncomment for online learning (update template each frame)
%         [countsT, binLocationsT] = imhist(template_new);
        hold on;
    end

    % set the searching environment to look for the moving template
    env_x = [object_pos(1)-size(template_new, 2); 
             object_pos(1)+size(template_new, 2)];
    env_y = [object_pos(2)-size(template_new, 1); 
             object_pos(2)+size(template_new, 1)];

    % limit the searching environment to the borders of the frame
    env_x(env_x < 1) = 1;
    env_x(env_x > video.Width) = video.Width;
    env_y(env_y < 1) = 1;
    env_y(env_y > video.Height) = video.Height;

    % find distance between searching area and template
    % uses formula: (a1-b1)^2 + (a2-b2)^2 + ...
    % start iterating over searching environment
    distance = 100000;
    for row = floor(env_y(1)):floor(env_y(2))        
        for col = floor(env_x(1)):floor(env_x(2))
            % crop the size of template inside the searching environment
            frameGRAY_crop = frameGRAY(row:(row+(size(template, 1)-1)), ...
                                       col:(col+(size(template, 2)-1)));
            frameGRAY_crop = uint8(frameGRAY_crop);
            [countsG, binLocationsG] = imhist(frameGRAY_crop);

            % use histograms to check if the current match is better
            if sum((countsT(:) - countsG(:)).^2) < distance
                object_pos = [col+(size(template, 2)-1)/2, ...
                              row+(size(template, 1)-1)/2];
                distance = sum((countsT(:) - countsG(:)).^2);
                template_new = frameGRAY_crop;
            end
        end
    end

    % mark the moving object    
    mark_obj = insertShape(frameRGB, 'filled-circle', ...
        [object_pos(1) object_pos(2) 5], 'LineWidth', 2);
    video_with_markers(:, :, :, frame) = mark_obj;

%    % uncomment to mark the searching environment
%     mark_env = insertShape(mark_obj, 'Rectangle', [env_x(1) env_y(1) ...
%         abs(env_x(1)-env_x(2)) abs(env_y(1)-env_y(2))], 'LineWidth', 2);
%     video_with_markers(:, :, :, frame) = mark_env;

    % update the old template to the new template
    template = template_new;
end

% save to file and play
video_save = VideoWriter('object_tracker.avi'); 
open(video_save);
brighten = 1000/255;
for i = 1:video.NumFrames
    writeVideo(video_save, video_with_markers(:, :, :, i)/1000 * brighten);
end
close(video_save);
implay('object_tracker.avi');