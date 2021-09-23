classdef FEMcomputer < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        data
        dim
        Td
        Kglobal, Fext
        R
        K
        displacement
        staticfiledata
        u
        vl
    end
    
    methods (Access = public)
        function obj = FEMcomputer(staticfiledata)
            obj.staticfiledata = staticfiledata;
            obj.loadData();
            obj.solve();
        end
    end
    methods (Access = public)
        function obj = loadData(obj)
            run(obj.staticfiledata);
            obj.data = data;
            obj.dim = dim;
            obj.displacement = displacement;
        end
    end
    methods (Access = public)        
        function obj = solve(obj)
            obj.computeStifnessMatrix();
            obj.computeFext();
            obj.solveSystem();
        end  
    end
    
    methods (Access = private)
        function obj = computeStifnessMatrix(obj)
            
            s.data = obj.data;
            s.dim = obj.dim;
            
            a = ConnectionMatrix(s);
            a.computeConnectionMatrix();
            obj.Td = a.td;
            s.Td = obj.Td;
            
            b = RotationMatrix(s);
            b.computeRotationMatrix();
            obj.R = b.r;
            s.R = obj.R;
            
            c = Kcomputer(s);
            c.computeK();
            obj.K = c.k;
            s.K = obj.K;
                        
            d = KglobalAssembler(s);
            d.KglobalAssembly();
            obj.Kglobal = d.kg;
        end
        
        function obj = computeFext(obj)
           s.data = obj.data;
           s.dim = obj.dim;
           f = ForceComputer(s);
           f.computeForce();
           obj.Fext = f.F;
        end
   
        function obj = solveSystem(obj)
            s.data = obj.data;
            s.dim = obj.dim;
            s.Kglobal = obj.Kglobal;
            s.R = obj.R;
            s.Fext = obj.Fext;
            syst = SystemSolution(s);
            obj.vl = syst.vl;
            obj.u = syst.u;
        end
           
    end 
end 
         
        
        


