classdef RotationMatrix < handle
    
    properties (Access = public)
        r
    end
    
    properties (Access = private)
        x1
        x2
        y1
        y2
        l
        dim
        data
    end
    
    methods (Access = public)
        
        function obj = RotationMatrix(cParams)
            obj.loadData(cParams);
        end
        
        function obj = computeRotationMatrix(obj)
            obj.computeGeometry();
            R = zeros(6,6,obj.dim.nel);
            dx = obj.x2-obj.x1;
            dy = obj.y2-obj.y1;
            
            for e = 1:obj.dim.nel
                R(1,1:2,e) = 1/obj.l(e)*[dx(e) dy(e)];
                R(2,1:2,e) = 1/obj.l(e)*[-dy(e) dx(e)];
                R(3,3,e)   = 1/obj.l(e);
                R(4,4:5,e) = 1/obj.l(e)*[dx(e) dy(e)];
                R(5,4:5,e) = 1/obj.l(e)*[-dy(e) dx(e)];
                R(6,6,e)   = 1/obj.l(e);
            end
            obj.r = R;
        end

    end
    methods (Access = private)
        
        function obj = loadData(obj,cParams)
            obj.dim = cParams.dim;
            obj.data = cParams.data;
        end
        
        function obj = computeGeometry(obj)
            a = obj.data.x;
            b = obj.data.Tnod;
            e = 1:obj.dim.nel;
            obj.x1 = a(b(e,1),1);
            obj.x2 = a(b(e,2),1);
            obj.y1 = a(b(e,1),2);
            obj.y2 = a(b(e,2),2);
            obj.l = sqrt((obj.x2-obj.x1).^2+(obj.y2-obj.y1).^2);            
        end
    end
    
end

