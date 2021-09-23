classdef Kcomputer < handle
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        k
        dim
        data
    end
    
    methods (Access = public)
        function obj = Kcomputer(cParams)
            obj.loadData(cParams);
        end
        
        function obj = loadData(obj,cParams)
            obj.dim = cParams.dim;
            obj.data = cParams.data;
        end
    end
    methods (Access = public)
        function obj = computeK(obj)
            a = obj.data.x;
            b = obj.data.Tnod;
            c = obj.data.mat;
            d = obj.data.Tmat;
            K = zeros(6,6,obj.dim.nel);
            
            for e = 1:obj.dim.nel
                x1 = a(b(e,1),1);
                x2 = a(b(e,2),1);
                y1 = a(b(e,1),2);
                y2 = a(b(e,2),2);
                l = sqrt((x2-x1)^2+(y2-y1)^2);
            K(:,:,e) = 1/l^3*c(d(e),3)*c(d(e),1)*...
                    [0 0 0 0 0 0;
                    0 12 6*l 0 -12 6*l;
                    0 6*l 4*l^2 0 -6*l 2*l^2;
                    0 0 0 0 0 0;
                    0 -12 -6*l 0 12 -6*l;
                    0 6*l 2*l^2 0 -6*l 4*l^2] + ...
                    c(d(e),1)*c(d(e),2)/l*...
                    [1 0 0 -1 0 0;
                    0 0 0 0 0 0;
                    0 0 0 0 0 0;
                    -1 0 0 1 0 0;
                    0 0 0 0 0 0;
                    0 0 0 0 0 0];
            end
            obj.k = K;
        end
    end
end

