function [Ra] = Ra_v2(wind, matriz)
    % Ra_v2 - Calculate Roughness Amplitude (Ra) using a sliding window approach
    %
    % Inputs:
    %   wind   - Window size for calculating roughness (half-width)
    %   matriz - Input 2D matrix of data to analyze
    %
    % Outputs:
    %   Ra     - Matrix of calculated roughness amplitude values
    %
    % Algorithm:
    % 1. Adds zero padding around the input matrix to handle edge cases
    % 2. Uses a sliding window to calculate the mean absolute value
    % 3. Computes local roughness for each pixel in the matrix
    % 4. Replaces zero values with NaN to handle potential edge effects
    %
    % Roughness Amplitude (Ra) is calculated as the mean of absolute values
    % within a local window, providing a measure of surface variability

    % Set window value
    wi = wind;
    
    % Input data matrix
    a = matriz;
    
    % Get matrix dimensions
    [A, B] = size(a);
    
    % Add zero padding to handle matrix edges
    dat = padarray(a, [wi, wi], 0, 'both');
    
    % Initialize roughness amplitude matrix
    Ra = zeros(A, B);
    
    % Calculate full window length
    L = wi * 2 + 1;
    
    % Iterate through each pixel in the matrix
    for i = 1:A
        for j = 1:B
            % Extract local window
            window = dat(i:i+L-1, j:j+L-1);
            
            % Calculate roughness amplitude: mean of absolute values
            Ra(i,j) = sum(abs(window(:))) / (L*L);
        end
    end
    
    % Replace zero values with NaN to handle potential edge effects
    Ra(Ra == 0) = NaN;
end