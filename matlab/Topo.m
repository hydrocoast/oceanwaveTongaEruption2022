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
        
        %% grdfile (GMT)
        function grdwrite(obj,filename_grd)
            if numel(obj)>1
                if ~iscell(filename_grd)
                    error('The 2nd argument must be a cell array.')
                end
                for i = 1:numel(obj)
                    obj(i).grdwrite(filename_grd{i});
                end
                return
            end           
            
            if isempty(obj.topo)
                disp('Skip: empty array')
                return
            end
            
            %% print out
            if obj.iscellalign                
                [xvec,yvec] = obj.gridtopo;
            else
                xvec = obj.xlower:obj.cellsize:obj.xlower+(obj.ncols-1)*obj.cellsize;
                yvec = obj.ylower:obj.cellsize:obj.ylower+(obj.nrows-1)*obj.cellsize;
            end
            obj.grdwrite2(xvec,yvec,obj.topo,filename_grd)            
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

        %% read
        function [x,y,z]=grdread2(file)
            %GRDREAD2  Load a GMT grdfile (netcdf format)
            %
            % Uses NetCDF libraries to load a GMT grid file.
            % Duplicates (some) functionality of the program grdread (which requires
            % compilation as a mexfile-based function on each architecture) using
            % Matlab 2008b (and later) built-in NetCDF functionality
            % instead of GMT libraries.
            %
            % Z=GRDREAD2('filename.grd') will return the data as a matrix in Z
            %
            % [X,Y,Z]=GRDREAD2('filename.grd') will also return X and Y vectors
            % suitable for use in Matlab commands such as IMAGE or CONTOUR.
            % e.g., imagesc(X,Y,Z); axis xy
            %
            % Although both gridline and pixel registered grids can be read,
            % pixel registration will be converted to gridline registration
            % for the x- and y-vectors.
            %
            % See also GRDWRITE2, GRDINFO2
            
            % CAUTION: This program currently does little error checking and makes
            % some assumptions about the content and structure of NetCDF files that
            % may not always be valid.  It is tested with COARDS-compliant NetCDF
            % grdfiles, the standard format in GMT 4 and later, as well as GMT v3
            % NetCDF formats.  It will not work with any binary grid file formats.
            % It is the responsibility of the user to determine whether this
            % program is appropriate for any given task.
            %
            % For more information on GMT grid file formats, see:
            % http://www.soest.hawaii.edu/gmt/gmt/doc/gmt/html/GMT_Docs/node70.html
            % Details on Matlab's native netCDF capabilities are at:
            % http://www.mathworks.com/access/helpdesk/help/techdoc/ref/netcdf.html
            
            % GMT (Generic Mapping Tools, <http://gmt.soest.hawaii.edu>)
            % was developed by Paul Wessel and Walter H. F. Smith
            
            % Kelsey Jordahl
            % Marymount Manhattan College
            % Time-stamp: <Wed Jan  6 16:37:45 EST 2010>
            
            % Version 1.1.1, 6-Jan-2010
            % released with minor changes in documentation along with grdwrite2 and grdinfo2
            % Version 1.1, 3-Dec-2009
            % support for GMT v3 grids added
            % Version 1.0, 29-Oct-2009
            % first posted on MATLAB Central
            
            if nargin < 1
                help(mfilename);
                return,
            end
            
            % check for appropriate Matlab version (>=7.7)
            V=regexp(version,'[ \.]','split');
            if (str2num(V{1})<7) || (str2num(V{1})==7 && str2num(V{2})<7)
                ver
                error('grdread2: Requires Matlab R2008b or later!');
            end
            
            ncid = netcdf.open(file, 'NC_NOWRITE');
            if isempty(ncid)
                return,
            end
            
            [ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);
            
            if (nvars==3)                        % new (v4) GMT netCDF grid file
                x=netcdf.getVar(ncid,0)';
                y=netcdf.getVar(ncid,1)';
                z=netcdf.getVar(ncid,2)';
            else
                if (nvars==6)                        % old (v3) GMT netCDF grid file
                    [dimname, dimlen] = netcdf.inqDim(ncid,1);
                    if (dimname=='xysize')             % make sure it really is v3 netCDF
                        xrange=netcdf.getVar(ncid,0)';
                        yrange=netcdf.getVar(ncid,1)';
                        z=netcdf.getVar(ncid,5);
                        dim=netcdf.getVar(ncid,4)';
                        pixel=netcdf.getAtt(ncid,5,'node_offset');
                        if pixel                         % pixel node registered
                            dx=diff(xrange)/double(dim(1)); % convert int to double for division
                            dy=diff(yrange)/double(dim(2));
                            x=xrange(1)+dx/2:dx:xrange(2)-dx/2; % convert to gridline registered
                            y=yrange(1)+dy/2:dy:yrange(2)-dy/2;
                        else                              % gridline registered
                            dx=diff(xrange)/double(dim(1)-1); % convert int to double for division
                            dy=diff(yrange)/double(dim(2)-1);
                            x=xrange(1):dx:xrange(2);
                            y=yrange(1):dy:yrange(2);
                        end
                        z=flipud(reshape(z,dim(1),dim(2))');
                    else
                        error('Apparently not a GMT netCDF grid');
                    end
                else
                    error('Wrong number of variables in netCDF file!');
                end
            end
            
            netcdf.close(ncid)
            
            switch nargout
                case 1,double
                    varargout{1}=z;
                case 3
                    varargout{1}=x;
                    varargout{2}=y;
                    varargout{3}=z;
                otherwise
                    error('grdread2: Incorrect # of output arguments!');
            end
        end
        
        
        %% write
        function grdwrite2(x,y,z,file)
            %GRDWRITE2  Write a GMT grid file
            %
            % Uses built-in NetCDF capability (MATLAB R2008b or later) to
            % write a COARDS-compliant netCDF grid file
            % Duplicates (some) functionality of the program grdwrite (which requires
            % compilation as a mexfile-based function on each architecture) using
            % Matlab 2008b (and later) built-in NetCDF functionality
            % instead of GMT libraries.
            %
            % GRDWRITE2(X,Y,Z,'filename') will create a grid file containing the
            % data in the matrix Z.  X and Y should be either vectors with
            % dimensions that match the size of Z or two-component vectors
            % containing the max and min values for each.
            %
            % See also GRDREAD2, GRDINFO2
            
            % For more information on GMT grid file formats, see:
            % http://www.soest.hawaii.edu/gmt/gmt/doc/gmt/html/GMT_Docs/node70.html
            % Details on Matlab's native netCDF capabilities are at:
            % http://www.mathworks.com/access/helpdesk/help/techdoc/ref/netcdf.html
            
            % GMT (Generic Mapping Tools, <http://gmt.soest.hawaii.edu>)
            % was developed by Paul Wessel and Walter H. F. Smith
            
            % Kelsey Jordahl
            % Marymount Manhattan College
            % http://marymount.mmm.edu/faculty/kjordahl/software.html
            
            % Time-stamp: <Tue Jul 19 16:28:24 EDT 2011>
            
            % Version 1.1.2, 19-Jul-2011
            % Available at MATLAB Central
            % <http://www.mathworks.com/matlabcentral/fileexchange/26290-grdwrite2>
            
            if nargin < 4
                help(mfilename);
                return,
            end
            
            % check for appropriate Matlab version (>=7.7)
            V=regexp(version,'[ \.]','split');
            if (str2num(V{1})<7) || (str2num(V{1})==7 && str2num(V{2})<7)
                ver
                error('grdread2: Requires Matlab R2008b or later!');
            end
            
            ncid = netcdf.create(file, 'NC_SHARE');
            if isempty(ncid)
                return
            end
            
            % set descriptive variables
            conv='COARDS/CF-1.0';
            title=file;
            history='File written by MATLAB function grdwrite2.m';
            desc=['Created ' datestr(now)];
            vers='4.x';                             % is "x" OK?
            
            % check X and Y
            if (~isvector(x) || ~isvector(y))
                error('X and Y must be vectors!');
            end
            if (length(x) ~= size(z,2))    % number of columns don't match size of x
                minx=min(x); maxx=max(x);
                dx=(maxx-minx)/(size(z,2)-1);
                x=minx:dx:maxx;                       % write as a vector
            end
            if (length(y) ~= size(z,1))    % number of rows don't match size of y
                miny=min(y); maxy=max(y);
                dy=(maxy-miny)/(size(z,1)-1);
                y=miny:dy:maxy;                       % write as a vector
            end
            
            % match Matlab class to NetCDF data type
            switch class(z)
                case 'single'
                    nctype='NC_FLOAT';
                    nanfill=single(NaN);
                case 'double'
                    nctype='NC_DOUBLE';
                    nanfill=double(NaN);
                case 'int8'
                    nctype='NC_BYTE';
                    nanfill=intmin(class(z));
                    disp(['Warning: ''No data'' fill value set to ' num2str(nanfill)])
                case 'int16'
                    nctype='NC_SHORT';
                    nanfill=intmin(class(z));
                    disp(['Warning: ''No data'' fill value set to ' num2str(nanfill)])
                case 'int32'
                    nctype='NC_INT';
                    nanfill=intmin(class(z));
                    disp(['Warning: ''No data'' fill value set to ' num2str(nanfill)])
                otherwise
                    error(['Don''t know how to handle data of class ''' class(z) '''.  Try converting to a supported data type (int8, int16, int32, single or double).'])
            end
            
            % global
            netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'Conventions',conv);
            netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'title',title);
            netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'history',history);
            netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'description',desc);
            netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'GMT_version',vers);
            % X
            dimid = netcdf.defDim(ncid,'x',length(x));
            varid = netcdf.defVar(ncid,'x','double',dimid);
            netcdf.putAtt(ncid,varid,'long_name','x');
            netcdf.putAtt(ncid,varid,'actual_range',[min(x) max(x)]);
            netcdf.endDef(ncid);
            netcdf.putVar(ncid,varid,x);
            % Y
            netcdf.reDef(ncid);
            dimid = netcdf.defDim(ncid,'y',length(y));
            varid = netcdf.defVar(ncid,'y','double',dimid);
            netcdf.putAtt(ncid,varid,'long_name','y');
            netcdf.putAtt(ncid,varid,'actual_range',[min(y) max(y)]);
            netcdf.endDef(ncid);
            netcdf.putVar(ncid,varid,y);
            % Z
            netcdf.reDef(ncid);
            varid = netcdf.defVar(ncid,'z',nctype,[0 1]);
            netcdf.putAtt(ncid,varid,'long_name','z');
            netcdf.putAtt(ncid,varid,'_FillValue',nanfill);
            netcdf.putAtt(ncid,varid,'actual_range',[min(z(:)) max(z(:))]);
            netcdf.endDef(ncid);
            netcdf.putVar(ncid,varid,z');
            % close file
            netcdf.close(ncid);
        end

    end
end
