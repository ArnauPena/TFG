classdef RotationMatrix
    
    properties
        Rot
    end
    
    methods (Access = public)
        function obj = RotationMatrix()
            rotationMatrixComputer();
        end
    end
    methods (Access = private)
        function computeRotationMatrix(obj)
            a = cParams.data.x;
            b = cParams.data.Tnod;
            R = zeros(6,6,cParams.dim.nel);
            for e = 1:cParams.dim.nel
                x1 = a(b(e,1),1);
                x2 = a(b(e,2),1);
                y1 = a(b(e,1),2);
                y2 = a(b(e,2),2);
                l = sqrt((x2-x1)^2+(y2-y1)^2);
                R(:,:,e) = 1/l*[x2-x1 y2-y1 0 0 0 0;
                    -(y2-y1) x2-x1 0 0 0 0;
                    0 0 l 0 0 0;
                    0 0 0 x2-x1 y2-y1 0;
                    0 0 0 -(y2-y1) x2-x1 0;
                    0 0 0 0 0 l];
            end
            obj.r = R;
            
        end
    end
end

