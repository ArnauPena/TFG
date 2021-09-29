classdef MatrixPartitionComputer < handle
    
    properties (Access = public)
        Kll,Krr
        Krl,Klr
        Fr,Fl
        ur
        vr,vl
    end
    
    properties (Access = private)
        data
        dim
        Kglobal
        Fext
    end
    
    methods (Access = public)
        
        function obj = MatrixPartitionComputer(cParams)
            obj.init(cParams)           
        end
        
        function obj = computeMatrixPartition(obj)
            obj.computeRestrDOFsMatrixPart();            
            obj.computeFreeDOFsMatrixPart();
            obj.computeMatrixPartAssembly();
            obj.computeForcePartAssembly();  
        end 
        
    end
    
    methods (Access = private)
        
        function obj = computeRestrDOFsMatrixPart(obj)
            fNode  = obj.data.fixNode;
            obj.vr = size(fNode,1);
            obj.ur = size(fNode,1);
            
            for k = 1:size(fNode,1)
                Node = fNode(k,1);
                DOF = fNode(k,2);
                Displacement = fNode(k,3);
                if DOF==1
                    obj.vr(k,1) = 3*Node-2;
                end
                if DOF==2
                    obj.vr(k,1) = 3*Node-1;
                end
                if DOF==3
                    obj.vr(k,1) = 3*Node;
                end
                obj.ur(k,1) = Displacement;
            end
        end
        
        function obj = computeFreeDOFsMatrixPart(obj)
            j = [1:obj.dim.ndof].';
            obj.vl = j;
            for k = 1:obj.dim.ndof
                Fixed = any(obj.vr(:) == j(k));
                if Fixed
                    obj.vl(k) = 0;
                end
            end
            obj.vl(obj.vl == 0) = [];
        end        
        
        function obj = computeMatrixPartAssembly(obj)
            Kg = obj.Kglobal;
            vls = obj.vl;
            vrs = obj.vr;
            
            obj.Kll = Kg(vls,vls);
            obj.Krr = Kg(vrs,vrs);
            obj.Krl = Kg(vrs,vls);
            obj.Klr = Kg(vls,vrs);            
        end
        
        function obj = computeForcePartAssembly(obj)           
            obj.Fr(:,1) = obj.Fext(obj.vr);
            obj.Fl(:,1) = obj.Fext(obj.vl);       
        end
        
        function init(obj,cParams)
            obj.dim     = cParams.dim;
            obj.data    = cParams.data;
            obj.Kglobal = cParams.Kglobal;
            obj.Fext    = cParams.Fext;
        end
        
    end
    
end

