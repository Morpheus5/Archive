function [processed_ROIS] = SM_ProcessROIS(roi_ave)
% process ROIS to remove bad frames.

% run from the command line ( after loading in ave_roi, the result of
% SM_plot_roi):

%  processed_ROIS = SM_ProcessROIS(roi_ave);


%1. get rid of blank frames
GG1 = max(roi_ave.raw{1}(1,:));
GG2 = min(roi_ave.raw{1}(1,:));

if GG1-GG2> 4000;

TT = diff(roi_ave.raw{1}(1,:));
[M,I] = max(TT);
[M2,I2] = min(TT);

if M > 2*std(roi_ave.raw{1}(1,:))
    for i = 1:size(roi_ave.raw,2)
    NewI = I+3;
    interpNewI = NewI*20;
    temp{i}(:,:) = roi_ave.raw{i}(:,NewI:(size(roi_ave.raw{i}(1,:),2)));
    interpTemp(:,:,i) = roi_ave.interp_raw(:,(interpNewI:size(roi_ave.interp_raw(:,:,i),2)),i);
    end
else I = 0;
end
    if M2 < 2*std(roi_ave.raw{1}(1,:))
        for ii = 1:size(roi_ave.raw,2)
        NewI2 = I2-I-3;
        interpNewI2 = NewI2*20;
processed_ROIS.raw{ii}(:,:) = temp{ii}(:,1:NewI2);
processed_ROIS.interp_raw(:,:,ii) = interpTemp(:,1:interpNewI2,ii);

        end
    end
    processed_ROIS.StartFrame = NewI;
    processed_ROIS.EndFrames = NewI2;
% figure(); plot(processed_ROIS.raw{1}(1,:));
end
end


%2. Detrend Data

%3. Normalize/Scale data (btw 0 and 1)