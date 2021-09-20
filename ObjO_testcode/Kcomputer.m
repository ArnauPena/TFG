classdef Kcomputer
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        k
    end
    
    methods
        function obj = Kcomputer()
            computeK();
        end
        
        function obj = computeK(obj)
            a = cParams.data.x;
            b = cParams.data.Tnod;
            c = cParams.data.mat;
            d = cParams.data.Tmat;
            K = zeros(6,6,cParams.dim.nel);
            
            for e = 1:cParams.dim.nel
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

