function saveTiffFloat(data, filename)
    % Asegúrate de que el nombre del archivo termine en .tif
    if ~endsWith(filename, '.tif')
        filename = [filename '.tif'];
    end

    % Crear un nuevo objeto Tiff
    t = Tiff(filename, 'w');

    % Configurar las etiquetas
    tagstruct.ImageLength = size(data, 1);
    tagstruct.ImageWidth = size(data, 2);
    tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;
    tagstruct.BitsPerSample = 32;
    tagstruct.SamplesPerPixel = 1;
    tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
    tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
    tagstruct.Software = 'MATLAB';

    % Escribir las etiquetas
    t.setTag(tagstruct);

    % Escribir los datos
    t.write(single(data));

    % Cerrar el archivo
    t.close();
end

