classdef MatrixSplitterComputer < handle
    
    properties (Access = public)
        K
        F
        ur
        v
    end
    
    properties (Access = private)
        data
        dim
        matrix
        vector
        Kllt
        Flt
    end
    
    methods (Access = public)
        
        function obj = MatrixSplitterComputer(cParams)
            obj.init(cParams)           
        end
        
        function obj = compute(obj)
            obj.computeFixedDOFsSplit();            
            obj.computeFreeDOFsSplit();
            obj.computeMatrixJoint();
            obj.computeVectorJoint();
        end 
        
    end
    
    methods (Access = private)
        
        function obj = computeFixedDOFsSplit(obj)
            fNode   = obj.data.fixNode;
            obj.v.r = size(fNode,1);
            obj.ur  = size(fNode,1);
            
            for k = 1:size(fNode,1)
                Node         = fNode(k,1);
                DOF          = fNode(k,2);
                Displacement = fNode(k,3);
                if DOF==1
                    obj.v.r(k,1) = 3*Node-2;
                end
                if DOF==2
                    obj.v.r(k,1) = 3*Node-1;
                end
                if DOF==3
                    obj.v.r(k,1) = 3*Node;
                end
                obj.ur(k,1) = Displacement;
            end
        end
        
        function obj = computeFreeDOFsSplit(obj)
            j = [1:obj.dim.ndof].';
            obj.v.l = j;
            for k = 1:obj.dim.ndof
                Fixed = any(obj.v.r(:) == j(k));
                if Fixed
                    obj.v.l(k) = 0;
                end
            end
            obj.v.l(obj.v.l == 0) = [];
        end        
        
        function obj = computeMatrixJoint(obj)
            matrixv  = obj.matrix;
            vlv      = obj.v.l;
            vrv      = obj.v.r;           
            Kll      = matrixv(vlv,vlv);
            Krr      = matrixv(vrv,vrv);
            Krl      = matrixv(vrv,vlv);
            Klr      = matrixv(vlv,vrv);
            obj.K.ll = Kll;
            obj.K.rr = Krr;
            obj.K.rl = Krl;
            obj.K.lr = Klr;
        end
        
        function obj = computeVectorJoint(obj)           
            Fr(:,1) = obj.vector(obj.v.r);
            Fl(:,1) = obj.vector(obj.v.l);
            obj.F.l = Fl;
            obj.F.r = Fr;
        end
        
        function init(obj,cParams)
            obj.dim     = cParams.dim;
            obj.data    = cParams.data;
            obj.matrix  = cParams.matrix;
            obj.vector  = cParams.vector;
        end
        
    end
    
end

