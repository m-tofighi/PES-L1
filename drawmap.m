function y = drawmap(map, nfft, Fs, range, decimation,decimatorType)
    
    if strcmp(decimatorType,'PECS') nargout>7;  end
    map = map;
    nfft = nfft;
    Fs = Fs;
    range = range;
    
    c = 3e8; 
    m2km = 1e-3;
    integrationTime = 0.5;
    T = 1/Fs;
    dopplerBinSize = 1/integrationTime;
    minimumRangeBin = range(1);
    maximumRangeBin = range(2);

    rangeDopplerMapMagnitude = abs(map);
    [numberOfDopplerBins numberOfRangeBins] = size(rangeDopplerMapMagnitude);
    rangeBinVector = [minimumRangeBin:maximumRangeBin]*T*c*m2km;
    dopplerBinVector = (Fs/(nfft*decimation))*[-0.5*numberOfDopplerBins:0.5*numberOfDopplerBins-1].*dopplerBinSize/2;
    colormap(bone)
    surf(rangeBinVector, dopplerBinVector,(rangeDopplerMapMagnitude),'Facecolor','texturemap');  
%  
    map = rangeDopplerMapMagnitude;
    colormap jet;
    xhandle = get(gca, 'XLabel');
    set(xhandle, 'String', 'Bistatic Range(km)');
    yhandle = get(gca, 'YLabel');
    set(yhandle, 'String', 'Doppler Frequency(Hz)');
    axis tight;
    colorbar
   
    y = rangeDopplerMapMagnitude;
    ylim([-500 500])
    
    
end