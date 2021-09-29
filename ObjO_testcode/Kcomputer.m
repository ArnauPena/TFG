classdef Kcomputer < handle
    
    properties (Access = public)
        k
    end
    
    properties (Access = private)
        l
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
            obj.computeGeometry();
            c = obj.data.mat;
            d = obj.data.Tmat;
            K = zeros(6,6,obj.dim.nel);
            L = obj.l;
            
            for e = 1:obj.dim.nel
                val = 1/L(e)^3*c(d(e),3)*c(d(e),1);
                val2 = c(d(e),1)*c(d(e),2)/L(e);
                K(1,1,e)   = val2;
                K(1,4,e)   = -val2;
                K(2,2:3,e) = val*[12 6*L(e)];
                K(2,5:6,e) = val*[-12 6*L(e)];
                K(3,2:3,e) = val*[6*L(e) 4*L(e)^2];
                K(3,5:6,e) = val*[6*L(e) 2*L(e)^2];
                K(4,1,e)   = -val2;
                K(4,4,e)   = val2;
                K(5,2:3,e) = val*[-12 -6*L(e)];
                K(5,5:6,e) = val*[12 -6*L(e)];
                K(6,2:3,e) = val*[6*L(e) 2*L(e)^2];
                K(6,5:6,e) = val*[-6*L(e) 4*L(e)^2];                
            end
            obj.k = K;
        end
        
        function obj = computeGeometry(obj)
            a = obj.data.x;
            b = obj.data.Tnod;
            e = 1:obj.dim.nel;
            x1 = a(b(e,1),1);
            x2 = a(b(e,2),1);
            y1 = a(b(e,1),2);
            y2 = a(b(e,2),2);
   
            for e = 1:obj.dim.nel
            obj.l = sqrt((x2-x1).^2+(y2-y1).^2);
            end
            
        end
    end
end

