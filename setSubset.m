%***********************************************
%setSubset
%***********************************************
%Enables the selection fo subset/subregion of an EBSD map.
%Select the subset after importing the EBSD data and/or the constructions of grains.
%Subset can be selected as a rectangular region, polygonal region or specific grain.
%***********************************************
%Syntax
%[subset_ebsd,subset_grains] = setSubset(ebsd,options,grains)
%[subset_ebsd] = setSubset(ebsd, options)

%Description
%[subset_ebsd,subset_grains] = setSubset(ebsd,options,grains)
%Inputs EBSD, grain2D and 'options' to select the subregion based on the
%grain2d data.

%[subset_ebsd] = setSubset(ebsd,options)
%Inputs EBSD, grain2D and 'options' to select the subregion based on the
%EBSD data.

%Options:
%'rectangular': Select an rectangle area by inserting the XY coordinates
%'polygonal': Select a polygonal area from mouse click
%'grain': Select a grain from mouse click
%***********************************************
%Prepared by T.Yeo 2024 Sept.
%MTEX 5.11.2
%MATLAB R2024a
%***********************************************
function [subset_ebsd,subset_grains] = setSubset(ebsd,options,grains)

    %For 3 arguments with grains constructed
    if nargin == 3            
        plot(grains,'coordinates','on','WindowState','maximized')
        legend off
        options = convertCharsToStrings(options);
        %***********************************************
        %Specify a rectangular subregion of interest
        %***********************************************
        if options == 'rectangular'
            %Specify xmin, ymin (lower left corner of a rectangle), (dx, dy) extend of a rectangle
            disp ("Enter xmin, ymin (lower left corner of a rectangle), (dx, dy) extend of a rectangle:");
            xmin = input('xmin = ');
            ymin = input('ymin = ');
            dx = input('dx = ');
            dy = input('dy = ');
            region = [xmin,ymin,dx,dy]; 
            
            
            %Overlay the specified region on the phase map
            rectangle('position',region,'edgecolor','k','linewidth',2);
            
            %Select grains within the specified region
            condition = inpolygon(grains,region);
            subset_grains = grains(condition);
        
            %Select the ebsd data of the selected grains
            subset_ebsd = ebsd(subset_grains);
        
        %***********************************************
        %Mouse select a polygonal subregion of interest
        %***********************************************
        elseif options == 'polygonal'
            region = selectPolygon;
        
            disp ("Left click to select the vertices of the polygon " + ...
                "and right click on the final vertex to end ");
        
            %Select grains within the specified region
            condition = inpolygon(grains,region);
            subset_grains = grains(condition);
        
            %Select the ebsd data of the selected grains
            subset_ebsd = ebsd(subset_grains);
        
        %***********************************************
        %Mouse select a grain of interest
        %***********************************************
        elseif options == 'grain'
            selectInteractive(grains,'lineColor','gold')
        
            disp(' ') 
            disp('Select grain with cursor and one mouse click')
            disp(' ')
        
            %This simulates a mouse click
            pause(0.1)
            simulateClick(9000,3500)
            pause(0.1)
        
            %Record grain id
            global indSelected;
        
            %Select ebsd data and grain using grain id
            subset_grains = grains(indSelected);
            subset_ebsd = ebsd(subset_grains);
        
        %***********************************************
        %Error input
        %***********************************************
        else
            disp ('Please input the correct option: rectangular, polygonal, grain')
            return
        end
    end
    %***********************************************
    if nargin == 2
        plot(ebsd,'coordinates','on','WindowState','maximized')
        legend off
        options = convertCharsToStrings(options);
        %***********************************************
        %Specify a rectangular subregion of interest
        %***********************************************
        if options == 'rectangular'
            %Specify xmin, ymin (lower left corner of a rectangle), (dx, dy) extend of a rectangle
            disp ("Enter xmin, ymin (lower left corner of a rectangle), (dx, dy) extend of a rectangle:");
            xmin = input('xmin = ');
            ymin = input('ymin = ');
            dx = input('dx = ');
            dy = input('dy = ');
            region = [xmin,ymin,dx,dy]; 
            
            
            %Overlay the specified region on the phase map
            rectangle('position',region,'edgecolor','k','linewidth',2);
            
            %Select the ebsd data of the selected grains
            condition = inpolygon(ebsd,region);
            subset_ebsd = ebsd(condition);
        
        %***********************************************
        %Mouse select a polygonal subregion of interest
        %***********************************************
        elseif options == 'polygonal'
            region = selectPolygon;
        
            disp ("Left click to select the vertices of the polygon " + ...
                "and right click on the final vertex to end ");
        
            %Select the ebsd data of the selected grains
            condition = inpolygon(ebsd,region);
            subset_ebsd = ebsd(condition);
        
        %***********************************************
        %Error input
        %***********************************************
        else
            disp ('Please input the correct option: rectangular, polygonal')
            return
        end
        %***********************************************
    end
    %***********************************************
    if nargin ~= 2 & nargin ~= 3
        disp ('Please check the fuction input')
    end
end