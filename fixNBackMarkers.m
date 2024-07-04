function [EEG] = fixNBackMarkers(EEG,n)
%FIXNBACKMARKERS Summary of this function goes here
%   Detailed explanation goes here
% Check to see if you've run this already
    if contains({'markerconversion'},fieldnames(EEG.etc))
        if EEG.etc.markerconversion == true
            runConversion = input("You have run this already. Running again may cause errors. y to rerun, n to skip.");
        else % run if the field is false
            runConversion = 'y';
        end
    else % run conversion if the field doesn't exist (haven't run it yet)
        runConversion = 'y';
    end

    % Run the marker conversion
    if runConversion == 'y'
        
        emptyeventstoremove = [];
        for i = 1:length(EEG.event)
            origEventName = EEG.event(i).type;
            % Remove blank trials 
            if isempty(origEventName) 
                emptyeventstoremove = [emptyeventstoremove i]; %#ok<AGROW> 
            else
                % first part of the text is the type
                EEG.event(i).type = strcat(char(extract(origEventName,lettersPattern)),'_',num2str(n));
                % digit at the end is the trial number (starting w/ zero)
                EEG.event(i).trialnum = str2double(char(extract(origEventName,digitsPattern)));                
            end
        end
        % Remove all the empty event lines
        EEG.event(emptyeventstoremove) = [];
    end
end

