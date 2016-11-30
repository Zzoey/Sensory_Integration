function TuningDTWonTRAIN(DataSetStartIndex, DataSetEndIndex)
    
    matlabpool close force local;
    %matlabpool local 3; % # of cores
    matlabpool local 8; % # of cores

    % Datasets into consideration
    Datasets = [cellstr('ChlorineConcentration'), 'CinC_ECG_torso',  'DiatomSizeReduction', 'ECGFiveDays', 'FacesUCR', ... 
        'Haptics', 'InlineSkate', 'ItalyPowerDemand', 'MALLAT', 'MedicalImages', 'Motes', 'SonyAIBORobotSurface', ...
        'SonyAIBORobotSurfaceII', 'Symbols', 'TwoLeadECG', 'WordsSynonyms', 'Cricket_X', 'Cricket_Y', 'Cricket_Z',...
        'uWaveGestureLibrary_X', 'uWaveGestureLibrary_Y', 'uWaveGestureLibrary_Z', '50words', 'Adiac', 'Beef',    ...
        'CBF', 'Coffee', 'ECG200', 'FaceAll', 'FaceFour', 'Fish', 'Gun_Point', 'Lighting2', 'Lighting7', 'Plane', ...
        'OliveOil', 'OSULeaf', 'SwedishLeaf', 'Synthetic_control', 'Trace', 'Two_Patterns', 'Wafer', 'Yoga', 'Car'...
        'StarLightCurves', 'Insect','NonInvasiveFatalECG_Thorax1','NonInvasiveFatalECG_Thorax2'];
    	
    ParameterForDTW = zeros(48,2);
    
    for i = 1:length(Datasets)
 
        if (i>=DataSetStartIndex & i<=DataSetEndIndex)
            
            display(['Dataset being processed: ', char(Datasets(i))]);

            DS = LoadUCRdataset(char(Datasets(i)));

            best_so_far_percentage = 1000;
            best_so_far_accuracy = 0;
            
            for j=100:-1:0
               disp('##################################################');
               disp(j);
               DS.DTW_WindowPercentage = round(j/100 * length(DS.Data(1,:))); 
               
               tic;
               acc = ParallelLeaveOneOutClassifierForDTW(DS);
               toc
               if (acc>=best_so_far_accuracy)
                   
                   best_so_far_accuracy = acc;
                   best_so_far_percentage = j;
                   
               end
               
                
            end
            
            ParameterForDTW(i,:) = [best_so_far_accuracy best_so_far_percentage];
            
        end
    end
    
    dlmwrite(strcat('ParameterForDTW_',num2str(DataSetStartIndex),'_',num2str(DataSetEndIndex)), ParameterForDTW, 'delimiter', '\t');
        
    matlabpool close;

end
