function [Rl, Rg] = Roug(window, matriz)
    % Roug - Calculate Rugosity Levels using Wavelet Decomposition
    %
    % Inputs:
    %   window  - Window size for roughness calculation
    %   matriz  - 3D input matrix (assumes first slice used) or 2D
    %
    % Outputs:
    %   Rl      - Roughness level from detail coefficients
    %   Rg      - Roughness level from wavelet coefficients
    %
    % Algorithm Steps:
    % 1. Extract first slice from 3D matrix
    % 2. Ensure matrix is processed row-wise
    % 3. Handle missing/no-data values
    % 4. Apply wavelet decomposition
    % 5. Calculate roughness using local amplitude method

    % Extract first slice from 3D matrix
    aa = matriz;
    a = aa(:,:,1);

    % Determine matrix dimensions
    [A, B] = size(a);

    % Ensure processing along rows (transpose if needed)
    if A < B
        a = a';
    end
    [A, B] = size(a);

    % Data cleaning and transformation
    % Invert values to handle non-standard data representation
    a = a * -1;

    % Replace values above threshold with NaN
    posa = a > 30;
    a(posa) = NaN;

    % Normalize data by subtracting minimum value
    mina = min(min(a));
    a = a - mina;

    % Initialize output matrices
    wavines = NaN(A, B);
    ro1 = wavines;
    ro2 = ro1;
    ro3 = ro1;
    ro4 = ro1;

    % Process each row using wavelet decomposition
    for i = 1:A
        % Extract row and handle NaN values
        da = a(i,:);
        d = isnan(da);
        da(d) = 0;

        % Wavelet decomposition parameters
        levelForReconstruction = [true, true, true, true, true];

        % Perform Discrete Wavelet Transform (DWT)
        wt = modwt(double(da), 'db4', 4);
        
        % Construct Multiresolution Analysis (MRA) matrix
        mra = modwtmra(wt, 'db4');

        % Sum multiresolution signals
        da1 = sum(mra(levelForReconstruction,:), 5);

        % Store decomposition results
        wavines(i,:) = da1(5,:);
        ro1(i,:) = da1(1,:);
        ro2(i,:) = da1(2,:);
        ro3(i,:) = da1(3,:);
        ro4(i,:) = da1(4,:);
    end

    % Combine detail coefficients
    waf = (ro1 + ro2 + ro3 + ro4);

    % Calculate roughness levels using Ra_v2 function
    Rl = Ra_v2(window, waf);      % Roughness from detail coefficients
    Rg = Ra_v2(window, wavines);  % Roughness from wavelet coefficients
end

