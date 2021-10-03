classdef ForceComputer < handle
    
    properties (Access = public)
        dim
        data
    end
    
    properties (Access = private)
        F
    end
    
    methods
        function obj = ForceComputer(cParams)
            obj.loadData(cParams);
        end
        
        function obj = loadData(obj,cParams)
            obj.dim  = cParams.dim;
            obj.data = cParams.data;
        end
    
        
        function f = compute(obj)
            f     = zeros(obj.dim.ndof,1);
            Fdata = obj.data.Fdata;
            for k = 1:size(Fdata,1)
                Node = Fdata(k,1); 
                DOF = Fdata(k,2); 
                Fmag = Fdata(k,3); 
                if DOF==1
                    f(3*Node-2,1) = f(3*Node-2,1) + Fmag;
                end
                if DOF==2
                    f(3*Node-1,1) = f(3*Node-1,1) + Fmag;
                end
                if DOF==3
                    f(3*Node,1) = f(3*Node,1) + Fmag;
                end
            end
        end
    end
end

