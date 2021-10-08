classdef ForceComputer < handle
     
    properties (Access = private)
        dim
        data
    end
    
    properties (Access = public)
        forceVector
    end
    
    methods (Access = public)
        
        function obj = ForceComputer(cParams)
            obj.init(cParams);
        end
        
        function obj = compute(obj)
            obj.computeForce();
        end
        
    end
    
    methods (Access = private)
        
        function obj = init(obj,cParams)
            obj.dim  = cParams.dim;
            obj.data = cParams.data;
        end
        
        function obj = computeForce(obj)
            f     = zeros(obj.dim.ndof,1);
            Fdata = obj.data.Fdata;
            for k = 1:size(Fdata,1)
                Node = Fdata(k,1); 
                DOF  = Fdata(k,2); 
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
            obj.forceVector = f;
        end
        
    end
end

