classdef FEMcomputer < handle

    properties (Access = public)
        u
        displacement
    end
    properties (Access = private)
        data
        dim
        Td
        Kglobal 
        Fext
        R
        K
        staticfiledata
        solvertype
        vl,vr
        Kll, Krr
        Klr, Krl
        Fl, Fr
        ur
    end
    
    methods (Access = public)
        function obj = FEMcomputer(staticfiledata,solver_type)
            obj.staticfiledata = staticfiledata;
            obj.solvertype = solver_type;
            obj.init();
        end
    end
    methods (Access = public)
        function obj = init(obj)
            run(obj.staticfiledata);
            obj.data = data;            obj.dim = dim;
            obj.displacement = displacement;
        end
    end
    methods (Access = public)        
        function obj = solve(obj)
            obj.computeStifnessMatrix();
            obj.computeFext();
            obj.computeMatrixPartition();
            obj.computeDisplacements();
        end  
    end
    
    methods (Access = private)
        function obj = computeStifnessMatrix(obj)
            s.data = obj.data;
            s.dim  = obj.dim;
            kg = StifnessMatrixComputer(s);
            kg.computeStifnessMatrix();
            obj.Kglobal = kg.Kg;

%             a = ConnectivityMatrix(s);
%             a.computeConnectivityMatrix();
%             obj.Td = a.td;
%             s.Td = obj.Td;
%             
%             b = RotationMatrix(s);
%             b.computeRotationMatrix();
%             obj.R = b.r;
%             s.R = obj.R;
%             
%             c = Kcomputer(s);
%             c.computeK();
%             obj.K = c.k;
%             s.K = obj.K;
%                         
%             d = KglobalAssembler(s);
%             d.assembleKglobal();
%             obj.Kglobal = d.kg;
        end
        
        function obj = computeFext(obj)
           s.data = obj.data;
           s.dim = obj.dim;
           f = ForceComputer(s);
           obj.Fext = f.computeForce();
        end
        
        function obj = computeMatrixPartition(obj)
            
            s.data    = obj.data;
            s.dim     = obj.dim;
            s.Kglobal = obj.Kglobal;
            s.Fext    = obj.Fext;
            
            p = MatrixPartitionComputer(s);
            p.computeMatrixPartition();
            
            obj.Kll = p.Kll;
            obj.Klr = p.Klr;
            obj.Krl = p.Krl;
            obj.Krr = p.Krr;
            obj.ur  = p.ur;
            obj.vl  = p.vl;
            obj.vr  = p.vr;
            obj.Fr  = p.Fr;
            obj.Fl  = p.Fl;
        end
        
        function obj = computeDisplacements(obj)
            s.Kll = obj.Kll;
            s.Klr = obj.Klr;
            s.Krl = obj.Krl;
            s.Krr = obj.Krr;
            s.ur  = obj.ur;
            s.vl  = obj.vl;
            s.vr  = obj.vr;
            s.Fr  = obj.Fr;
            s.Fl  = obj.Fl;
            s.st  = obj.solvertype;
            
            sol = DisplacementsComputer(s);
            sol.computeDisplacement();
            obj.u = sol.u;
        end
           
    end 
end 
         
        
        

