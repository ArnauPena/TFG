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
            obj.testFreeDOFsMatrix();
            obj.testFreeDOFsVector();
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
            obj.K.ll = matrixv(vlv,vlv);
            obj.K.rr = matrixv(vrv,vrv);
            obj.K.rl = matrixv(vrv,vlv);
            obj.K.lr = matrixv(vlv,vrv);
        end
        
        function obj = computeVectorJoint(obj)           
            obj.F.r(:,1) = obj.vector(obj.v.r);
            obj.F.l(:,1) = obj.vector(obj.v.l);       
        end
        
        function init(obj,cParams)
            obj.dim     = cParams.dim;
            obj.data    = cParams.data;
            obj.matrix  = cParams.matrix;
            obj.vector  = cParams.vector;
            obj.Kllt    = cParams.Kll;
            obj.Flt     = cParams.Fl;
        end
        
        function testFreeDOFsMatrix(obj)
            load(obj.Kllt);
            s.tested        = obj.K.ll;
            s.tester        = Kll;
            s.matrixname    = 'Kll';
            TestKglobal = MatrixTester(s);
            TestKglobal.compute();
        end
        
        function testFreeDOFsVector(obj)
            load(obj.Flt);
            s.tested        = obj.F.l;
            s.tester        = Fl;
            s.matrixname    = 'Fl';
            TestKglobal = MatrixTester(s);
            TestKglobal.compute();
        end
        
    end
    
end

