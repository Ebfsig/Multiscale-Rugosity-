function process_reef_rugosity(input_path, output_path)
    % process_reef_rugosity - Batch process reef rugosity from geotiff files
    %
    % Inputs:
    %   input_path  - Path to directory containing reef DEM files
    %   output_path - Path to save rugosity analysis results
    %
    % Functionality:
    % 1. Finds all .tif files in input directory
    % 2. Calculates rugosity levels using wavelet decomposition
    % 3. Saves rugosity results as separate TIFF files
    
    % Create output directory if it doesn't exist
    if ~exist(output_path, 'dir')
        mkdir(output_path);
    end
    
    % Find all .tif files in the input directory
    tiff_files = dir(fullfile(input_path, '*.tif'));
    
    % Check if any .tif files were found
    if isempty(tiff_files)
        error('No .tif files found in the specified directory: %s', input_path);
    end
    
    % Process each reef site
    for k = 1:length(tiff_files)
        % Current file name (without extension)
        current_file = tiff_files(k).name;
        [~, site_name, ~] = fileparts(current_file);
        
        % Construct full input file path
        input_file = fullfile(input_path, current_file);
        
        try
            % Read geotiff file
            [aa, refmat, bbox] = geotiffread(input_file);
            
            % Calculate rugosity levels
            % Window size set to 4 pixels
            [Rl, Rg] = Roug(4, aa);
            
            % Combine rugosity levels
            total = Rl + Rg;
            
            % Prepare output filenames
            name_rl = fullfile(output_path, ['Rl_', site_name, '.tif']);
            name_rg = fullfile(output_path, ['Rg_', site_name, '.tif']);
            name_total = fullfile(output_path, ['Total_', site_name, '.tif']);
            
            % Save rugosity results
            saveTiffFloat(Rl, name_rl);
            saveTiffFloat(Rg, name_rg);
            saveTiffFloat(total, name_total);
            
            % Display current processing status
            fprintf('Processed: %s\n', site_name);
        catch ME
            % Error handling for individual files
            fprintf('Error processing %s: %s\n', current_file, ME.message);
            continue;
        end
    end
    
    fprintf('Rugosity analysis completed for all sites.\n');
end

% Example usage
% process_reef_rugosity('G:DEM/', 'Rugosity')