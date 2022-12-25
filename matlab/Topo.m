classdef Topo
    properties
        ncols
        nrows
        xlower
        ylower
        cellsize
        nodata_value
        topo
        coordinates = 'xy'
        iscellalign = true
    end
    methods 
        function obj = Topo(filename)
            fid = fopen(filename,'r');
            obj.ncols = double(cell2mat(textscan(fid,'%d %*[^\n]',1)));
            obj.nrows = double(cell2mat(textscan(fid,'%d %*[^\n]',1)));
            obj.xlower = cell2mat(textscan(fid,'%f %*[^\n]',1));
            obj.ylower = cell2mat(textscan(fid,'%f %*[^\n]',1));
            obj.cellsize = cell2mat(textscan(fid,'%f %*[^\n]',1));
            obj.nodata_value = cell2mat(textscan(fid,'%f %*[^\n]',1));
            obj.topo = flipud(cell2mat(textscan(fid, repmat('%f', [1,obj.ncols]), obj.nrows)));
            fclose(fid);
        end
    end
    methods 
        function [xv,yv] = gridtopo(obj)
%             xv = obj.xlower:obj.cellsize:obj.xlower+(obj.ncols-1)*obj.cellsize;
%             yv = obj.ylower:obj.cellsize:obj.ylower+(obj.nrows-1)*obj.cellsize;
            xv = obj.xlower+0.5*obj.cellsize:obj.cellsize:obj.xlower+(obj.ncols-0.5)*obj.cellsize;
            yv = obj.ylower+0.5*obj.cellsize:obj.cellsize:obj.ylower+(obj.nrows-0.5)*obj.cellsize;
        end
        function [xv,yv] = gridtopo_corner(obj)
            xv = obj.xlower:obj.cellsize:obj.xlower+obj.ncols*obj.cellsize;
            yv = obj.ylower:obj.cellsize:obj.ylower+obj.nrows*obj.cellsize;
        end
        %% meshgrid xy
        function [X,Y] = meshgridtopo(obj)
            [xvec,yvec] = obj.gridtopo;
            [X,Y] = meshgrid(xvec,yvec);
        end
        %% meshgrid xy
        function [X,Y] = meshgridtopo_corner(obj)
            [xvec,yvec] = obj.gridtopo_corner;
            [X,Y] = meshgrid(xvec,yvec);
        end
                
        %% meshgrid lonlat
        function [LON,LAT] = meshgridtopo_lonlat(obj,lonorg,latorg)
            [X,Y] = obj.meshgridtopo;
            if strcmp(obj.coordinates,'xy')
                [LON,LAT] = GeoUtil.xy2lonlatgrs80(lonorg,latorg,X,Y);
            else
                LON = X;
                LAT = Y;
            end                    
        end
        
        %% meshgrid lonlat
        function [LON,LAT] = meshgridtopo_corner_lonlat(obj,lonorg,latorg)
            [X,Y] = obj.meshgridtopo_corner;
            if strcmp(obj.coordinates,'xy')
                [LON,LAT] = GeoUtil.xy2lonlatgrs80(lonorg,latorg,X,Y);
            else
                LON = X;
                LAT = Y;
            end                    
        end
        
        %% meshgrid xy
        function obj = cell2grid(obj)
            if ~obj.iscellalign; return ;end
            
            [X0,Y0] = obj.meshgridtopo;
            [X1,Y1] = obj.meshgridtopo_corner;
            
            F = griddedInterpolant(X0',Y0',obj.topo','linear','linear');
            obj.topo = F(X1',Y1');
            obj.topo = obj.topo';
%             F = griddedInterpolant(X0(:),Y0(:),obj.topo(:),'linear','linear');
%             TOPO = F(X1(:),Y1(:));
%             obj.topo = reshape(TOPO,size(X1));
%             obj.topo = interp2(X0,Y0,obj.topo,X1,Y1,'linear','linear');
            obj.ncols = obj.ncols+1;
            obj.nrows = obj.nrows+1;            
            obj.iscellalign = false;
        end        
        
        %% pcolor
        function h = plottopo(obj)
            [X,Y] = obj.meshgridtopo;
            h = pcolor(X, Y, obj.topo);
            shading flat
        end

        %% pcolor
        function h = plottopo_lonlat(obj,lonorg,latorg)
            [LON,LAT] = obj.meshgridtopo_lonlat(lonorg,latorg);
            h = pcolor(LON, LAT, obj.topo);
            shading flat
        end
        
        %% coastline
        function [S,h] = coastline(obj)
            [X,Y] = obj.meshgridtopo;
            hold on
            [C,h] = contour(X, Y, obj.topo, [0,0]);
            hold off
            S = obj.contourdata(C);
        end
        function [S,h] = coastline_lonlat(obj)
            [LON,LAT] = obj.meshgridtopo_lonlat;
            hold on
            [C,h] = contour(LON, LAT, obj.topo, [0,0]);
            hold off
            S = obj.contourdata(C);
        end
        
        %% get contourline
        function [S,h] = contourline(obj,val)
            [X,Y] = obj.meshgridtopo;
            hold on
            [C,h] = contour(X, Y, obj.topo, [val,val]);
            hold off
            S = obj.contourdata(C);
            S = S([S.isopen]);
            S = obj.longestcontour(S);
        end
        function [S,h] = contourline_lonlat(obj,val)
            [LON,LAT] = obj.meshgridtopo_lonlat;
            hold on
            [C,h] = contour(LON, LAT, obj.topo, [val,val]);
            hold off
            S = obj.contourdata(C);
            S = S([S.isopen]);
            S = obj.longestcontour(S);
        end
        
        %% printtopo
        function printtopo(obj, filename)
            % % topotype 3
            fmt = [repmat('%17.9e ',[1 obj.ncols]),'\n'];
            fid = fopen(filename,'w');
            fprintf(fid,'%d     mx\n',obj.ncols);
            fprintf(fid,'%d     my\n',obj.nrows);
            fprintf(fid,'%f     xlower\n',obj.xlower);
            fprintf(fid,'%f     ylower\n',obj.ylower);
            fprintf(fid,'%e     cellsize\n',obj.cellsize);
            fprintf(fid,'%d     nodatavalue\n',obj.nodata_value);
            fprintf(fid,fmt,flipud(obj.topo)');
            fclose(fid);
        end
        function printtopo_corner(obj, filename)
            % % topotype 3
            fmt = [repmat('%17.9e ',[1 obj.ncols]),'\n'];
            fid = fopen(filename,'w');
            fprintf(fid,'%d     mx\n',obj.ncols);
            fprintf(fid,'%d     my\n',obj.nrows);
            fprintf(fid,'%f     xllcorner\n',obj.xlower);
            fprintf(fid,'%f     yllcorner\n',obj.ylower);
            fprintf(fid,'%e     cellsize\n',obj.cellsize);
            fprintf(fid,'%d     nodatavalue\n',obj.nodata_value);
            fprintf(fid,fmt,flipud(obj.topo)');
            fclose(fid);
        end        
        
    end
    
    methods (Static)
        function h = plotstructpoint(s)
            hold on
            h = plot(s.xdata,s.ydata,'o','MarkerEdgeColor','k');
            hold off
        end
        function h = plotstructcontour(s)
            hold on
            h = plot(s.xdata,s.ydata,'-');
            hold off
        end
        function s = downsamplecontour(s, num)
            ratio = floor(s.numel/num);
            if ratio <=1; return; end
            if ratio >=2
                s.xdata = downsample(s.xdata,ratio);
                s.ydata = downsample(s.ydata,ratio);
            end
            s.numel = length(s.xdata);
            surp = s.numel - num;
            if surp <= 0; return; end
            s.xdata = s.xdata(ceil(0.5*surp):end-ceil(0.5*surp));
            s.ydata = s.ydata(ceil(0.5*surp):end-ceil(0.5*surp));
            s.numel = length(s.xdata);
%             if rem(surp,2) == 1
%                 s.xdata = s.xdata(2:end);
%                 s.ydata = s.ydata(2:end);
%                 s.numel = length(s.xdata);                
%             end
        end
        function s = longestcontour(s)
            [~,ind] = max([s.numel]);
            s = s(ind);
        end
    end
    
    % % 
    methods (Static)
        function s = contourdata(c)
            %CONTOURDATA Extract Contour Data from Contour Matrix C.
            % CONTOUR, CONTOURF, CONTOUR3, and CONTOURC all produce a contour matrix
            % C that is traditionally used by CLABEL for creating contour labels.
            %
            % S = CONTOURDATA(C) extracts the (x,y) data pairs describing each contour
            % line and other data from the contour matrix C. The vector array structure
            % S returned has the following fields:
            %
            % S(k).level contains the contour level height of the k-th line.
            % S(k).numel contains the number of points describing the k-th line.
            % S(k).isopen is True if the k-th contour is open and False if it is closed.
            % S(k).xdata contains the x-axis data for the k-th line as a column vector.
            % S(k).ydata contains the y-axis data for the k-th line as a column vector.
            %
            % For example: PLOT(S(k).xdata,S(k).ydata)) plots just the k-th contour.
            %
            % See also CONTOUR, CONTOURF, CONTOUR3, CONTOURC.
            
            % From the help text of CONTOURC:
            %   The contour matrix C is a two row matrix of contour lines. Each
            %   contiguous drawing segment contains the value of the contour,
            %   the number of (x,y) drawing pairs, and the pairs themselves.
            %   The segments are appended end-to-end as
            %
            %       C = [level1 x1 x2 x3 ... level2 x2 x2 x3 ...;
            %            pairs1 y1 y2 y3 ... pairs2 y2 y2 y3 ...]
            
            % D.C. Hanselman, University of Maine, Orono, ME 04469
            % MasteringMatlab@yahoo.com
            % Mastering MATLAB 7
            % 2007-05-22
            
            if nargin<1 || ~isfloat(c) || size(c,1)~=2 || size(c,2)<4
                error('CONTOURDATA:rhs',...
                    'Input Must be the 2-by-N Contour Matrix C.')
            end
            
            tol=1e-12;
            k=1;     % contour line number
            col=1;   % index of column containing contour level and number of points
            
            while col<size(c,2) % while less than total columns in c
                s(k).level = c(1,col); %#ok
                s(k).numel = c(2,col); %#ok
                idx=col+1:col+c(2,col);
                s(k).xdata = c(1,idx).'; %#ok
                s(k).ydata = c(2,idx).'; %#ok
                s(k).isopen = abs(diff(c(1,idx([1 end]))))>tol || ...
                    abs(diff(c(2,idx([1 end]))))>tol; %#ok
                k=k+1;
                col=col+c(2,col)+1;
            end
        end


    end
end
